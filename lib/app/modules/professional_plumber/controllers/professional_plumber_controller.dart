import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../CancelBooking/views/cancel_booking_view.dart';
import '../../RequestPandding/views/request_pandding_view.dart';
import '../../home/controllers/home_controller.dart';

class ProfessionalPlumberController extends GetxController {
  final HomeController userController = Get.put(HomeController());
  //TODO: Implement ProfessionalPlumberController
  void loadSkills() async {
    List<Map<String, dynamic>> skills = await userController.getSkillsFromPrefs();
    print("🛠️ Retrieved Skills: $skills");
  }

  final landMark = Rx<String>('');final houseNo = Rx<String>('');
  Future<void> bookServiceProvider(String bookedForId, {required String helperName}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId2 = prefs.getString('userId2');

      if (userId2 == null) {
        Get.snackbar("Error", "User ID not found in SharedPreferences");
        return;
      }

      var headers = {
        'Content-Type': 'application/json',
      };

      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/bookserviceprovider'),
      );

      request.body = json.encode({
        "bookedBy": userId2,
        "bookedFor": bookedForId,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final resBody = await response.stream.bytesToString();
      print("📦 Response: $resBody");

      if (response.statusCode == 200) {
        Get.snackbar("", "Send Request Successfully");

        // Pass helper name to the next screen
        Get.to(() => RequestPanddingView(helperName: helperName));
      } else {
        print("❌ Error: ${response.reasonPhrase}");
        Get.snackbar("Error", "Booking failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception during booking: $e");
      Get.snackbar("Error", "Something went wrong during booking.");
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


  void makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
  }
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

  }


  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
