import 'dart:convert';
import 'dart:io';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';

class ChatItem {
  final String message;
  final String timestamp;
  final String reciverId;
  final String firstName;
  final String lastName;
  final String profilePic;
  late final bool isRead;
  late final int unreadCount;

  ChatItem({
    required this.message,
    required this.timestamp,
    required this.reciverId,
    required this.firstName,
    required this.lastName,
    required this.profilePic,
    this.isRead = true,
    this.unreadCount = 0,
    required unredviewNotify,
  });
}

class ProviderChatScreenController extends GetxController {
  RxList<ChatItem> chats = <ChatItem>[].obs;
  RxBool hasNewMessage = false.obs;

  final RxList<types.Message> messages = <types.Message>[].obs;
  final Rxn<types.User> user = Rxn<types.User>();
  late IO.Socket socket;
  RxString userId = ''.obs;
  var receiverId = ''.obs;
  var hasUnreadMessages = false.obs;
  var hasUnreadnotify = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchLastMessages();
    connectSocket();
    hasNewMessage.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void connectSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final firstName = prefs.getString("firstName");
    final lastName = prefs.getString('lastName');
    print("fullname print: $firstName $lastName");
    if (userId == null) return;
    print(" Service provider:$userId");
    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      "forceNew": true,
      'auth': {
        'user': {'_id': userId, 'firstName': firstName, 'lastName': lastName},
      },
    });
    print('1234:${userId}');
    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to socket contacts list provider');
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
      // ProviderChatScreenController providerChatScreenController = Get.put(
      //   ProviderChatScreenController(),
      // );
      // providerChatScreenController.fetchLastMessages();
      fetchLastMessages();
      print('📩 Received message: $data');

      final msg = types.TextMessage(
        id: data['_id'] ?? const Uuid().v4(),
        text: data['message'] ?? '',
        author: types.User(id: data['senderId']),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      messages.insert(0, msg);
    });
  }

  Future<void> fetchLastMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null || userId.isEmpty) return;

    final url = Uri.parse(
      'https://jdapi.youthadda.co/conversationlastmessages?userId=$userId',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonData = responseData['data'];
        print('chsttttttt: $jsonData');

        chats.clear();
        bool unreadFound = false;
        bool unreadNotify = false;

        for (var item in jsonData) {
          final lm = item['lastMessage'];
          receiverId.value = item['receiverId'];
          final unreadCount = item['unseenCount'] ?? 0;
          final unredviewNotify = item['unseenChatNotificationCount'] ?? 0;
          if (unreadCount > 0) unreadFound = true;
          if (unredviewNotify > 0) unreadNotify = true;

          print(
            "viewallmessage: $receiverId   unseenCount: ${item['unseenCount']}",
          );
          final chatItem = ChatItem(
            message: lm?['message'] ?? 'No message',
            timestamp: lm?['timestamp'] ?? 'No timestamp',
            reciverId: item['receiverId'],
            firstName: item['firstName'] ?? 'N/A',
            lastName: item['lastName'] ?? 'N/A',
            profilePic: item['profilePic'] ?? '',
            isRead: (lm?['viewall']?.toString().toLowerCase() == 'true'),
            unreadCount: unreadCount,
            unredviewNotify: unredviewNotify,
          );
          chats.add(chatItem);
          // hasUnreadMessages.value = unreadFound;
          // hasUnreadnotify.value = unreadNotify;
        }
        hasUnreadMessages.value = unreadFound;
        hasUnreadnotify.value = unreadNotify;
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> markChatAsRead(String receiverId) async {
    final index = chats.indexWhere((chat) => chat.reciverId == receiverId);
    if (index != -1) {
      final chat = chats[index];
      chats[index] = ChatItem(
        message: chat.message,
        timestamp: chat.timestamp,
        reciverId: chat.reciverId,
        firstName: chat.firstName,
        lastName: chat.lastName,
        profilePic: chat.profilePic,
        isRead: true,
        unreadCount: 0,
        unredviewNotify: 0,
      );
      chats.refresh();
    }

    // Optional: API hit to mark as seen
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

  // Future<void> fetchLastMessages() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getString('userId');
  //   print("📌 userIdpro: $userId");
  //
  //   if (userId == null || userId.isEmpty) {
  //     print("❌ userId not found in SharedPreferences.");
  //     return;
  //   }
  //
  //   final url = Uri.parse(
  //     'https://jdapi.youthadda.co/conversationlastmessages?userId=$userId',
  //   );
  //
  //   try {
  //     final response = await http.get(url);
  //     print("📥 API Status: ${response.statusCode}");
  //     print("📥 Raw Response12: ${response.body}");
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       final List<dynamic> jsonData = responseData['data'];
  //
  //       print("📊 Total chats found: ${jsonData.length}");
  //
  //       chats.clear();
  //
  //       for (var item in jsonData) {
  //         final lm = item['lastMessage'];
  //         final chatItem = ChatItem(
  //           message: lm?['message'] ?? 'No message',
  //           timestamp: lm?['timestamp'] ?? 'No timestamp',
  //           reciverId: item['receiverId'],
  //           firstName: item['firstName'] ?? 'N/A',
  //           lastName: item['lastName'] ?? 'N/A',
  //           profilePic: item['profilePic'] ?? '',
  //           isRead: lm?['isRead'] ?? true, // from API
  //           unreadCount: item['unreadCount'] ?? 0, // from API
  //         );
  //         chats.add(chatItem);
  //       }
  //
  //       for (var chat in chats) {
  //         print('--- Chat ---');
  //         print('xyz:${chat.reciverId}');
  //         print('Name: ${chat.firstName} ${chat.lastName}');
  //         print('Message: ${chat.message}');
  //         print('Timestamp: ${chat.timestamp}');
  //         print('Profile Pic: ${chat.profilePic}');
  //       }
  //     } else {
  //       print("❌ Error: ${response.reasonPhrase}");
  //     }
  //   } catch (e) {
  //     print("⚠️ Exception: $e");
  //   }
  //
  //   void clearNewMessageFlag() {
  //     hasNewMessage.value = false;
  //   }
  // }

  //TODO: Implement ProviderChatScreenController
  // final RxList<types.Message> messages = <types.Message>[].obs;
  //
  // final types.User user = const types.User(id: 'user-123');
  //
  // @override
  // void onInit() {
  //   super.onInit();
  //   messages.addAll([
  //     types.TextMessage(
  //       author: const types.User(id: 'admin'),
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       id: const Uuid().v4(),
  //       text: 'Welcome to the chat!',
  //     ),
  //   ]);
  // }

  // void handleSendPressed(types.PartialText message) {
  //   final textMessage = types.TextMessage(
  //     author: user,
  //     createdAt: DateTime.now().millisecondsSinceEpoch,
  //     id: const Uuid().v4(),
  //     text: message.text,
  //   );
  //   messages.insert(0, textMessage);
  // }

  // Future<void> handleImagePick() async {
  //   final picker = ImagePicker();
  //   final result = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (result != null) {
  //     final file = File(result.path);
  //
  //     final imageMessage = types.ImageMessage(
  //       author: user,
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       id: const Uuid().v4(),
  //       name: result.name,
  //       size: await file.length(),
  //       uri: file.path,
  //     );
  //
  //     messages.insert(0, imageMessage);
  //   }
  // }
}
