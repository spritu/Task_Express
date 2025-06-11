// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;
//
// import '../../CancelBooking/views/cancel_booking_view.dart';
//
// class BookingController extends GetxController {
//   //TODO: Implement BookingController
//   var isLoading = false.obs;
//  // var bookings = <BookingModel>[].obs;
//   var bookingList = [].obs;
//   @override
//   void onInit() {
//     super.onInit();
//     fetchCurrentBookings();
//     fetchPastBookings();
//   }
//   // Inside your controller
//   //var bookingList = <dynamic>[].obs;
//   var bookings = <dynamic>[].obs;
//   Future<void> fetchCurrentBookings() async {
//     isLoading.value = true;
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userId2 = prefs.getString('userId');
//
//     var headers = {'Content-Type': 'application/json'};
//     var request = http.Request(
//       'POST',
//       Uri.parse('https://jdapi.youthadda.co/getusercurrentbooking'),
//     );
//     request.body = json.encode({"userId": userId2});
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       final result = await response.stream.bytesToString();
//       final decoded = json.decode(result);
//       print("API Response: $decoded");
//
//       if (decoded["code"] == 200 && decoded["data"] != null) {
//         bookings.value = decoded["data"];
//
//         // ✅ Save `id` or `bookid` to SharedPreferences
//         // If "data" is a list:
//         if (decoded["data"] is List && decoded["data"].isNotEmpty) {
//           final firstBooking = decoded["data"][0];
//           final bookId = firstBooking["_id"]; // or "bookid", based on your actual API field
//           if (bookId != null) {
//             await prefs.setString('bookId', bookId.toString());
//             print("Saved bookId to SharedPreferences: $bookId");
//           }
//         }
//
//       } else {
//         bookings.clear();
//       }
//     } else {
//       print("Error: ${response.reasonPhrase}");
//     }
//
//     isLoading.value = false;
//   }
//
//
//
//   var pastBookings = [].obs;
//
//
//   Future<void> fetchPastBookings() async {
//     isLoading.value = true;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userId = prefs.getString('userId');
//
//     var headers = {'Content-Type': 'application/json'};
//     var request = http.Request(
//       'POST',
//       Uri.parse('https://jdapi.youthadda.co/getuserpastbooking'),
//     );
//     request.body = json.encode({"userId": userId});
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       final result = await response.stream.bytesToString();
//       final decoded = json.decode(result);
//       print("Past Booking Response: $decoded");
//
//       if (decoded["code"] == 200 && decoded["data"] != null) {
//         pastBookings.value = decoded["data"];
//       } else {
//         pastBookings.clear();
//       }
//     } else {
//       print("Error: ${response.reasonPhrase}");
//     }
//
//     isLoading.value = false;
//   }
//
//   Future<void> rejectBooking() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? bookId = prefs.getString('bookId');
//
//     var headers = {
//       'Content-Type': 'application/json',
//     };
//     var request = http.Request(
//       'POST',
//       Uri.parse('https://jdapi.youthadda.co/acceptreject'),
//     );
//
//     request.body = json.encode({
//       "bookingId":bookId,
//       "accept": "no",
//     });
//
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       String result = await response.stream.bytesToString();
//       print(result);
//      Get.to(CancelBookingView());
//
//     } else {
//       print(response.reasonPhrase);
//
//     }
//   }
//
//   void makePhoneCall(String phoneNumber) async {
//     final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(callUri)) {
//       await launchUrl(callUri);
//     } else {
//      // Get.snackbar('Error', 'Could not launch phone call');
//     }
//   }
//   var currentBooking = {}.obs;var showRequestPending = false.obs;var helperName = ''.obs;
// var hasBooking = true.obs; // Or false if no booking
//
//   var booking = Rxn<Booking>();
//
//   Future<void> fetchCurrentBooking() async {
//     isLoading.value = true;
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? userId2 = prefs.getString('userId');
//
//       print("📦 Service Provider userId: $userId2"); // 👈 PRINT USER ID HERE
//
//       var headers = {
//         'Content-Type': 'application/json'
//       };
//       var request = http.Request(
//         'POST',
//         Uri.parse('https://jdapi.youthadda.co/getserprocurrentbooking'),
//       );
//       request.body = json.encode({
//         "serviceProId": userId2,
//       });
//       request.headers.addAll(headers);
//
//       http.StreamedResponse response = await request.send();
//
//       if (response.statusCode == 200) {
//         String res = await response.stream.bytesToString();
//         print("📥 Raw Response: $res"); // 👈 RAW RESPONSE
//         print("rrrrrrrrrrrrrrrrrrrrrrrr");
//         currentBooking.value = json.decode(res);
//       } else {
//       //  Get.snackbar("Error", "Failed to fetch booking");
//       }
//     } catch (e) {
//     //  Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
//
// class BookingModel {
//   final String name;
//   final String profession;
//   final String bookingTime;
//
//   BookingModel({required this.name, required this.profession, required this.bookingTime});
//
//   factory BookingModel.fromJson(Map<String, dynamic> json) {
//     return BookingModel(
//       name: json['firstName'] ?? 'N/A',
//       profession: json['phone'] ?? 'N/A',
//       bookingTime: json['booking_time'] ?? '',
//     );
//   }
// }
//
// Future<void> fetchUserCurrentBooking() async {
//   try {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userId2 = prefs.getString('userId');
//     var headers = {'Content-Type': 'application/json'};
//     var request = http.Request(
//       'POST',
//       Uri.parse('https://jdapi.youthadda.co/getusercurrentbooking'),
//     );
//
//     request.body = json.encode({
//       "userId": userId2,
//     });
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       final responseBody = await response.stream.bytesToString();
//       print("✅ API Response:");
//       print(responseBody);
//
//       // Optional: Decode if needed
//       final result = json.decode(responseBody);
//       print("📦 Decoded JSON:");
//       print(result);
//     } else {
//       print("❌ Error: ${response.reasonPhrase}");
//     }
//   } catch (e) {
//     print("⚠️ Exception: $e");
//   }
// }
//
//
// void makePhoneCall(String phoneNumber) async {
//   final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
//   if (await canLaunchUrl(callUri)) {
//     await launchUrl(callUri);
//   } else {
//    // Get.snackbar('Error', 'Could not launch phone call');
//   }
// }
//
// var bookings = <BookingModel>[].obs;
//   final count = 0.obs;
//   @override
//   void onInit() {
//     fetchUserCurrentBooking();
//   }
// Future<void> fetchBookings() async {
//   var headers = {'Content-Type': 'application/json'};
//   var request = http.Request('POST', Uri.parse('https://jdapi.youthadda.co/getusercurrentbooking'));
//
//   request.body = json.encode({"userId": "682b28bda976fa14107b0b6e"});
//   request.headers.addAll(headers);
//
//   http.StreamedResponse response = await request.send();
//
//   if (response.statusCode == 200) {
//     final jsonString = await response.stream.bytesToString();
//     print("✅ Response: $jsonString"); // 👈 yeh line add karein
//     final result = json.decode(jsonString);
//
//     if (result['data'] is List) {
//       bookings.value = (result['data'] as List)
//           .map((e) => BookingModel.fromJson(e))
//           .toList();
//     } else if (result['data'] is Map) {
//       bookings.value = [BookingModel.fromJson(result['data'])];
//     }
//   } else {
//     print("❌ Error: ${response.reasonPhrase}");
//   }
// }
//
//   @override
//   void onReady() {
//
//   }
//
//   @override
//   void onClose() {
//
//
//   void increment() => count.value++;
// }
// class Booking {
//   final String id;
//   final User bookedBy;
//   final User bookedFor;
//   final int completeJob;
//   final DateTime createdAt;
//
//   Booking({
//     required this.id,
//     required this.bookedBy,
//     required this.bookedFor,
//     required this.completeJob,
//     required this.createdAt,
//   });
//
//   factory Booking.fromJson(Map<String, dynamic> json) {
//     return Booking(
//       id: json['_id'],
//       bookedBy: User.fromJson(json['bookedBy']),
//       bookedFor: User.fromJson(json['bookedFor']),
//       completeJob: json['completeJob'] ?? 0,
//       createdAt: DateTime.parse(json['createdAt']),
//     );
//   }
// }
//
// class User {
//   final String id;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String phone;
//   final String gender;
//   final String city;
//   final String state;
//
//   User({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.phone,
//     required this.gender,
//     required this.city,
//     required this.state,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['_id'],
//       firstName: json['firstName'] ?? '',
//       lastName: json['lastName'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       gender: json['gender'] ?? '',
//       city: json['city'] ?? '',
//       state: json['state'] ?? '',
//     );
//   }
//
// }
//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;
import 'package:uuid/uuid.dart';

import '../../../../auth_controller.dart';
import '../../CancelBooking/views/cancel_booking_view.dart';
import '../../login/views/login_view.dart';

class BookingController extends GetxController {
  //TODO: Implement BookingController
  var isLoading = false.obs;
  var userList = <UserModel>[].obs;

  // var bookings = <BookingModel>[].obs;
  var bookingList = [].obs;
  var bookinged = <String, dynamic>{}.obs;

  late IO.Socket socket;
  final RxList<types.Message> messages = <types.Message>[].obs;
  var userId = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCurrentBookings();
    connectSocketAccept();
    connectSocketReject();
    fetchUserPastBooking();

    //  fetchUserCurrentBooking();
  }

  Future<void> fetchUserPastBooking() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId2 = prefs.getString('userId');

      if (userId2 == null) {
        print("User ID not found in SharedPreferences.");
        return;
      }

      isLoading.value = true;

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/getuserpastbooking'),
      );
      request.body = json.encode({"userId": userId2});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("API Response: $responseBody");

        final data = json.decode(responseBody);

        if (data['data'] != null) {
          var users = data['data'] as List;
          userList.value = users.map((e) => UserModel.fromJson(e)).toList();
        } else {
          userList.clear();
        }
      } else {
        print("Error: ${response.reasonPhrase}");
        userList.clear();
      }
    } catch (e) {
      print("Exception: $e");
      userList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Inside your controller
  //var bookingList = <dynamic>[].obs;
  var bookings = <dynamic>[].obs;

  var showBookingCard = true.obs;

  // Example method to hide card after closing job
  void closeJobAndSubmitRating(double rating, String feedback) {
    // Call your API here or process the data
    print('Rating: $rating, Feedback: $feedback');

    // Hide the booking card
    showBookingCard.value = false;
  }

  Future<void> fetchCurrentBookings() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId2 = prefs.getString('userId');

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/getusercurrentbooking'),
    );
    request.body = json.encode({"userId": userId2});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      connectSocketAccept();
      connectSocketReject();
      final result = await response.stream.bytesToString();
      final decoded = json.decode(result);
      print("API Response: $decoded");

      if (decoded["code"] == 200 && decoded["data"] != null) {
        bookings.value = decoded["data"];
        print("boookiiiing:${bookings}");
      } else {
        bookings.clear();
      }
    } else {
      print("Error: ${response.reasonPhrase}");
    }

    isLoading.value = false;
  }

  String formatCreatedAt(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final createdDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
      final timeFormat = DateFormat('h:mm a');

      if (createdDate == today) {
        return "Today, ${timeFormat.format(dateTime)}";
      } else {
        final dateFormat = DateFormat('d MMM yyyy, h:mm a');
        return dateFormat.format(dateTime);
      }
    } catch (e) {
      return createdAt;
    }
  }

  void connectSocketAccept() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId2 = prefs.getString('userId');
    print('444444: ${userId2}');

    print("❌ listenAccept :${userId2}");

    if (userId2 == null) {
      print("❌ User ID or BookedFor missing");
      return;
    }

    print('🔌 Connecting socket for user: ${userId2}');

    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'auth': {
        'user': {
          '_id': userId2,
          'firstName': 'plumber naman', // Optional, can be dynamic
        },
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected 2222 booking1');
    });

    print('socket99:${socket}');

    socket.on('acceptBooking', (data) {
      print('📩 Received acceptBooking message23: $data');

      fetchCurrentBookings();
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

  void connectSocketReject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId2 = prefs.getString('userId');
    print('444444: ${userId2}');

    print("❌ listenAccept :${userId2}");

    if (userId2 == null) {
      print("❌ User ID or BookedFor missing");
      return;
    }

    print('🔌 Connecting socket for user: ${userId2}');

    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'auth': {
        'user': {
          '_id': userId2,
          'firstName': 'plumber naman', // Optional, can be dynamic
        },
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected 2222 booking2');
    });

    print('socket99:${socket}');

    socket.on('rejectBooking', (data) {
      print('📩 Received rejectBooking message23: $data');

      fetchCurrentBookings();
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

  Future<void> rejectBooking() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/acceptreject'),
    );

    request.body = json.encode({
      "bookingId": "680883961c5342a65525df76",
      "accept": "no",
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
      Get.to(CancelBookingView());
      //  Get.snackbar("Success", "Booking rejected");
    } else {
      print(response.reasonPhrase);
      //  Get.snackbar("Error", "Something went wrong");
    }
  }

  void makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      // Get.snackbar('Error', 'Could not launch phone call');
    }
  }

  var currentBooking = {}.obs;
  var showRequestPending = false.obs;
  var helperName = ''.obs;
  var hasBooking = true.obs; // Or false if no booking

  var booking = Rxn<Booking>();
}

class BookingModel {
  final String name;
  final String profession;
  final String bookingTime;

  BookingModel({
    required this.name,
    required this.profession,
    required this.bookingTime,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      name: json['firstName'] ?? 'N/A',
      profession: json['phone'] ?? 'N/A',
      bookingTime: json['booking_time'] ?? '',
    );
  }
}

Future<void> fetchUserCurrentBooking() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId2 = prefs.getString('userId');
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/getusercurrentbooking'),
    );

    request.body = json.encode({"userId": userId2});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print("✅ API Response:");
      print(responseBody);

      // Optional: Decode if needed
      final result = json.decode(responseBody);
      print("📦 Decoded JSON:");
      print(result);
    } else {
      print("❌ Error: ${response.reasonPhrase}");
    }
  } catch (e) {
    print("⚠️ Exception: $e");
  }
}

void makePhoneCall(String phoneNumber) async {
  final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(callUri)) {
    await launchUrl(callUri);
  } else {
    // Get.snackbar('Error', 'Could not launch phone call');
  }
}

var bookings = <BookingModel>[].obs;
var bookingId = ''.obs;
var count = 0.obs;
@override
void onInit() {
  fetchUserCurrentBooking();

  final Map<String, dynamic> booking = Get.arguments;
  print('65656565:${booking}');

  bookingId.value = booking['data']['_id'];
}



void Function(Function(BuildContext))? onNeedContext;
final AuthController authController = Get.find<AuthController>();
@override
void onReady() {
  //super.onReady();
  Future.delayed(Duration.zero, () {
    if (!authController.isLoggedIn.value) {

      if (onNeedContext != null) {
        onNeedContext!(showSignupSheet);
      }
    }
  });
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
            color: Color(0xffD9E4FC),
            boxShadow: [BoxShadow(blurRadius: 4, color: Color(0xFFD9E4FC))],

            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              // horizontal: 16.0,
              vertical: 16.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("  "),
                      SizedBox(width: 30),
                      Row(
                        children: [
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

                  Image.asset(
                    "assets/images/Signupbro.png",
                    height: 293,
                    width: 393,
                  ),
                  const SizedBox(height: 20),

                  Padding(
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
                        Get.to(LoginView());
                      },
                      child: Text(
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
                  Padding(
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

@override
void onClose() {}
void increment() => count.value++;

class Booking {
  final String id;
  final User bookedBy;
  final User bookedFor;
  final int completeJob;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.bookedBy,
    required this.bookedFor,
    required this.completeJob,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      bookedBy: User.fromJson(json['bookedBy']),
      bookedFor: User.fromJson(json['bookedFor']),
      completeJob: json['completeJob'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

String formatDate(String isoDate) {
  final DateTime dateTime =
      DateTime.parse(isoDate).toLocal(); // convert to local time
  final DateFormat formatter = DateFormat(
    'dd MMM yyyy, hh:mm a',
  ); // e.g., 22 May 2025, 12:09 PM
  return formatter.format(dateTime);
}

class UserModel {
  final String id;
  final Map<String, dynamic> bookedBy;
  final Map<String, dynamic> bookedFor;
  final List<dynamic> bookServices;
  final int completeJob;
  final String accept;
  final bool paymentDoneBySp;
  final bool paymentDoneByUser;
  final String jobStartTime;
  final String jobEndTime;
  final int pay;
  final String? userImg;
  final String spType; // 👈 ADD THIS

  UserModel({
    required this.id,
    required this.bookedBy,
    required this.bookedFor,
    required this.bookServices,
    required this.completeJob,
    required this.accept,
    this.userImg,
    required this.paymentDoneBySp,
    required this.paymentDoneByUser,
    required this.jobStartTime,
    required this.jobEndTime,
    required this.pay,
    required this.spType, // 👈 ADD THIS
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    String spTypeValue = '1'; // default if not found

    // Extract spType from first bookService if available
    if (json['bookServices'] != null &&
        (json['bookServices'] as List).isNotEmpty) {
      final firstService = (json['bookServices'] as List).first;
      spTypeValue = firstService['spType']?.toString() ?? '1';
    }

    print("spType from API extracted: $spTypeValue");

    // 👇 Extract userImg from bookedFor object
    final userImgPath = json['bookedFor']?['userImg'];
    print("Extracted userImg: $userImgPath");

    return UserModel(
      id: json['_id'] ?? '',
      userImg: userImgPath,
      bookedBy: json['bookedBy'] ?? {},
      bookedFor: json['bookedFor'] ?? {},
      bookServices: json['bookServices'] ?? [],
      completeJob: json['completeJob'] ?? 0,
      accept: json['accept'] ?? '',
      paymentDoneBySp: json['paymentdonebysp'] ?? false,
      paymentDoneByUser: json['paymentdonebyuser'] ?? false,
      jobStartTime: json['jobStartTime'] ?? '',
      jobEndTime: json['jobEndTime'] ?? '',
      pay: json['pay'] ?? 0,
      spType: spTypeValue,
    );
  }

  // factory UserModel.fromJson(Map<String, dynamic> json) {
  //   String spTypeValue = '1'; // default if not found
  //
  //   // Check if bookServices list exists and is not empty
  //   if (json['bookServices'] != null && (json['bookServices'] as List).isNotEmpty) {
  //     final firstService = (json['bookServices'] as List).first;
  //     spTypeValue = firstService['spType']?.toString() ?? '1';
  //   }
  //
  //
  //   print("spType from API extracted: $spTypeValue");  // Debug print
  //
  //   return UserModel(
  //     id: json['_id'] ?? '',
  //     userImg: json['bookedFor']?['userImg'],
  //
  //     bookedBy: json['bookedBy'] ?? {},
  //     bookedFor: json['bookedFor'] ?? {},
  //     bookServices: json['bookServices'] ?? [],
  //     completeJob: json['completeJob'] ?? 0,
  //     accept: json['accept'] ?? '',
  //     paymentDoneBySp: json['paymentdonebysp'] ?? false,
  //     paymentDoneByUser: json['paymentdonebyuser'] ?? false,
  //     jobStartTime: json['jobStartTime'] ?? '',
  //     jobEndTime: json['jobEndTime'] ?? '',
  //     pay: json['pay'] ?? 0,
  //     spType: spTypeValue,
  //   );
  // }
}

class SkillModel {
  final String categoryId;
  final String? subcategoryId;
  final int? charge;
  final String id;

  SkillModel({
    required this.categoryId,
    this.subcategoryId,
    this.charge,
    required this.id,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      categoryId: json['categoryId'] ?? '',
      subcategoryId: json['sucategoryId'],
      charge: json['charge'],
      id: json['_id'] ?? '',
    );
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;
  final String city;
  final String state;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.city,
    required this.state,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }
}
