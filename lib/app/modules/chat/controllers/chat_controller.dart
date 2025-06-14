import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../../chat_screen/controllers/chat_screen_controller.dart';

late ChatScreenController chatScreenController = Get.put(
  ChatScreenController(),
);

class ChatController extends GetxController  with WidgetsBindingObserver{
  final RxMap<String, dynamic> lastCalledUser = <String, dynamic>{}.obs;

  final categories = <Map<String, dynamic>>[].obs; // API se loaded

  var helperName = ''.obs;
  final RxString bookedBy = ''.obs;
  final RxString bookedFor = ''.obs;
  var showRequestPending = false.obs;
  var workers = <Map<String, dynamic>>[].obs;
  var bookingData = {}.obs;


  Map<String, dynamic>? selectedUser;
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
    markAllAsSeen();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      messages.refresh();
    });

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
      final receiverImgPath = data['receiverImage'] ?? '';
      receiverImage.value =
          receiverImgPath.isNotEmpty
              ? '$baseUrl$receiverImgPath'
              : ''; // Avoid setting an invalid image URL
      // print('✅ Receiver ID: $receiverId');
      // print('✅ Receiver Name: $receiverName');
      // print('✅ Receiver Image: $receiverImage');
      // print('✅ isImageNull: ${receiverImage == null || receiverImage.isEmpty}');
    } else {
      print('❌ No arguments received');
    }

    /// 👉 Call after receiverId is set
    await fetchAllMessages();

    connectSocket();
    // connectSocketAllMessage();
    fetchChatHistory();
    isInitialized.value = true;
  }

  // void connectSocketAllMessage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userId = prefs.getString('userId');
  //   String? firstName = prefs.getString('firstName');
  //   String? lastName = prefs.getString('lastName');
  //
  //   if (userId == null) {
  //     print("User ID missing");
  //     return;
  //   }
  //
  //   print('🔌 Connecting socket for userId: $userId');
  //
  //   socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
  //     'transports': ['websocket'],
  //     'autoConnect': false,
  //     'forceNew': true,
  //     'auth': {
  //       'user': {'_id': userId, 'firstName': firstName, 'lastName': lastName},
  //     },
  //   });
  //
  //   socket.connect();
  //
  //   socket.onConnect((_) {
  //     print('✅ Socket connected');
  //   });
  //
  //   socket.onDisconnect((_) {
  //     print('❌ Socket disconnected');
  //   });
  //
  //   socket.onConnectError((err) {
  //     print('⚠️ Connect error: $err');
  //   });
  //
  //   socket.onError((err) {
  //     print('❗ Socket error: $err');
  //   });
  //
  //   /// ✅ Handle "seen" event and update UI
  //   socket.on('allMessagesViewed', (data) {
  //     print('👁️ allMessagesViewed: $data');
  //     // fetchChatHistory();
  //
  //     final seenMessageId = data['messageId'];
  //
  //     for (int i = 0; i < messages.length; i++) {
  //       final msg = messages[i];
  //       if (msg.id == seenMessageId && msg is types.TextMessage) {
  //         // Update metadata
  //         messages[i] = msg.copyWith(metadata: {'viewall': true});
  //         messages.refresh();
  //         print('🔵 Message marked as seen: $seenMessageId');
  //       }
  //     }
  //
  //     messages.refresh(); // Force UI update
  //   });
  // }

  void markAllAsSeen() {
    for (var msg in messages) {
      if (msg is types.TextMessage &&
          msg.author.id != user.value?.id &&
          (msg.metadata == null || msg.metadata?['viewall'] != true)) {
        socket.emit('allMessagesViewed', {
          'messageId': msg.id,
          'userId': user.value?.id,
        });
      }
    }
  }

  // void connectSocketAllMessage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userId = prefs.getString('userId');
  //   String? firstName = prefs.getString('firstName');
  //   String? lastName = prefs.getString('lastName');
  //
  //   print("AllMessage userSaid  :$userId $firstName $lastName");
  //
  //   if (userId == null) {
  //     print(" User ID or BookedFor missing AllMessage");
  //     return;
  //   }
  //
  //   print('🔌 Connecting socket for user AllMessage userSaid: $userId');
  //
  //   socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
  //     'transports': ['websocket'],
  //     'autoConnect': false,
  //     'forceNew': true,
  //     'auth': {
  //       'user': {'_id': userId, 'firstName': firstName, 'lastName': lastName},
  //     },
  //   });
  //
  //   socket.connect();
  //
  //   socket.onConnect((_) {
  //     print(' Connected to socket AllMessage user said ');
  //   });
  //
  //   socket.onDisconnect((_) {
  //     print(' Disconnected from socket AllMessage');
  //   });
  //
  //   socket.onConnectError((err) {
  //     print(' Connect Error: $err');
  //   });
  //
  //   socket.onError((err) {
  //     print(' Socket Error: $err');
  //   });
  //
  //   ///Listen to notifications messages
  //
  //   socket.on('allMessagesViewed', (data) {
  //     print(' Received allMessagesViewed user Said message: $data');
  //     //fetchChatHistory();
  //     final msg = types.TextMessage(
  //       id: data['_id'] ?? const Uuid().v4(),
  //       text: data['message'] ?? '',
  //       author: types.User(id: data['senderId'] ?? 'unknown'),
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //     );
  //
  //     messages.insert(0, msg);
  //   });
  // }

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
              history.add(
                types.TextMessage(
                  id: msg['_id'] ?? const Uuid().v4(),
                  text: msg['message'] ?? '',
                  author: types.User(id: senderId),
                  createdAt: createdAtEpoch,
                  metadata: {'viewall': isRead},
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

  Future<void> deleteMessage(String messageId, String userId) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/deleteMessage'),
    );

    request.body = json.encode({"messageId": messageId, "userId": userId});
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final result = await response.stream.bytesToString();
        print("✅ Message deleted: $result");
      } else {
        print("❌ Failed to delete: ${response.reasonPhrase}");
      }
      print("🔁 Status Code: ${response.statusCode}");
      print("📨 Headers: ${response.headers}");
      print("📦 Body: $response");
    } catch (e) {
      print("⚠️ Error deleting message: $e");
    }
  }
  void makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
    //  shouldShowSheetAfterCall = true;
      await launchUrl(callUri);
    } else {
      Get.snackbar('Error', 'Could not launch phone call');
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
      print('✅ Connected to socket userSaid');
      // final payload = {'receiver': receiverId.trim()};
      //
      // print('Emitting chatScreenActive payload userSaid: $payload');
      // socket.emit('chatScreenActive', payload);
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
        metadata: {
          'viewall': false, // 👈 Add this!
        },
      );

      messages.insert(0, msg);
    });

    // socket.on('allMessagesViewed', (data) {
    //   print('👀 Received allMessagesViewed: $data');
    //   fetchAllMessages();
    //
    //   for (int i = 0; i < messages.length; i++) {
    //     if (messages[i] is types.TextMessage &&
    //         messages[i].author.id == user.value!.id) {
    //       final oldMsg = messages[i] as types.TextMessage;
    //
    //       messages[i] = oldMsg.copyWith(
    //         metadata: {...?oldMsg.metadata, 'viewall': true},
    //       );
    //     }
    //   }
    //
    //   messages.refresh(); // 🔄 Important to rebuild UI
    // });

    // socket.on('chatScreenActive', (data) {
    //   print('📩 Received chatScreenActive message: $data');
    //   // Your method for booking data
    //
    //   final msg = types.TextMessage(
    //     id: data['_id'] ?? const Uuid().v4(),
    //     text: data['message'] ?? '',
    //     author: types.User(id: data['senderId'] ?? 'unknown'),
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //   );
    //
    //   messages.insert(0, msg);
    // });
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
    print("🔌 Socket closed");
    super.onClose();
  }



  Future<void> bookServiceProvider({
    required String bookedFor,
    required List<String> serviceIds,
    required String selectedHelperName,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId2 = prefs.getString('userId'); // ✅ This should not be null

      if (userId2 == null) {
        Get.snackbar("Error", "User ID not found in local storage.");
        return;
      }
      var headers = {'Content-Type': 'application/json'};
      // ✅ Store in RxString
      this.bookedBy.value = userId2;
      this.bookedFor.value = bookedFor;

      var body = json.encode({
        "bookedBy": userId2,
        "bookedFor": bookedFor,
        "bookServices": serviceIds,
      });
      print("Sprint: $bookedFor");
      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/bookserviceprovider'),
      );
      request.body = body;
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print("📦 BookServiceProvider Response: $responseBody");
      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseBody);
        helperName.value = selectedHelperName;
        var acceptStatus = responseData['data']['accept'];
        showRequestPending.value = acceptStatus == null;
        bookingData.value = responseData['data'];
        final BottomController controller = Get.find<BottomController>();
        controller.helperName.value = selectedHelperName;
        controller.showRequestPending.value = acceptStatus == null;
        controller.selectedIndex.value = 1;
        // connectSocket();
        Get.to(() => BottomView());
      } else {
        Get.snackbar('Booking Failed', 'Please try again later.');
      }
    } catch (e) {
      print("❌ Exception in booking: $e");
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  void showAfterCallSheet(
    BuildContext context, {
    required String name,
    required String imageUrl,
    required String experience,
    required String phone,
    required String userId,
    required List<Map<String, dynamic>> skills,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: const Icon(Icons.close),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            imageUrl.isNotEmpty
                                ? NetworkImage(
                                  'https://jdapi.youthadda.co/$imageUrl',
                                )
                                : const AssetImage('assets/images/account.png')
                                    as ImageProvider,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF114BCA),
                            fontFamily: "poppins",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "If this conversation with $name meets your expectations, book now:",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: "poppins",
                      color: Color(0xFF4F4F4F),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...skills.map((skill) {
                    String title = '';
                    if (skill['subcategoryName'] != null &&
                        skill['subcategoryName'].toString().isNotEmpty) {
                      title = skill['subcategoryName'];
                    } else if (skill['categoryName'] != null &&
                        skill['categoryName'].toString().isNotEmpty) {
                      title = skill['categoryName'];
                    } else {
                      title = 'Service';
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: professionRow(
                        title: title,
                        price: "₹ ${skill['charge'] ?? '0'}",
                        onBookNow: () {
                          showAreYouSureSheet(
                            context,
                            name: name,
                            imageUrl: imageUrl,
                            skill: skill,
                            userId: userId,
                            onConfirm: (serviceIds) async {
                              await bookServiceProvider(
                                bookedFor: userId,
                                serviceIds: serviceIds,
                                selectedHelperName: name,
                              );
                            },
                          );
                        },
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  const Text(
                    "Not Satisfied? Let’s help you find someone else",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: "poppins",
                      color: Color(0xFF4F4F4F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 34,
                    width: 119,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close, color: Color(0xFF114BCA)),
                      label: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(0xFF114BCA),
                          fontFamily: "poppins",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF114BCA)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget professionRow({
    required String title,
    required String price,
    required VoidCallback onBookNow,
  }) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF6F6F6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: "poppins",
            ),
          ),
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF114BCA),
                  fontFamily: "poppins",
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 25,
                width: 79,
                child: ElevatedButton(
                  onPressed: onBookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF114BCA),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Book Now",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontFamily: "poppins",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showAreYouSureSheet(
    BuildContext context, {
    required String name,
    required String imageUrl,
    required Map<String, dynamic> skill,
    required String userId,
    required Future<void> Function(List<String>) onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffD9E4FC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        imageUrl.isNotEmpty
                            ? NetworkImage(
                              'https://jdapi.youthadda.co/$imageUrl',
                            )
                            : const AssetImage('assets/images/account.png')
                                as ImageProvider,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: "poppins",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Are you sure you want to continue with this booking?",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: "poppins",
                            color: Color(0xFF4F4F4F),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 42,
                          width: 176,
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              String id =
                                  skill['subcategoryId']?.toString() ??
                                  skill['categoryId'].toString();
                              await onConfirm([id]);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF114BCA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "poppins",
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 42,
                          width: 176,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.close,
                                  color: Color(0xFF114BCA),
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "No",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "poppins",
                                    color: Color(0xFF114BCA),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
