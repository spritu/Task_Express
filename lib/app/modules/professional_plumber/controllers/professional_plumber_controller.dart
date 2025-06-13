// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:geocoding/geocoding.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:uuid/uuid.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import '../../CancelBooking/views/cancel_booking_view.dart';
// import '../../bottom/controllers/bottom_controller.dart';
// import '../../bottom/views/bottom_view.dart';
// import '../../home/controllers/home_controller.dart';
//
// class ProfessionalPlumberController extends GetxController with WidgetsBindingObserver {
//
//   final RxList<types.Message> messages = <types.Message>[].obs;
//   final Rxn<types.User> user = Rxn<types.User>();
//   late IO.Socket socket;
//   final HomeController userController = Get.put(HomeController());
//   int? selectedIndexAfterCall;
//   List<dynamic>? selectedUsers;
//   String? selectedTitle;
//
//   void setCallContext({required int index, required List users, required String title}) {
//     selectedIndexAfterCall = index;
//     selectedUsers = users;
//     selectedTitle = title;
//     shouldShowSheetAfterCall = true;
//   }
//   // To show bottom sheet after phone call ends
//   bool shouldShowSheetAfterCall = false;
//
//   RxBool isDataReady = false.obs;
//
//   // Data for bottom sheet
//   RxnString name = RxnString();
//   RxnString imageUrl = RxnString();
//   RxnString experience = RxnString();
//   RxnString phone = RxnString();
//   RxnString userId = RxnString();
//   RxnString title = RxnString();
//   RxList<Map<String, dynamic>> skills = <Map<String, dynamic>>[].obs;
//
//   var showRequestPending = false.obs;
//   var helperName = ''.obs;
//   var bookingData = {}.obs;
//   var selectedIndex = 0.obs;
//   final selectedUser = Rxn<Map<String, dynamic>>();
//
//   var userAddresses = <String, String>{}.obs;
//
//   Future<void> fetchAddress(String userId, double lat, double lng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;
//         final address = "${place.name}, ${place.locality}, ${place.administrativeArea}";
//         userAddresses[userId] = address;
//       } else {
//         userAddresses[userId] = "Address not found";
//       }
//     } catch (e) {
//       userAddresses[userId] = "Error fetching address";
//     }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addObserver(this);
//
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//     socket.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//   }
//
//   // Listen for app lifecycle changes, mainly to detect when phone call ends
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && shouldShowSheetAfterCall) {
//       shouldShowSheetAfterCall = false;
//
//       Future.delayed(const Duration(seconds: 2), () {
//         final context = Get.context;
//         if (context != null &&
//             selectedUsers != null &&
//             selectedIndexAfterCall != null &&
//             selectedIndexAfterCall! < selectedUsers!.length) {
//           final user = selectedUsers![selectedIndexAfterCall!];
//           showModalBottomSheet(
//             context: context,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             builder: (_) {
//               return showAfterCallSheet(
//                 context,
//                 name: user['firstName']?.toString() ?? 'No Name',
//                 imageUrl: user['userImg']?.toString() ?? '',
//                 experience: user['experience']?.toString() ?? '',
//                 phone: user['phone']?.toString() ?? '',
//                 userId: user['_id'],
//                 title: selectedTitle ?? '',
//                 skills: List<Map<String, dynamic>>.from(user['skills'] ?? []),
//               );
//             },
//           );
//         }
//       });
//     }
//   }
//
//
//
//
//   // Make phone call and mark to show sheet after call ends
//   void makePhoneCall(String phoneNumber) async {
//     final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(callUri)) {
//       shouldShowSheetAfterCall = true;
//       await launchUrl(callUri);
//     } else {
//       Get.snackbar('Error', 'Could not launch phone call');
//     }
//   }
//   RxString bookedFor = ''.obs;
//
//   // Booking API call
//   Future<void> bookServiceProvider({
//     required String bookedFor,
//     required List<String> serviceIds,
//     required String selectedHelperName,
//   }) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? userId2 = prefs.getString('userId'); // ✅ This should not be null
//
//       if (userId2 == null) {
//         Get.snackbar("Error", "User ID not found in local storage.");
//         return;
//       }
//
//       var headers = {'Content-Type': 'application/json'};
//
//       var body = json.encode({
//         "bookedBy": userId2,
//         "bookedFor": bookedFor,
//         "bookServices": serviceIds,
//       });
//
//       var request = http.Request(
//         'POST',
//         Uri.parse('https://jdapi.youthadda.co/bookserviceprovider'),
//       );
//       request.body = body;
//       request.headers.addAll(headers);
//
//       http.StreamedResponse response = await request.send();
//       String responseBody = await response.stream.bytesToString();
//
//       print("📦 BookServiceProvider Response: $responseBody");
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(responseBody);
//
//         helperName.value = selectedHelperName;
//
//         var acceptStatus = responseData['data']['accept'];
//         showRequestPending.value = acceptStatus == null;
//         bookingData.value = responseData['data'];
//
//         final BottomController controller = Get.find<BottomController>();
//         controller.helperName.value = selectedHelperName;
//         controller.showRequestPending.value = acceptStatus == null;
//         controller.selectedIndex.value = 1;
//
//         user.value = types.User(id: userId2);
//         this.bookedFor.value = bookedFor;
//
//         connectSocket();
//
//         Get.to(() => BottomView());
//       } else {
//         Get.snackbar('Booking Failed', 'Please try again later.');
//       }
//     } catch (e) {
//       print("❌ Exception in booking: $e");
//       Get.snackbar('Error', 'Something went wrong: $e');
//     }
//   }
//   String address = "Loading...";
//
//   void connectSocket() {
//     print("❌ wdwcdtf");
//
//     if (user.value == null || bookedFor.value.isEmpty) {
//       print("❌ User ID or BookedFor missing");
//       return;
//     }
//
//     print('🔌 Connecting socket for user: ${user.value!.id}, bookedFor: ${bookedFor.value}');
//
//     socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//       'forceNew': true,
//       'auth': {
//         'user': {
//           '_id': user.value!.id,
//           'firstName': 'plumber naman', // Optional, can be dynamic
//         },
//       },
//     });
//
//     socket.connect();
//
//     // socket.onConnect((_) {
//     //   print('✅ Connected to socket12121212');
//     // });
//
//     socket.onConnect((_) {
//       print('✅ Connected to socket');
//
//       /// ✅ Emit userId and bookedFor after socket is connected
//       final payload = {
//         'receiver': bookedFor.value,
//       };
//
//       print('📤 Emitting newBooking payload: $payload');
//       socket.emit('newBooking', payload);
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
//     /// ✅ Listen to newBooking messages
//     socket.on('newBooking', (data) {
//       print('📩 Received newBooking message: $data');
//
//       final msg = types.TextMessage(
//         id: data['_id'] ?? const Uuid().v4(),
//         text: data['message'] ?? '',
//         author: types.User(id: data['senderId'] ?? 'unknown'),
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//       );
//
//       messages.insert(0, msg);
//     });
//   }
//
//   Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
//
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         return "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
//       } else {
//         return "Address not found";
//       }
//     } catch (e) {
//       print("❗ Error in reverse geocoding: $e");
//       return "Address not available";
//     }
//   }
//
//
//   // Widget to show bottom sheet after call ends
//   Widget showAfterCallSheet(
//       BuildContext context, {
//         required String name,
//         required String imageUrl,
//         required String experience,
//         required String phone,
//         required String userId,
//         required String title,
//         required List<Map<String, dynamic>> skills, // Pass dynamic skills
//       }) {
//     return SingleChildScrollView(
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const Icon(Icons.close, size: 24),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 40,
//                   backgroundImage: imageUrl.isNotEmpty
//                       ? NetworkImage('https://jdapi.youthadda.co/$imageUrl')
//                       : const AssetImage('assets/images/account.png') as ImageProvider,
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: "poppins",
//                     color: Color(0xFF114BCA),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "If this conversation with $name meets your expectations, book now:",
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF4F4F4F),
//                 fontFamily: "poppins",
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             /// 🔁 Generate dynamic profession rows from skills
//             for (var skill in skills)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: professionRow(
//                   title: (skill['subcategoryName'] != null && skill['subcategoryName'].toString().isNotEmpty)
//                       ? skill['subcategoryName']
//                       : (skill['categoryName'] != null && skill['categoryName'].toString().isNotEmpty)
//                       ? skill['categoryName']
//                       : 'Service',
//
//
//
//                   price: "₹ ${skill['charge'].toString()}",
//                   onBookNow: () {
//                     print("📌 Book Now tapped for: ${skill['categoryName']}");
//                     showAreUSureSheet(
//                       context,
//                       name: name,
//                       imageUrl: imageUrl,
//                       experience: experience,
//                       phone: phone,
//                       userId: userId,
//                       title: skill['categoryId'].toString(),
//                       skill: skill,
//                       bookServiceProvider: (serviceIds) async {
//                         await bookServiceProvider(
//                           // <-- Ensure this is defined
//                           bookedFor: userId,
//                           serviceIds: serviceIds, selectedHelperName: '',
//                         );
//                       },
//                     );
//                   },
//
//                 ),
//               ),
//
//
//             const SizedBox(height: 20),
//             const Text(
//               "Not Satisfied? Let’s help you find someone else",
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF4F4F4F),
//                 fontFamily: "poppins",
//               ),
//             ),
//             const SizedBox(height: 14),
//
//             SizedBox(
//               height: 34,
//               width: 119,
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(Icons.close, color: Color(0xFF114BCA)),
//                 label: const Text(
//                   "Cancel",
//                   style: TextStyle(
//                     color: Color(0xFF114BCA),
//                     fontFamily: "poppins",
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   side: const BorderSide(color: Color(0xFF114BCA)),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget professionRow({
//     required String title,
//     required String price,
//     required VoidCallback onBookNow,
//   }) {
//     return Container(
//       height: 45,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: const Color(0xFFF6F6F6),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//               fontFamily: "poppins",
//             ),
//           ),
//           Row(
//             children: [
//               Text(
//                 price,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Color(0xFF114BCA),
//                   fontFamily: "poppins",
//                 ),
//               ),
//               const SizedBox(width: 12),
//               SizedBox(
//                 height: 25,
//                 width: 79,
//                 child: ElevatedButton(
//                   onPressed: onBookNow,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF114BCA),
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       "Book Now",
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: "poppins",
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//
//   void showAreUSureSheet(
//       BuildContext context, {
//         required String name,
//         required String imageUrl,
//         required String experience,
//         required String phone,
//         required String userId,
//         required String title,
//         required Map<String, dynamic> skill,
//         required Future<void> Function(List<String> serviceIds) bookServiceProvider,
//       }) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 12, right: 12),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xffD9E4FC),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: const Icon(Icons.close, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundImage: imageUrl.isNotEmpty
//                         ? NetworkImage('https://jdapi.youthadda.co/$imageUrl')
//                         : const AssetImage('assets/images/account.png') as ImageProvider,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     name,
//                     style: const TextStyle(
//                       fontFamily: "poppins",
//                       fontWeight: FontWeight.w500,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       children: [
//                         const Text(
//                           "Are you sure you want to continue with this booking?",
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: "poppins",
//                             color: Color(0xFF4F4F4F),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         SizedBox(
//                           height: 42,
//                           width: 176,
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               String serviceId = skill['subcategoryId']?.toString() ??
//                                   skill['categoryId'].toString();
//                               Navigator.pop(context);
//                               await bookServiceProvider([serviceId]);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF114BCA),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.check, color: Colors.white, size: 18),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   "Yes",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                     fontFamily: "poppins",
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         SizedBox(
//                           height: 42,
//                           width: 176,
//                           child: ElevatedButton(
//                             onPressed: () => Navigator.pop(context),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.close, color: Color(0xFF114BCA), size: 18),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   "No",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                     fontFamily: "poppins",
//                                     color: Color(0xFF114BCA),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../CancelBooking/views/cancel_booking_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../../home/controllers/home_controller.dart';

class ProfessionalPlumberController extends GetxController
    with WidgetsBindingObserver {

  ProfessionalPlumberController(); // 👈 constructor
  final HomeController userController = Get.put(HomeController());
  var distances = <int, String>{}.obs;
  var distanceToUser = ''.obs;var isLoading = false.obs;

  var users = <Map<String, dynamic>>[].obs;
  late String catId;
  // Observable catId
  //var users = <Map<String, dynamic>>[].obs;
  var selected = 'charge'.obs;
  Position? currentPosition;

  Future<void> loadCatIdFromArguments() async {
    final args = Get.arguments;
    print("👀 Incoming arguments: $args"); // Debug print

    if (args != null && args['catId'] != null) {
      // catId.value = args['catId'];
      // print("✅ catId loaded from arguments: ${catId.value}");
    } else {
      print("❌ catId not found in arguments");
    }
  }
  Future<void> loadCatIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedCatId = prefs.getString('selectedCatId');

    if (savedCatId != null && savedCatId.isNotEmpty) {
      //  catId.value = savedCatId;
      print("✅ Loaded catId from SharedPreferences: $savedCatId");
    } else {
      print("❌ No catId found in SharedPreferences");
    }
  }

  Future<void> waitAndLoadArguments() async {
    await Future.delayed(Duration(milliseconds: 100));
    final args = Get.arguments;
    if (args != null && args['catId'] != null) {
      //   catId.value = args['catId'];
      // print("✅ Fallback catId loaded: ${catId.value}");
    }
  }





  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.locality ?? ''}, ${place.administrativeArea ?? ''}";
      }
    } catch (e) {
      print("Reverse geocoding error: $e");
    }
    return "Unknown Location";
  }

  Future<void> fetchUsersSortedByCharge() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final catId = prefs.getString('selectedCatId');
      final subCatId = prefs.getString('selectedSubCatId');

      isLoading.value = true; // Loader start

      print("🔎 Sorting users by charge for catId: $catId and subCatId: $subCatId");

      // ✅ Build URL with optional subCatId
      final url = Uri.parse(
        'https://jdapi.youthadda.co/user/getusersbycatsubcat'
            '?id=$catId&sortBy=lowToHigh'
            '${subCatId != null && subCatId.isNotEmpty ? '&subcat_id=$subCatId' : ''}',
      );

      var request = http.Request('GET', url);
      var response = await request.send();

      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        final jsonData = json.decode(resBody);
        final matchedCharge = jsonData['matchedCharge'] ?? 0;

        users.value = List<Map<String, dynamic>>.from(jsonData['data'] ?? []);

        print("✅ Sorted users fetched: ${users.length}");
      } else {
        users.clear(); // ⛔️ Clear users on failure
        print("❌ Failed to fetch sorted users");
      }
    } catch (e) {
      print("❗ Sort error: $e");
    } finally {
      isLoading.value = false; // Loader stop
    }
  }

  Future<void> fetchUsersWithDistance(String catId, {String? subCatId}) async {
    isLoading.value = true; // Start loader
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = position.latitude;
      double lng = position.longitude;

      print("📍 LAT: $lat, LNG: $lng, CATID: $catId, SUBCATID: $subCatId");

      final url = Uri.parse(
        'https://jdapi.youthadda.co/user/getusersbycatsubcat?id=$catId'
            '&lat=$lng&lng=$lat&nearMe=true'
            '${subCatId != null ? '&subcat_id=$subCatId' : ''}',
      );

      var request = http.Request('GET', url);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        final jsonData = json.decode(resBody);

        print("✅ RESPONSE: $jsonData");

        users.value = List<Map<String, dynamic>>.from(jsonData['data'] ?? []);

        for (var user in users) {
          print("👤 ${user['firstName']} - Distance: ${user['distance']} km");
        }
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.reasonPhrase}');
        print('❌ Full URL: $url');
      }
    } catch (e) {
      print('❌ Exception: $e');
    } finally {
      isLoading.value = false; // Stop loader
    }
  }








  Future<void> saveCurrentLocationToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (currentPosition != null) {
      await prefs.setDouble('lat1', currentPosition!.latitude);
      await prefs.setDouble('lng1', currentPosition!.longitude);
      print(
        "✅ Saved location: ${currentPosition!.latitude}, ${currentPosition!.longitude}",
      );
    } else {
      print("⚠️ currentPosition is null. Location not saved.");
    }
  }

  int? selectedIndexAfterCall;
  List<dynamic>? selectedUsers;
  String? selectedTitle;

  void setCallContext({
    required int index,
    required List users,
    required String title,
  }) {
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
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2); // in kilometers
  }


  @override
  void onInit() {
    fetchUsersSortedByCharge();
    final args = Get.arguments;
    if (args != null && args['catId'] != null) {
      catId = args['catId'];
      print("📦 catId loaded in controller: $catId");
    } else {
      catId = '';
      print("⚠️ catId is missing in arguments");
    }
    super.onInit(); Future.microtask(() async {
      await loadCatIdFromArguments();
    });
    waitAndLoadArguments();

    WidgetsBinding.instance.addObserver(this);


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
  final RxString bookedBy = ''.obs;
  final RxString bookedFor = ''.obs;
  final RxList<types.Message> messages = <types.Message>[].obs;
  final Rxn<types.User> user = Rxn<types.User>();
  late IO.Socket socket;

  // ProfessionalPlumberController(String catId);

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

  /// socket new booking

  void connectSocket() {
    if (bookedBy.value == null || bookedFor.value.isEmpty) {
      print(" User ID or BookedFor missing New booking");
      return;
    }

    print(
      '🔌 Connecting socket for user New booking: ${bookedBy.value}, bookedFor: ${bookedFor.value}',
    );

    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'auth': {
        'user': {
          '_id': bookedBy.value,
          'firstName': 'plumber naman', // Optional, can be dynamic
        },
      },
    });

    socket.connect();

    // socket.onConnect((_) {
    //   print('Connected to socket12121212');
    // });

    socket.onConnect((_) {
      print(' Connected to socket New booking');

      /// Emit userId and bookedFor after socket is connected
      final payload = {'receiver': bookedFor.value};

      print('Emitting newBooking payload New booking: $payload');
      socket.emit('newBooking', payload);
    });

    socket.onDisconnect((_) {
      print('New booking Disconnected from socket');
    });

    socket.onConnectError((err) {
      print('New booking Connect Error: $err');
    });

    socket.onError((err) {
      print('New booking Socket Error: $err');
    });

    /// Listen to newBooking messages
    socket.on('newBooking', (data) {
      print('📩 Received newBooking message: $data');

      final msg = types.TextMessage(
        id: data['_id'] ?? const Uuid().v4(),
        text: data['message'] ?? '',
        author: types.User(id: data['senderId'] ?? 'unknown'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      messages.insert(0, msg);
    });
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
                  backgroundImage:
                  imageUrl.isNotEmpty
                      ? NetworkImage('https://jdapi.youthadda.co/$imageUrl')
                      : const AssetImage('assets/images/account.png')
                  as ImageProvider,
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
                  title:
                  (skill['subcategoryName'] != null &&
                      skill['subcategoryName'].toString().isNotEmpty)
                      ? skill['subcategoryName']
                      : (skill['categoryName'] != null &&
                      skill['categoryName'].toString().isNotEmpty)
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
                          serviceIds: serviceIds,
                          selectedHelperName: '',
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
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
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
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 42,
                          width: 176,
                          child: ElevatedButton(
                            onPressed: () async {String serviceId =
                                skill['subcategoryId']?.toString() ??
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
                                  ),),],),),),
                        const SizedBox(height: 16),
                        SizedBox(height: 42, width: 176,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),),),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.close, color: Color(0xFF114BCA), size: 18,),
                                SizedBox(width: 10),
                                Text(
                                  "No", style: TextStyle(fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "poppins", color: Color(0xFF114BCA),
                                  ),),],),),),],),),],),),),);
      },
    );
  }
}