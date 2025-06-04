import 'dart:convert';
import 'dart:io';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../chat_screen/controllers/chat_screen_controller.dart';

late ChatScreenController chatScreenController = Get.put(
  ChatScreenController(),
);

class ChatController extends GetxController {
  final RxList<types.Message> messages = <types.Message>[].obs;
  final Rxn<types.User> user = Rxn<types.User>();
  final RxBool isInitialized = false.obs;
  //late types.User user; // Sender (current user)
  late String receiverId;
  RxString userId = ''.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  RxString userImg = ''.obs;
  RxString receiverName = ''.obs;
  var receiverImage = ''.obs;
  final arguments = Get.arguments;
  final phoneNumber = ''.obs;
  // late String receiverName;
  // late String receiverImage;
  late final Map<String, dynamic> _arguments;
  var selectedIndex = 0.obs;
  //var receiverImage =''.obs;
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  late IO.Socket socket;

  @override
  void onInit() {
    super.onInit();
    initializeChat();
    final args = Get.arguments ?? {};
    receiverImage.value = args['receiverImage'] ?? '';
    print("🟢 RECEIVER IMAGE: ${receiverImage.value}");

    // Future.delayed(Duration(milliseconds: 500), () async {
    //   await initializeChat();
    // });
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> initializeChat() async {
    // Retrieve userId from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final baseUrl = 'https://jdapi.youthadda.co/';
    userImg.value = '$baseUrl${prefs.getString('userImg')}';
    print('object99:${userImg.value}');
    await prefs.reload();
    final userId2 = prefs.getString('userId') ?? '';
    firstName.value = prefs.getString("firstName")!;
    lastName.value = prefs.getString('lastName')!;
    print("fullname print user chat22222: $firstName $lastName");

    if (userId2.isEmpty) {
      print('❌ User ID not found in SharedPreferences');
      return;
    }
    user.value = types.User(id: userId2, imageUrl: userImg.value);
    final Map<String, dynamic> data = Get.arguments ?? {};
    print('navigateData: $data');
    if (data != null) {
      receiverId = data['receiverId'] ?? '';
      receiverName.value = data['receiverName'] ?? 'No Name';
      receiverImage.value = data['userImg'] ?? '';
      print('✅ Receiver ID: $receiverId');
      print('✅ Receiver Name: $receiverName');
      print('✅ Receiver Image: $receiverImage');
      print('✅ isImageNull: ${receiverImage == null || receiverImage.isEmpty}');
    } else {
      print('❌ No arguments received');
    }

    connectSocket();
    fetchChatHistory();
    isInitialized.value = true;
  }

  Future<void> fetchChatHistory() async {
    if (user.value == null || receiverId.isEmpty) return;

    try {
      final response = await http.get(
        Uri.parse(
          'https://jdapi.youthadda.co/chatlist?senderId=${user.value!.id}&receiverId=$receiverId',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('chatingdata5:${data}');
        if (data is List) {
          final List<types.TextMessage> history = [];

          for (var msg in data) {
            if (msg is Map<String, dynamic>) {
              int createdAtEpoch;
              final createdAt = msg['createdAt'];
              print('rahul:${createdAt}');

              if (createdAt is int) {
                createdAtEpoch = createdAt;
              } else if (createdAt is String) {
                createdAtEpoch =
                    DateTime.tryParse(createdAt)?.millisecondsSinceEpoch ??
                    DateTime.now().millisecondsSinceEpoch;
              } else {
                createdAtEpoch = DateTime.now().millisecondsSinceEpoch;
              }

              final senderId = msg['sender']?['_id'] ?? '';
              history.add(
                types.TextMessage(
                  id: msg['_id'] ?? const Uuid().v4(),
                  text: msg['message'] ?? '',
                  author: types.User(id: senderId),
                  createdAt: createdAtEpoch,
                ),
              );
            }
          }

          messages.assignAll(history); // 👈 old to new
        } else {
          print("❌ Unexpected response format");
        }
      } else {
        print("❌ Failed to fetch chat: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Error fetching chat: $e");
    }
  }

  void makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch phone dialer',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void connectSocket() {
    if (user.value == null) return;
    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {
        'user': {
          '_id': user.value!.id,
          'firstName': firstName.value,
          'lastName': lastName.value,
        },
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to socket');
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
      fetchChatHistory();
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

  final RxString imagePath = ''.obs;
  void handleSendPressed(types.PartialText message) {
    if (user.value == null) return;
    final textMessage = types.TextMessage(
      author: user.value!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    print('CreatedAt: ${textMessage.createdAt}');

    messages.insert(0, textMessage);
    messages.refresh();

    final payload = {
      'senderId': user.value!.id,
      'receiver': receiverId,
      'message': message.text,
      'type': 'text',
      'createdAt': textMessage.createdAt,
    };
    socket.emit('message', payload);
  }

  Future<void> handleImagePick() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);

    if (result != null) {
      final file = File(result.path);

      final imageMessage = types.ImageMessage(
        author: user.value!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        name: result.name,
        size: await file.length(),
        uri: file.path,
      );
      print("Image URI: ${imageMessage}");
      messages.insert(0, imageMessage);

      // Optional: Upload image to server
    }
  }

  @override
  void onClose() {
    socket.dispose();
    //  chatScreenController.fetchLastMessages();
    print("🔌 Socket closed");
    super.onClose();
  }
}

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:uuid/uuid.dart';
//
// import '../../chat_screen/controllers/chat_screen_controller.dart';
//
// late ChatScreenController chatScreenController = Get.put(ChatScreenController());
// class ChatController extends GetxController {
//   final RxList<types.Message> messages = <types.Message>[].obs;
//   final Rxn<types.User> user = Rxn<types.User>();
//   final RxBool isInitialized = false.obs;
//   //late types.User user; // Sender (current user)
//   late String receiverId;
//   RxString userId = ''.obs;
//   RxString userImg = ''.obs;
//   RxString receiverName = ''.obs;
//   RxString receiverImage = ''.obs;
//
//   // late String receiverName;
//   // late String receiverImage;
//   late final Map<String, dynamic> _arguments;
//
//
//
//   late IO.Socket socket;
//
//   @override
//   void onInit() {
//     super.onInit();
//     initializeChat();
//     // Future.delayed(Duration(milliseconds: 500), () async {
//     //   await initializeChat();
//     // });
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//   }
//
//   Future<void> initializeChat() async {
//     // Retrieve userId from SharedPreferences
//     final prefs = await SharedPreferences.getInstance();
//     final baseUrl = 'https://jdapi.youthadda.co/';
//     userImg.value = '$baseUrl${prefs.getString('userImg')}';
//     print('object99:${userImg.value}');
//     await prefs.reload();
//     final userId = prefs.getString('userId') ?? '';
//
//
//     if (userId.isEmpty) {
//       print('❌ User ID not found in SharedPreferences');
//       return;
//     }
//
//     user.value = types.User(id: userId, imageUrl: userImg.value,);
//
//     print('✅ User ID: ${user.value?.id}');
//     print('🖼️ User Image: $userImg');
//
//     final Map<String, dynamic> data = Get.arguments ?? {};
//     print('navigateData: $data');
//     if (data != null) {
//       receiverId = data['receiverId'] ?? '';
//       receiverName.value = data['receiverName'] ?? 'No Name';
//       receiverImage.value = data['userImg'] ?? '';
//       print('✅ Receiver ID: $receiverId');
//       print('✅ Receiver Name: $receiverName');
//       print('✅ Receiver Image: $receiverImage');
//       print('✅ isImageNull: ${receiverImage == null || receiverImage.isEmpty}');
//
//
//     } else {
//       print('❌ No arguments received');
//     }
//
//     connectSocket();
//     fetchChatHistory();
//     isInitialized.value = true;
//   }
//
//   Future<void> fetchChatHistory() async {
//     if (user.value == null || receiverId.isEmpty) return;
//
//     try {
//       final response = await http.get(
//         Uri.parse(
//           'https://jdapi.youthadda.co/chatlist?senderId=${user.value!.id}&receiverId=$receiverId',
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('chatingdata5:${data}');
//         if (data is List) {
//           final List<types.TextMessage> history = [];
//
//           for (var msg in data) {
//             if (msg is Map<String, dynamic>) {
//               int createdAtEpoch;
//               final createdAt = msg['createdAt'];
//               print('rahul:${createdAt}');
//
//               if (createdAt is int) {
//                 createdAtEpoch = createdAt;
//               } else if (createdAt is String) {
//                 createdAtEpoch =
//                     DateTime.tryParse(createdAt)?.millisecondsSinceEpoch ??
//                         DateTime.now().millisecondsSinceEpoch;
//               } else {
//                 createdAtEpoch = DateTime.now().millisecondsSinceEpoch;
//               }
//
//               final senderId = msg['sender']?['_id'] ?? '';
//               history.add(
//                 types.TextMessage(
//                   id: msg['_id'] ?? const Uuid().v4(),
//                   text: msg['message'] ?? '',
//                   author: types.User(id: senderId),
//                   createdAt: createdAtEpoch,
//                 ),
//               );
//             }
//           }
//
//           messages.assignAll(history); // 👈 old to new
//         } else {
//           print("❌ Unexpected response format");
//         }
//       } else {
//         print("❌ Failed to fetch chat: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("⚠️ Error fetching chat: $e");
//     }
//   }
//
//   void connectSocket() {
//     if (user.value == null) return;
//     socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//       'auth': {
//         'user': {'_id': user.value!.id, 'firstName': 'plumber naman'},
//       },
//     });
//
//     socket.connect();
//
//     socket.onConnect((_) {
//       print('✅ Connected to socket');
//     });
//
//     socket.onDisconnect((_) {
//       print('❌ Disconnected from socket');
//     });
//
//     socket.onConnectError((err) {
//       print('🚫 Connect Error: $err');
//     });
//
//     socket.onError((err) {
//       print('🔥 Socket Error: $err');
//     });
//
//     socket.on('message', (data) {
//       print('📩 Received message: $data');
//
//       final msg = types.TextMessage(
//         id: data['_id'] ?? const Uuid().v4(),
//         text: data['message'] ?? '',
//         author: types.User(id: data['senderId']),
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//       );
//
//       messages.insert(0, msg);
//     });
//   }
//
//   final RxString imagePath = ''.obs;
//   void handleSendPressed(types.PartialText message) {
//     if (user.value == null) return;
//     final textMessage = types.TextMessage(
//       author: user.value!,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: message.text,
//     );
//     print('CreatedAt: ${textMessage.createdAt}');
//
//     messages.insert(0, textMessage);
//     messages.refresh();
//
//     final payload = {
//       'senderId': user.value!.id,
//       'receiver': receiverId,
//       'message': message.text,
//       'type': 'text',
//       'createdAt': textMessage.createdAt,
//     };
//
//     print('📤 Sending message: $payload');
//     socket.emit('message', payload);
//   }
//
//   Future<void> handleImagePick() async {
//     final picker = ImagePicker();
//     final result = await picker.pickImage(source: ImageSource.gallery);
//
//     if (result != null) {
//       final file = File(result.path);
//
//       final imageMessage = types.ImageMessage(
//         author: user.value!,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         id: const Uuid().v4(),
//         name: result.name,
//         size: await file.length(),
//         uri: file.path,
//       );
//       print("Image URI: ${imageMessage}");
//       messages.insert(0, imageMessage);
//
//       // Optional: Upload image to server
//     }
//   }
//
//   @override
//   void onClose() {
//     socket.dispose();
//     //  chatScreenController.fetchLastMessages();
//     print("🔌 Socket closed");
//     super.onClose();
//   }
// }
