import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatItem {
  final String message;
  final String timestamp;
  final String firstName;
  final String lastName;
  final String profilePic;
  final String reciverId;

  ChatItem({
    required this.message,
    required this.timestamp,
    required this.firstName,
    required this.lastName,
    required this.profilePic,
    required this.reciverId,
  });
}

class ChatScreenController extends GetxController {
  // List of chat items
  RxList<ChatItem> chats = <ChatItem>[].obs;

  final RxList<types.Message> messages = <types.Message>[].obs;
  final Rxn<types.User> user = Rxn<types.User>();
  late IO.Socket socket;
  RxString userId = ''.obs;
  final player = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    fetchLastMessages();
    connectSocket();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchLastMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    print("📌 userId: $userId");

    if (userId == null || userId.isEmpty) {
      print("❌ userId not found in SharedPreferences.");
      return;
    }

    final url = Uri.parse(
      'https://jdapi.youthadda.co/conversationlastmessages?userId=$userId',
    );

    try {
      final response = await http.get(url);
      print("📥 API Status: ${response.statusCode}");
      print("📥 Raw Response12: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonData = responseData['data'];

        print("📊 Total chats found: ${jsonData.length}");

        chats.clear();

        for (var item in jsonData) {
          final lm = item['lastMessage'];
          final chatItem = ChatItem(
            message: lm?['message'] ?? 'No message',
            timestamp: lm?['timestamp'] ?? 'No timestamp',
            reciverId: item['receiverId'],
            firstName: item['firstName'] ?? 'N/A',
            lastName: item['lastName'] ?? 'N/A',
            profilePic: item['profilePic'] ?? '',
          );
          chats.add(chatItem);
        }

        for (var chat in chats) {
          print('--- Chat ---');
          print('xyz:${chat.reciverId}');
          print('Name: ${chat.firstName} ${chat.lastName}');
          print('Message: ${chat.message}');
          print('Timestamp: ${chat.timestamp}');
          print('Profile Pic: ${chat.profilePic}');
        }
      } else {
        print("❌ Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("⚠️ Exception: $e");
    }
  }



  void playNotificationSound() async {
    await player.setVolume(1.0); // Ensure full volume
    await player.play(AssetSource('assets/sounds/sms.mp3'));
  }

  void connectSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) return;
    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,"forceNew":true,
      'auth': {
        'user': {'_id': userId, 'firstName': 'plumber naman'},
      },
    });
    print('1234:${userId}');
    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to socket contacts list');
    });

    socket.onDisconnect((_) {
      print('❌ Disconnected from socket');
    });

    socket.onConnectError((err) {
      print('🚫 Connect Error: $err');
    });

    socket.onError((err) {
      print('🔥 Socket Error: $err');
    });

    socket.on('message', (data) {
      final ChatScreenController chatScreenController = Get.put(
        ChatScreenController(),
      );
      chatScreenController.fetchLastMessages();
      //fetchChatHistory();
      print('📩 Received message: $data');

      playNotificationSound();

      final msg = types.TextMessage(
        id: data['_id'] ?? const Uuid().v4(),
        text: data['message'] ?? '',
        author: types.User(id: data['senderId']),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      messages.insert(0, msg);
    });
  }

  String formatTimestamp(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return DateFormat('hh:mm a').format(dateTime); // e.g. 04:48 PM
    } catch (e) {
      print("⚠️ Timestamp parse error: $e");
      return 'Invalid time';
    }
  }
}