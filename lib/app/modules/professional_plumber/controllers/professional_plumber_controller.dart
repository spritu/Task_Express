import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../CancelBooking/views/cancel_booking_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../../home/controllers/home_controller.dart';

class ProfessionalPlumberController extends GetxController with WidgetsBindingObserver {
  final HomeController userController = Get.put(HomeController());
  var distances = <int, String>{}.obs;
  Position? currentPosition;

  Future<void> saveCurrentLocationToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (currentPosition != null) {
      await prefs.setDouble('lat1', currentPosition!.latitude);
      await prefs.setDouble('lng1', currentPosition!.longitude);
      print("✅ Saved location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
    } else {
      print("⚠️ currentPosition is null. Location not saved.");
    }
  }

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
  var distance = ''.obs;
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
  //Position? currentPosition;

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000; // in kilometers
  }
  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void onInit() {
    super.onInit();
  //  getDistanceFromApi( lat2,  lng2)
 //   getDistanceFromSharedPrefs(lat2,);
    WidgetsBinding.instance.addObserver(this);
  }
  Future<void> fetchDistanceForUser(int index, double lat2, double lng2) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? lat1 = prefs.getDouble('lat1');
    double? lng1 = prefs.getDouble('lng1');

    if (lat1 != null && lng1 != null) {
      final url = Uri.parse(
          'https://jdapi.youthadda.co/getdistance?lat1=$lat1&lon1=$lng1&lat2=$lat2&lon2=$lng2');

      try {
        var request = http.MultipartRequest('GET', url);
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          String result = await response.stream.bytesToString();
          var data = json.decode(result);
          print("✅ API response: $data");

          // ✅ Extract from `data['data']['distance']`
          if (data['data'] != null && data['data']['distance'] != null) {
            double rawDistance = data['data']['distance'];
            String formattedDistance = (rawDistance / 1000).toStringAsFixed(2); // convert to KM
            distances[index] = '$formattedDistance KM';
            print("📏 Distance for user[$index]: ${distances[index]}");
          } else {
            distances[index] = 'N/A';
          }
        } else {
          distances[index] = 'Error';
          print("❌ Failed with status: ${response.statusCode}");
        }
      } catch (e) {
        distances[index] = 'Error';
        print("❌ Exception: $e");
      }
    } else {
      distances[index] = 'No Location';
    }

    update(); // update UI in GetX
  }




  void updateUserDistances(List<dynamic> users) {
    for (int i = 0; i < users.length; i++) {
      final lat = double.tryParse(users[i]['lat'] ?? '0') ?? 0.0;
      final lng = double.tryParse(users[i]['lng'] ?? '0') ?? 0.0;

      if (lat != 0.0 && lng != 0.0) {
        fetchDistanceForUser(i, lat, lng);
      } else {
        distances[i] = 'Invalid';
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }
  Future<String> getDistanceFromApi(double lat2, double lng2) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? lat1 = prefs.getDouble('lat1');
    double? lng1 = prefs.getDouble('lng1');

    if (lat1 != null && lng1 != null) {
      final url = Uri.parse(
        'https://jdapi.youthadda.co/getdistance?lat1=$lat1&lon1=$lng1&lat2=$lat2&lon2=$lng2',
      );

      var request = http.MultipartRequest('GET', url);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String result = await response.stream.bytesToString();
        var data = json.decode(result);
        return data['distance']?.toString() ?? 'N/A';
      } else {
        print("❌ Error: ${response.statusCode} - ${response.reasonPhrase}");
        return 'Error';
      }
    } else {
      return 'Coordinates missing';
    }
  }

  // Future<void> getDistanceFromSharedPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   double? lat1 = prefs.getDouble('lat1');
  //   double? lng1 = prefs.getDouble('lng1');
  //   double? lat2 = prefs.getDouble('lat2');
  //   double? lng2 = prefs.getDouble('lng2');
  //
  //   if (lat1 != null && lng1 != null && lat2 != null && lng2 != null) {
  //     print("📍 User1: ($lat1, $lng1)");
  //     print("📍 User2: ($lat2, $lng2)");
  //
  //     final url = Uri.parse(
  //       'https://jdapi.youthadda.co/getdistance?lat1=$lat1&lon1=$lng1&lat2=$lat2&lon2=$lng2',
  //     );
  //
  //     var request = http.MultipartRequest('GET', url);
  //     http.StreamedResponse response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       String result = await response.stream.bytesToString();
  //       print("✅ Distance API Response: $result");
  //
  //       // Parse JSON response
  //       var data = json.decode(result);
  //       if (data['distance'] != null) {
  //         distance.value = data['distance'].toString(); // Update Rx value
  //       } else {
  //         distance.value = 'null';
  //       }
  //     } else {
  //       print("❌ Failed to fetch distance: ${response.statusCode} - ${response.reasonPhrase}");
  //       distance.value = 'Error';
  //     }
  //   } else {
  //     print("⚠️ One or more coordinates are missing in SharedPreferences.");
  //     distance.value = 'Coordinates missing';
  //   }
  // }

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
   //   Get.snackbar('Error', 'Could not launch phone call');
    }
  }

  // Booking API call
  Future<void> bookServiceProvider({
    required String bookedFor,
    required List<String> serviceIds,
    required String selectedHelperName,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId2 = prefs.getString('userId'); // ✅ This should not be null

      if (userId2 == null) {
      //  Get.snackbar("Error", "User ID not found in local storage.");
        return;
      }

      var headers = {'Content-Type': 'application/json'};

      var body = json.encode({
        "bookedBy": userId2,
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

        Get.to(() => BottomView());
      } else {
   //     Get.snackbar('Booking Failed', 'Please try again later.');
      }
    } catch (e) {
      print("❌ Exception in booking: $e");
  //    Get.snackbar('Error', 'Something went wrong: $e');
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
                         // <-- Ensure this is defined
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
