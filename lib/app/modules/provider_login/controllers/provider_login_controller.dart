import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider_otp/views/provider_otp_view.dart';
class ProviderLoginController extends GetxController {
  //TODO: Implement ProviderLoginController

  final TextEditingController mobileeController = TextEditingController();
  var isChecked = false.obs; // Observable
  final box = GetStorage();

  Future<void> sendOtp() async {
    final phone = mobileeController.text.trim();

    if (phone.isEmpty || phone.length != 10) {
      Get.snackbar("Error", "Please enter a valid 10-digit mobile number");
      return;
    }

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({"phone": phone});
    final url = Uri.parse('https://jdapi.youthadda.co/user/sendotp');

    try {
      final request = http.Request('POST', url);
      request.body = body;
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("✅ OTP sent successfully: $responseBody");

        // ✅ Save phone number for OTP verification
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('mobileNumber', phone);

        // ✅ Save Login State TRUE using GetStorage
        await box.write('isLoggedIn', true);
        await box.write('mobile', phone); // (optional) mobile bhi save karlo if needed
        mobileeController.clear();
        // ✅ Navigate to OTP Screen
        Get.to(() => ProviderOtpView());

      } else {
        print("❌ Failed to send OTP: ${response.reasonPhrase}");
        Get.snackbar("Error", "Failed to send OTP: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }


  void toggleCheck(bool value) {
    isChecked.value = value;
  }
  void openTerms() {
    print('Terms & Conditions clicked');

  }
  final String baseUrl = 'https://dg-sandbox.setu.co/api/okyc';
  final String clientId = 'test-client';
  final String clientSecret = 'YOUR_CLIENT_SECRET';
  final String productInstanceId = 'YOUR_PRODUCT_INSTANCE_ID';

  Future<Map<String, dynamic>> verifyAadhaarCard(
      String requestId, String aadhaarNumber, String captchaCode) async {
    final url = Uri.parse('$baseUrl/$requestId/verify');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-client-id': clientId,
        'x-client-secret': clientSecret,
        'x-product-instance-id': productInstanceId,
      },
      body: jsonEncode({
        'aadhaarNumber': aadhaarNumber,
        'captchaCode': captchaCode,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify Aadhaar card: ${response.reasonPhrase}');
    }
  }
  void openPrivacy() {
    print('Privacy Policy clicked');
    // Aap yahan Get.toNamed('/privacy') ya URL launch kar sakte hain
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
