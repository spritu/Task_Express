import 'dart:convert';
import 'dart:io';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import 'package:worknest/app/modules/provider_ChatScreen/controllers/provider_chat_screen_controller.dart';

class ProviderChatController extends GetxController {
  final RxList<types.Message> messages = <types.Message>[].obs;
  final Rxn<types.User> user = Rxn<types.User>();
  final RxBool isInitialized = false.obs;
  //late types.User user; // Sender (current user)
  late String receiverId;
  RxString userId = ' '.obs;
  RxString userImg = ''.obs;
  RxString receiverName = ''.obs;
  RxString receiverImage = ''.obs;

  // late String receiverName;
  // late String receiverImage;
  late final Map<String, dynamic> _arguments;

  late IO.Socket socket;

  @override
  void onInit() {
    super.onInit();
    initializeChat();

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
    final userId = prefs.getString('userId') ?? '';

    if (userId.isEmpty) {
      print('❌ User ID not found in SharedPreferences');
      return;
    }

    user.value = types.User(id: userId, imageUrl: userImg.value);

    print('✅ User ID: ${user.value?.id}');
    print('🖼️ User Image: $userImg');

    final Map<String, dynamic> data = Get.arguments ?? {};
    print('navigateData: $data');
    if (data != null) {
      receiverId = data['receiverId'] ?? '';
      receiverName.value = data['receiverName'] ?? 'No Name';
      receiverImage.value = data['receiverImage'] ?? '';
      print('✅ Receiver ID: $receiverId');
      print('✅ Receiver Name: $receiverName');
      print('✅ Receiver Image: $receiverImage');
      print('✅ isImageNull: ${receiverImage == null || receiverImage.isEmpty}');
    } else {
      print('❌ No arguments received');
    }

    connectSocket();

    /// 👉 Call after receiverId is set
    await fetchAllMessages();

    fetchChatHistory();
    isInitialized.value = true;
  }

  Future<void> fetchAllMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final reciverID = prefs.getString('userId');
    print("vgvgvgvgvgv:$reciverID");
    if (reciverID!.isEmpty) {
      print('❌ receiverId is empty, aborting fetchAllMessages');
      return;
    }

    var headers = {'Content-Type': 'application/json'};
    print('📨 receiverId all messages: $reciverID');

    var url = Uri.parse('https://jdapi.youthadda.co/viewAll');
    var body = json.encode({"receiver": reciverID});

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('✅ Success viewall : ${response.body}');
      } else {
        print('❌ Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('⚠️ Exception occurred: $e');
    }
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
              final isRead = msg['viewall'] == "true";

              // Just for testing: delete first message
              // if (history.isEmpty && messageId != null) {
              //   await deleteMessage(messageId);
              // }
              history.add(
                types.TextMessage(
                  id: msg['_id'] ?? const Uuid().v4(),
                  text: msg['message'] ?? '',
                  author: types.User(id: senderId),
                  createdAt: createdAtEpoch,
                  metadata: {'isRead': isRead},
                ),
              );
            }
          }

          messages.assignAll(history); // 👈 old to new
          print("messages54544555${messages}");
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

  // delete msg
  Future<void> deleteMessage(String messageId) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/deleteMessage'),
    );

    request.body = json.encode({"messageId": messageId});
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final result = await response.stream.bytesToString();
        print("✅ Message deleted: $result");
      } else {
        print("❌ Failed to delete: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("⚠️ Error deleting message: $e");
    }
  }

  void connectSocket() {
    if (user.value == null) return;
    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {
        'user': {'_id': user.value!.id, 'firstName': 'plumber naman'},
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
      final ProviderChatScreenController providerChatScreenController = Get.put(
        ProviderChatScreenController(),
      );
      print('📩 Received message: $data');
      providerChatScreenController.fetchLastMessages();
      fetchChatHistory();
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

    print('📤 Sending message: $payload');
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
//
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:uuid/uuid.dart';
// import 'package:worknest/app/modules/provider_ChatScreen/controllers/provider_chat_screen_controller.dart';
//
// class ProviderChatController extends GetxController {
//   final RxList<types.Message> messages = <types.Message>[].obs;
//   final Rxn<types.User> user = Rxn<types.User>();
//   final RxBool isInitialized = false.obs;
//   //late types.User user; // Sender (current user)
//   late String receiverId;
//   RxString userId = ' '.obs;
//   RxString userImg = ''.obs;
//   RxString receiverName = ''.obs;
//   RxString receiverImage = ''.obs;
//
//   // late String receiverName;
//   // late String receiverImage;
//   late final Map<String, dynamic> _arguments;
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
//     final userId = prefs.getString('userId3') ?? '';
//
//     if (userId.isEmpty) {
//       print('❌ User ID not found in SharedPreferences');
//       return;
//     }
//
//     user.value = types.User(id: userId, imageUrl: userImg.value);
//
//     print('✅ User ID: ${user.value?.id}');
//     print('🖼️ User Image: $userImg');
//
//     final Map<String, dynamic> data = Get.arguments ?? {};
//     print('navigateData: $data');
//     if (data != null) {
//       receiverId = data['receiverId'] ?? '';
//       receiverName.value = data['receiverName'] ?? 'No Name';
//       receiverImage.value = data['receiverImage'] ?? '';
//       print('✅ Receiver ID: $receiverId');
//       print('✅ Receiver Name: $receiverName');
//       print('✅ Receiver Image: $receiverImage');
//       print('✅ isImageNull: ${receiverImage == null || receiverImage.isEmpty}');
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
//       final ProviderChatScreenController providerChatScreenController = Get.put(
//         ProviderChatScreenController(),
//       );
//       print('📩 Received message: $data');
//       providerChatScreenController.fetchLastMessages();
//       fetchChatHistory();
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
