import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import 'package:worknest/app/modules/recomplete_job_pay/controllers/recomplete_job_pay_controller.dart';
import '../../../../auth_controller.dart';
import '../../login/views/login_view.dart'; // Ensure this path is correct

class BottomController extends GetxController {
  final count = 0.obs;
  var selectedIndex = 0.obs;
  var bookingData = {}.obs;
  var showRequestPending = false.obs;
  var helperName = ''.obs;
  var selected = 0.obs;
  late IO.Socket socket;
  final RxList<types.Message> messages = <types.Message>[].obs;
  final Rxn<types.User> user = Rxn<types.User>();

  // Inside your BottomController or NotificationController
  final RxList<dynamic> notifications = <dynamic>[].obs;
  // or if it's a map structure:
  final AuthController authController = Get.find<AuthController>();

  var hasUnreadNotifications = false.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    connectSocketCancel();
    connectSocketnotifications();

    // Get.put(RecompleteJobPayController().fetchPendingPaymentsUser());
  }

  /// fetchNotifications Api

  Future<void> fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final userId2 = prefs.getString('userId');

    if (userId2 == null) {
      print("❌ User ID not found in SharedPreferences.");
      return;
    }

    print("📥 Using userId fetchNotifications: $userId2");

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/getnotifications'),
    );

    request.body = json.encode({"userId": userId2});
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print("✅ Status Code: ${response.statusCode}");
      print("📦 Response Body: $responseBody");

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody);
        notifications.assignAll(responseData['notifications'] ?? '');

        bool unreadFound = notifications.any(
          (notif) => notif['isRead'] == false,
        );
        hasUnreadNotifications.value = unreadFound;
        print("🔔 Notifications fetched: ${notifications.length}");

        // notifications.value = responseData['notifications'] ?? [];
        // for (var notif in notifications) {
        //   print("🔔 Notification: $notif");
        // }
      } else {
        print("❌ Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("⚠️ Exception occurred: $e");
    }
  }

  Future<void> markChatNotificationAsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? senderId = prefs.getString('userId');
    print("123456789:$senderId");

    if (senderId == null) {
      print("⚠️ senderId not found in SharedPreferences");
      return;
    }

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/seenchatnotification'),
    );

    request.body = json.encode({"senderId": senderId});

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final result = await response.stream.bytesToString();
        print("✅ Notification marked as seen user2222: $result");
      } else {
        print("❌ Failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("⚠️ Error sending seen notification: $e");
    }
  }

  void connectSocketnotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId2 = prefs.getString('userId');
    String? firstName = prefs.getString('firstName');
    String? lastName = prefs.getString('lastName');

    print("notifications user :$userId2");

    if (userId2 == null) {
      print(" User ID or BookedFor missing notifications user");
      return;
    }

    print('🔌 Connecting socket for user notifications user: $userId2');

    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'auth': {
        'user': {'_id': userId2, 'firstName': firstName, 'lastName': lastName},
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print(' Connected to socket notifications user');
    });

    socket.onDisconnect((_) {
      print(' Disconnected from socket notifications user');
    });

    socket.onConnectError((err) {
      print(' Connect Error user: $err');
    });

    socket.onError((err) {
      print(' Socket Error user: $err');
    });

    ///Listen to notifications messages

    socket.on('notifications', (data) {
      print(' Received notifications message user: $data');
      fetchNotifications();
      final msg = types.TextMessage(
        id: data['_id'] ?? const Uuid().v4(),
        text: data['message'] ?? '',
        author: types.User(id: data['senderId'] ?? 'unknown'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      messages.insert(0, msg);
    });
  }

  void connectSocketCancel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId2 = prefs.getString('userId');
    String? firstName = prefs.getString('firstName');
    String? lastName = prefs.getString('lastName');
    print(' cancelsocketuser : $userId2 $firstName $lastName');

    print(" listenCancel :$userId2");

    if (userId2 == null) {
      print(" User ID or BookedFor missing");
      return;
    }

    print('🔌 Connecting socket for user: $userId2');

    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'auth': {
        'user': {'_id': userId2, 'firstName': firstName, 'lastName': lastName},
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected listen Cancel');
    });

    print('socket99:$socket');

    socket.on('paybyuserconfirm', (data) {
      print('📩 Received paybyuserconfirm message136: $data');
      final RecompleteJobPayController recompleteJobPayController = Get.put(
        RecompleteJobPayController(),
      );
      recompleteJobPayController.fetchPendingPaymentsUser();

      final msg = types.TextMessage(
        id: data['_id'] ?? const Uuid().v4(),
        text: data['message'] ?? '',
        author: types.User(id: data['senderId'] ?? 'unknown'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      messages.insert(0, msg);
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
  }

  void cancelRequest() {
    showRequestPending.value = false;
    helperName.value = '';
  }

  void checkAndShowSignupSheet(BuildContext context) {
    if (!authController.isLoggedIn.value) {
      showSignupSheet(context);
    }
  }

  void showSignupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffD9E4FC),
              boxShadow: [BoxShadow(blurRadius: 4, color: Color(0xFFD9E4FC))],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 30),
                        Row(
                          children: const [
                            Text(
                              "Sign Up Required ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Icon(Icons.arrow_downward),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Image
                    Image.asset(
                      "assets/images/Signupbro.png",
                      height: 293,
                      width: 393,
                    ),
                    const SizedBox(height: 20),

                    /// Info Text
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Please verify your mobile number to continue \nusing TaskExpress.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Continue Button
                    SizedBox(
                      height: 36.93,
                      width: 170,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF114BCA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Get.back(); // Close bottom sheet
                          Get.to(() => LoginView()); // Go to login
                        },
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: "poppins",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Note Text
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'This helps us personalize your experience and keep your data secure.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
