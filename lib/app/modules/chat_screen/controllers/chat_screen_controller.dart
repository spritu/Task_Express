import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    required this.reciverId
  });
}

class ChatScreenController extends GetxController {
  // List of chat items
  RxList<ChatItem> chats = <ChatItem>[].obs;

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLastMessages();
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