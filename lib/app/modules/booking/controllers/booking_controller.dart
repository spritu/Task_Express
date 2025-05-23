import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;

import '../../CancelBooking/views/cancel_booking_view.dart';

class BookingController extends GetxController {
  //TODO: Implement BookingController
  var isLoading = false.obs;
 // var bookings = <BookingModel>[].obs;
  var bookingList = [].obs;
  @override
  void onInit() {
    super.onInit();
    fetchCurrentBookings();
    fetchPastBookings();
  }
  // Inside your controller
  //var bookingList = <dynamic>[].obs;
  var bookings = <dynamic>[].obs;
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
      final result = await response.stream.bytesToString();
      final decoded = json.decode(result);
      print("API Response: $decoded");

      if (decoded["code"] == 200 && decoded["data"] != null) {
        bookings.value = decoded["data"];

        // ✅ Save `id` or `bookid` to SharedPreferences
        // If "data" is a list:
        if (decoded["data"] is List && decoded["data"].isNotEmpty) {
          final firstBooking = decoded["data"][0];
          final bookId = firstBooking["_id"]; // or "bookid", based on your actual API field
          if (bookId != null) {
            await prefs.setString('bookId', bookId.toString());
            print("Saved bookId to SharedPreferences: $bookId");
          }
        }

      } else {
        bookings.clear();
      }
    } else {
      print("Error: ${response.reasonPhrase}");
    }

    isLoading.value = false;
  }



  var pastBookings = [].obs;


  Future<void> fetchPastBookings() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/getuserpastbooking'),
    );
    request.body = json.encode({"userId": userId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      final decoded = json.decode(result);
      print("Past Booking Response: $decoded");

      if (decoded["code"] == 200 && decoded["data"] != null) {
        pastBookings.value = decoded["data"];
      } else {
        pastBookings.clear();
      }
    } else {
      print("Error: ${response.reasonPhrase}");
    }

    isLoading.value = false;
  }

  Future<void> rejectBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bookId = prefs.getString('bookId');

    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/acceptreject'),
    );

    request.body = json.encode({
      "bookingId":bookId,
      "accept": "no",
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
     Get.to(CancelBookingView());

    } else {
      print(response.reasonPhrase);

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
  var currentBooking = {}.obs;var showRequestPending = false.obs;var helperName = ''.obs;
var hasBooking = true.obs; // Or false if no booking

  var booking = Rxn<Booking>();

  Future<void> fetchCurrentBooking() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId2 = prefs.getString('userId');

      print("📦 Service Provider userId: $userId2"); // 👈 PRINT USER ID HERE

      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/getserprocurrentbooking'),
      );
      request.body = json.encode({
        "serviceProId": userId2,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String res = await response.stream.bytesToString();
        print("📥 Raw Response: $res"); // 👈 RAW RESPONSE
        print("rrrrrrrrrrrrrrrrrrrrrrrr");
        currentBooking.value = json.decode(res);
      } else {
      //  Get.snackbar("Error", "Failed to fetch booking");
      }
    } catch (e) {
    //  Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

class BookingModel {
  final String name;
  final String profession;
  final String bookingTime;

  BookingModel({required this.name, required this.profession, required this.bookingTime});

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

    request.body = json.encode({
      "userId": userId2,
    });
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
  final count = 0.obs;
  @override
  void onInit() {
    fetchUserCurrentBooking();
  }
Future<void> fetchBookings() async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request('POST', Uri.parse('https://jdapi.youthadda.co/getusercurrentbooking'));

  request.body = json.encode({"userId": "682b28bda976fa14107b0b6e"});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    final jsonString = await response.stream.bytesToString();
    print("✅ Response: $jsonString"); // 👈 yeh line add karein
    final result = json.decode(jsonString);

    if (result['data'] is List) {
      bookings.value = (result['data'] as List)
          .map((e) => BookingModel.fromJson(e))
          .toList();
    } else if (result['data'] is Map) {
      bookings.value = [BookingModel.fromJson(result['data'])];
    }
  } else {
    print("❌ Error: ${response.reasonPhrase}");
  }
}

  @override
  void onReady() {

  }

  @override
  void onClose() {


  void increment() => count.value++;
}
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

