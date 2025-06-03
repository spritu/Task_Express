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
  var distanceToUser = ''.obs;

  Position? currentPosition;
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String?> fetchDistance(double lat1, double lon1, double lat2, double lon2) async {
    var url = Uri.parse('https://jdapi.youthadda.co/getdistance?lat1=$lat1&lon1=$lon1&lat2=$lat2&lon2=$lon2');

    var request = http.MultipartRequest('GET', url);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final distanceString = await response.stream.bytesToString();
      return distanceString;
    } else {
      print('Error: ${response.reasonPhrase}');
      return null;
    }
  }
  List<dynamic> users = []; // List of service providers

  // Future<void> getDistanceFromUserToProvider(Map<String, dynamic> user) async {
  //   try {
  //     // Step 1: Get your current location
  //     Position currentPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //
  //     double currentLat = currentPosition.latitude;
  //     double currentLon = currentPosition.longitude;
  //
  //     // Step 2: Get provider's location (GeoJSON format: [longitude, latitude])
  //     if (user['location'] != null &&
  //         user['location']['coordinates'] != null &&
  //         user['location']['coordinates'].length == 2) {
  //
  //       double providerLon = user['location']['coordinates'][0]; // Longitude
  //       double providerLat = user['location']['coordinates'][1]; // Latitude
  //
  //       print('📍 Provider Location: ($providerLat, $providerLon)');
  //       print('📍 Your Location: ($currentLat, $currentLon)');
  //
  //       // Step 3: Call the distance API
  //       var url = Uri.parse(
  //         'https://jdapi.youthadda.co/getdistance?lat1=$currentLat&lon1=$currentLon&lat2=$providerLat&lon2=$providerLon',
  //       );
  //
  //       var response = await http.get(url);
  //
  //       if (response.statusCode == 200) {
  //         var distJson = json.decode(response.body);
  //
  //         if (distJson['code'] == 200 &&
  //             distJson['data'] != null &&
  //             distJson['data']['distance'] != null) {
  //           double distance = double.tryParse(distJson['data']['distance'].toString()) ?? 0;
  //           user['distance'] = distance.toStringAsFixed(2); // Like "12.34"
  //           print('✅ Distance: ${user['distance']} km');
  //           print('My Location: $currentLat, $currentLon');
  //           print('Provider Location: $providerLat, $providerLon');
  //
  //         } else {
  //           user['distance'] = 'N/A';
  //           print('⚠️ Distance data missing');
  //         }
  //       } else {
  //         user['distance'] = 'N/A';
  //         print('❌ Failed to get distance: ${response.reasonPhrase}');
  //       }
  //     } else {
  //       user['distance'] = 'N/A';
  //       print('⚠️ Provider location invalid');
  //     }
  //   } catch (e) {
  //     user['distance'] = 'N/A';
  //     print('⚠️ Error: $e');
  //   }
  // }

  // Future<void> fetchAndProcessUsers() async {
  //   try {
  //     var response = await http.get(Uri.parse('https://api.example.com/users'));
  //
  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.body);
  //       users = data['data']; // Replace with actual path
  //
  //       // Call distance function for each user
  //       for (var user in users) {
  //         await getDistanceFromUserToProvider(user);
  //       }
  //
  //       update(); // GetX use kar rahe ho to UI update hoga
  //     } else {
  //       print("❌ Failed to fetch users");
  //     }
  //   } catch (e) {
  //     print("⚠️ Error: $e");
  //   }
  // }


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
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) ; // in kilometers
  }
  // Future<void> getCurrentLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     await Geolocator.openLocationSettings();
  //     return;
  //   }
  //
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //   }
  //
  //   currentPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  @override
  void onInit() {
    super.onInit();
    //  getDistanceFromApi( lat2,  lng2)
    //   getDistanceFromSharedPrefs(lat2,);
    WidgetsBinding.instance.addObserver(this);

  }
  // Future<void> fetchDistanceForUser(int index, double lat2, double lng2) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   double? lat1 = prefs.getDouble('lat1');
  //   double? lng1 = prefs.getDouble('lng1');
  //
  //   if (lat1 != null && lng1 != null) {
  //     final url = Uri.parse(
  //         'https://jdapi.youthadda.co/getdistance?lat1=$lat1&lon1=$lng1&lat2=$lat2&lon2=$lng2');
  //
  //     try {
  //       var request = http.MultipartRequest('GET', url);
  //       http.StreamedResponse response = await request.send();
  //
  //       if (response.statusCode == 200) {
  //         String result = await response.stream.bytesToString();
  //         var data = json.decode(result);
  //         print("✅ API response: $data");
  //
  //         // ✅ Extract from `data['data']['distance']`
  //         if (data['data'] != null && data['data']['distance'] != null) {
  //           double rawDistance = data['data']['distance'];
  //          // String formattedDistance = (rawDistance / 1000).toStringAsFixed(2); // convert to KM
  //           //distances[index] = '$formattedDistance KM';
  //           print("📏 Distance for user[$index]: ${distances[index]}");
  //         } else {
  //           distances[index] = 'N/A';
  //         }
  //       } else {
  //         distances[index] = 'Error';
  //         print("❌ Failed with status: ${response.statusCode}");
  //       }
  //     } catch (e) {
  //       distances[index] = 'Error';
  //       print("❌ Exception: $e");
  //     }
  //   } else {
  //     distances[index] = 'No Location';
  //   }
  //
  //   update(); // update UI in GetX
  // }




  // void updateUserDistances(List<dynamic> users) {
  //   for (int i = 0; i < users.length; i++) {
  //     final lat = double.tryParse(users[i]['lat'] ?? '0') ?? 0.0;
  //     final lng = double.tryParse(users[i]['lng'] ?? '0') ?? 0.0;
  //
  //     if (lat != 0.0 && lng != 0.0) {
  //       fetchDistanceForUser(i, lat, lng);
  //     } else {
  //       distances[i] = 'Invalid';
  //     }
  //   }
  // }

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
      Get.snackbar('Error', 'Could not launch phone call');
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
        Get.snackbar("Error", "User ID not found in local storage.");
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
        Get.snackbar('Booking Failed', 'Please try again later.');
      }
    } catch (e) {
      print("❌ Exception in booking: $e");
      Get.snackbar('Error', 'Something went wrong: $e');
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