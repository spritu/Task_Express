import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import 'package:http/http.dart' as http;
class PlasteringHelperController extends GetxController   with WidgetsBindingObserver {
  //TODO: Implement PlasteringHelperController\\
// ✅ Put at the top inside your controller class:
  final RxMap<String, dynamic> lastCalledUser = <String, dynamic>{}.obs;

  final categories = <Map<String, dynamic>>[].obs; // API se loaded


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {

  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  var helperName = ''.obs;
  final RxString bookedBy = ''.obs;
  final RxString bookedFor = ''.obs;
  var showRequestPending = false.obs;
  var workers = <Map<String, dynamic>>[].obs;
  var bookingData = {}.obs;
  late IO.Socket socket;
  final RxList<types.Message> messages = <types.Message>[].obs;
  Map<String, dynamic>? selectedUser;

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
        connectSocket();
        Get.to(() => BottomView());
      } else {
        Get.snackbar('Booking Failed', 'Please try again later.');
      }
    } catch (e) {
      print("❌ Exception in booking: $e");
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  void connectSocket() {
    if (bookedBy.value == null || bookedFor.value.isEmpty) {
      print(" User ID or BookedFor missing New booking");
      return;
    }
    print(
      '🔌 Connecting socket for user New booking: ${bookedBy
          .value}, bookedFor: ${bookedFor.value}',);
    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'auth': {
        'user': {
          '_id': bookedBy.value,
          'firstName': 'plumber naman',
          // Optional, can be dynamic
        },},});

    socket.connect();
    socket.onConnect((_) {
      /// Emit userId and bookedFor after socket is connected
      final payload = {'receiver': bookedFor.value};
      socket.emit('newBooking', payload);
    });
    socket.onDisconnect((_) {});
    socket.onConnectError((err) {
      print('New booking Connect Error: $err');
    });
    socket.onError((err) {
      print('New booking Socket Error: $err');
    });

    /// Listen to newBooking messages
    socket.on('newBooking', (data) {
      final msg = types.TextMessage(
        id: data['_id'] ?? const Uuid().v4(),
        text: data['message'] ?? '',
        author: types.User(id: data['senderId'] ?? 'unknown'),
        createdAt: DateTime
            .now()
            .millisecondsSinceEpoch,
      );

      messages.insert(0, msg);
    });
  }

  int? selectedIndexAfterCall;
  List<dynamic>? selectedUsers;
  String? selectedTitle;
  bool shouldShowSheetAfterCall = false;

  // makePhoneCall mein:
  Future<void> makePhoneCall(String phoneNumber, Map<String, dynamic> user) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
      lastCalledUser.value = user; // ✅ store full user map
    } else {
      Get.snackbar(
        'Error',
        'Could not launch dialer',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && lastCalledUser.value.isNotEmpty) {
      final user = lastCalledUser.value;
      final name = "${user['firstName'] ?? ''} ${user['lastName'] ?? ''}".trim();
      final imageUrl = user['userImg'] ?? '';
      final experience = "${user['expiresAt'] ?? '0'} year Experience";
      final phone = user['phone'] ?? '';
      final userId = user['_id']?.toString() ?? '';

      final List<Map<String, dynamic>> skills =
          (user['skills'] as List?)?.cast<Map<String, dynamic>>() ?? [];

      showAfterCallSheet(
        Get.context!,
        name: name,
        imageUrl: imageUrl,
        experience: experience,
        phone: phone,
        userId: userId,
        skills: List<Map<String, dynamic>>.from(user['skills'] ?? []),
      );

      lastCalledUser.value = {}; // ✅ Clear
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
                        backgroundImage: imageUrl.isNotEmpty
                            ? NetworkImage('https://jdapi.youthadda.co/$imageUrl')
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
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage('https://jdapi.youthadda.co/$imageUrl')
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
                    padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                              String id = skill['subcategoryId']?.toString() ??
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
                                Icon(Icons.check, color: Colors.white, size: 18),
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
                                Icon(Icons.close,
                                    color: Color(0xFF114BCA), size: 18),
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


  final count = 0.obs;


  void increment() => count.value++;
}

extension on PlasteringHelperController {
  set context(BuildContext context) {}
}
