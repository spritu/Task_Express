import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../CancelBooking/views/cancel_booking_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../../home/controllers/home_controller.dart';

class ProfessionalPlumberController extends GetxController with WidgetsBindingObserver {
  final HomeController userController = Get.put(HomeController());
  int? selectedIndexAfterCall;
  List<dynamic>? selectedUsers;
  String? selectedTitle;

  void setCallContext({required int index, required List users, required String title}) {
    selectedIndexAfterCall = index;
    selectedUsers = users;
    selectedTitle = title;
    shouldShowSheetAfterCall = true;
  }
  // To show bottom sheet after phone call ends
  bool shouldShowSheetAfterCall = false;

  RxBool isDataReady = false.obs;

  // Data for bottom sheet
  RxnString name = RxnString();
  RxnString imageUrl = RxnString();
  RxnString experience = RxnString();
  RxnString phone = RxnString();
  RxnString userId = RxnString();
  RxnString title = RxnString();
  RxList<Map<String, dynamic>> skills = <Map<String, dynamic>>[].obs;

  var showRequestPending = false.obs;
  var helperName = ''.obs;
  var bookingData = {}.obs;
  var selectedIndex = 0.obs;
  final selectedUser = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // Listen for app lifecycle changes, mainly to detect when phone call ends
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && shouldShowSheetAfterCall) {
      shouldShowSheetAfterCall = false;

      Future.delayed(const Duration(seconds: 2), () {
        final context = Get.context;
        if (context != null &&
            selectedUsers != null &&
            selectedIndexAfterCall != null &&
            selectedIndexAfterCall! < selectedUsers!.length) {
          final user = selectedUsers![selectedIndexAfterCall!];
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) {
              return showAfterCallSheet(
                context,
                name: user['firstName']?.toString() ?? 'No Name',
                imageUrl: user['userImg']?.toString() ?? '',
                experience: user['experience']?.toString() ?? '',
                phone: user['phone']?.toString() ?? '',
                userId: user['_id'],
                title: selectedTitle ?? '',
                skills: List<Map<String, dynamic>>.from(user['skills'] ?? []),
              );
            },
          );
        }
      });
    }
  }




  // Make phone call and mark to show sheet after call ends
  void makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      shouldShowSheetAfterCall = true;
      await launchUrl(callUri);
    } else {
      Get.snackbar('Error', 'Could not launch phone call');
    }
  }

  // Booking API call
  Future<void> bookServiceProvider({
    required String bookedBy,
    required String bookedFor,
    required List<String> serviceIds,
    required String selectedHelperName,
  }) async {
    try {
      var headers = {'Content-Type': 'application/json'};

      var body = json.encode({
        "bookedBy": bookedBy,
        "bookedFor": bookedFor,
        "bookServices": serviceIds,
      });

      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/bookserviceprovider'),
      );

      request.body = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        final responseData = jsonDecode(responseBody);

        helperName.value = selectedHelperName;

        var acceptStatus = responseData['data']['accept'];
        showRequestPending.value = acceptStatus == null;

        bookingData.value = responseData['data'];
        selectedIndex.value = 0;

        final BottomController controller = Get.find<BottomController>();
        controller.helperName.value = selectedHelperName;
        controller.showRequestPending.value = (acceptStatus == null);
        controller.selectedIndex.value = 1; // Navigate to Booking tab

        Get.to(() => BottomView());
      } else {
        Get.snackbar('Booking Failed', 'Please try again later.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  // Reject booking API call
  Future<void> rejectBooking(String bookingId) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/acceptreject'),
      );

      request.body = json.encode({
        "bookingId": bookingId,
        "accept": "no",
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String result = await response.stream.bytesToString();
        print(result);
        Get.to(() => CancelBookingView());
        Get.snackbar("Success", "Booking rejected");
      } else {
        Get.snackbar("Error", "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  // Widget to show bottom sheet after call ends
  Widget showAfterCallSheet(
      BuildContext context, {
        required String name,
        required String imageUrl,
        required String experience,
        required String phone,
        required String userId,
        required String title,
        required List<Map<String, dynamic>> skills, // Pass dynamic skills
      }) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 24),
                ),
              ],
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage('https://jdapi.youthadda.co/$imageUrl')
                      : const AssetImage('assets/images/account.png') as ImageProvider,
                ),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "poppins",
                    color: Color(0xFF114BCA),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "If this conversation with $name meets your expectations, book now:",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4F4F4F),
                fontFamily: "poppins",
              ),
            ),
            const SizedBox(height: 20),

            /// 🔁 Generate dynamic profession rows from skills
            for (var skill in skills)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: professionRow(
                  title: (skill['subcategoryName'] != null && skill['subcategoryName'].toString().isNotEmpty)
                      ? skill['subcategoryName']
                      : (skill['categoryName'] != null && skill['categoryName'].toString().isNotEmpty)
                      ? skill['categoryName']
                      : 'Service',



                  price: "₹ ${skill['charge'].toString()}",
                  onBookNow: () {
                    print("📌 Book Now tapped for: ${skill['categoryName']}");
                    showAreUSureSheet(
                      context,
                      name: name,
                      imageUrl: imageUrl,
                      experience: experience,
                      phone: phone,
                      userId: userId,
                      title: skill['categoryId'].toString(),
                      skill: skill,
                      bookServiceProvider: (serviceIds) async {
                        await bookServiceProvider(
                          bookedBy: userId, // <-- Ensure this is defined
                          bookedFor: userId,
                          serviceIds: serviceIds, selectedHelperName: '',
                        );
                      },
                    );
                  },

                ),
              ),


            const SizedBox(height: 20),
            const Text(
              "Not Satisfied? Let’s help you find someone else",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4F4F4F),
                fontFamily: "poppins",
              ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 34,
              width: 119,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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




  void showAreUSureSheet(
      BuildContext context, {
        required String name,
        required String imageUrl,
        required String experience,
        required String phone,
        required String userId,
        required String title,
        required Map<String, dynamic> skill,
        required Future<void> Function(List<String> serviceIds) bookServiceProvider,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffD9E4FC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.black),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage('https://jdapi.youthadda.co/$imageUrl')
                        : const AssetImage('assets/images/account.png') as ImageProvider,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 42,
                          width: 176,
                          child: ElevatedButton(
                            onPressed: () async {
                              String serviceId = skill['subcategoryId']?.toString() ??
                                  skill['categoryId'].toString();
                              Navigator.pop(context);
                              await bookServiceProvider([serviceId]);
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
                                Icon(Icons.close, color: Color(0xFF114BCA), size: 18),
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
