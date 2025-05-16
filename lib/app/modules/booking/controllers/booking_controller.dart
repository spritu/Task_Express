import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;

import '../../CancelBooking/views/cancel_booking_view.dart';

class BookingController extends GetxController {
  //TODO: Implement BookingController
  var currentBooking = {}.obs;var showRequestPending = false.obs;var helperName = ''.obs;
  var isLoading = false.obs;var
  hasBooking = true.obs; // Or false if no booking
  var booking = Rxn<Booking>();
  Future<void> fetchCurrentBooking() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      print("📦 Service Provider userId: $userId"); // 👈 PRINT USER ID HERE

      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/getserprocurrentbooking'),
      );
      request.body = json.encode({
        "serviceProId": userId,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String res = await response.stream.bytesToString();
        print("📥 Raw Response: $res"); // 👈 RAW RESPONSE
        currentBooking.value = json.decode(res);
      } else {
        Get.snackbar("Error", "Failed to fetch booking");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }




}
  void makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
  }
  Future<void> rejectBooking() async {
    var headers = {
      'Content-Type': 'application/json',
    };
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
      Get.snackbar("Success", "Booking rejected");
    } else {
      print(response.reasonPhrase);
      Get.snackbar("Error", "Something went wrong");
    }
  }

  final count = 0.obs;
  @override
  void onInit() {

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

