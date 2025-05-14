import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../RequestPandding/views/request_pandding_view.dart';

class ProfessionalPlumberController extends GetxController {
  //TODO: Implement ProfessionalPlumberController

  var workers = <Map<String, dynamic>>[].obs;

  Future<void> bookServiceProvider(String bookedForId) async {
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
        Get.snackbar("Success", "Service provider booked successfully");
        Get.to(RequestPanddingView());
      } else {
        print("❌ Error: ${response.reasonPhrase}");
        Get.snackbar("Error", "Booking failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception during booking: $e");
      Get.snackbar("Error", "Something went wrong during booking.");
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
