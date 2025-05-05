import 'dart:convert';
import 'dart:io';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  final RxList<types.Message> messages = <types.Message>[].obs;
  final RxList lastMessages = [].obs;
  final RxString firstName = ''.obs;
  final RxString lastName = ''.obs;
  final RxString imagePath = ''.obs;
  final RxString userId = ''.obs;
  late types.User currentUser;final RxString receiverName = 'Helper Name'.obs; // you can update it dynamically later
  final RxString receiverImage = ''.obs;

  late IO.Socket socket;

  String receiverId = '6800d9e2764d14e5400cc38e'; // hardcoded for demo

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  final RxBool isReady = false.obs;

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstName.value = prefs.getString('firstName') ?? '';
    lastName.value = prefs.getString('lastName') ?? '';
    userId.value = prefs.getString('userId') ?? '';
    imagePath.value = prefs.getString('userImg') ?? '';

    if (userId.value.isNotEmpty) {
      currentUser = types.User(
        id: userId.value,
        firstName: firstName.value,
        imageUrl: imagePath.value,
      );
      connectSocket();
      fetchLastMessages();
      isReady.value = true; // ✅ mark ready
    }
  }


  Future<void> fetchLastMessages() async {
    try {
      var url = Uri.parse("https://jdapi.youthadda.co/conversationlastmessages?userId=${userId.value}");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        lastMessages.value = data['data'] ?? [];
      } else {
        print("❌ API Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❗ Exception: $e");
    }
  }

  void connectSocket() {
    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {
        'user': {
          '_id': userId.value,
          'firstName': firstName.value,
          'image': imagePath.value,
        },
      },
    });

    socket.connect();

    socket.onConnect((_) => print("✅ Socket connected"));

    socket.on('message', (data) {
      print("📩 New message: $data");
      final incoming = types.TextMessage(
        author: types.User(
          id: data['sender']['_id'],
          firstName: data['sender']['firstName'],
          imageUrl: data['sender']['image'],
        ),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: data['message'],
      );
      messages.insert(0, incoming);
    });

    socket.on('disconnect', (_) => print("❌ Socket disconnected"));
    socket.onConnectError((err) => print("🚫 Connect error: $err"));
    socket.onError((err) => print("🔥 Socket error: $err"));
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: currentUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    messages.insert(0, textMessage);

    socket.emit('message', {
      'receiver': receiverId,
      'message': message.text,
      'type': 'text',
    });
  }

  Future<void> handleImagePick() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);

    if (result != null) {
      final file = File(result.path);
      final imageMessage = types.ImageMessage(
        author: currentUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        name: result.name,
        size: await file.length(),
        uri: file.path,
      );
      messages.insert(0, imageMessage);
    }
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
