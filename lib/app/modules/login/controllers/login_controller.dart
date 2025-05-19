import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../auth_controller.dart';
import '../../otp/views/otp_view.dart';

class LoginController extends GetxController {
  final TextEditingController mobileController = TextEditingController();
  var isChecked = false.obs; // Observable state
  final box = GetStorage(); // <<<< ADDED GetStorage box

  void toggleCheck(bool value) {
    isChecked.value = value;
  }

  Future<void> sendOtp() async {
    final phone = mobileController.text.trim();

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
        print("✅ OTP API Response: $responseBody");

        final data = json.decode(responseBody);

        final otp = data['otp'] ?? '';
        final message = data['message']?.toString().toLowerCase() ?? '';

        /// 🛑 If already registered
        if (message.contains("already") || message.contains("exist")) {
          Get.snackbar(
            "Already Registered",
            "This number is already registered. Please login.",
            backgroundColor: Colors.red.shade100,
            colorText: Colors.black,
          );
          return;
        }

        // ✅ Save mobile number locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('mobileNumber', phone);

        // await box.write('isLoggedIn', true);
        // await box.write('mobile', phone);

        final authController = Get.find<AuthController>();
        authController.isLoggedIn.value = true;

        mobileController.clear();

        // ✅ Show OTP in snackbar
        if (otp.isNotEmpty) {
          Get.snackbar(
            "🔐 OTP Received",
            "Your OTP is: $otp",
            duration: Duration(seconds: 10),
            backgroundColor: Colors.black87,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }

        // ✅ Only navigate if not already registered
        Get.to(() => OtpView());
      } else {
        print("❌ Failed to send OTP: ${response.reasonPhrase}");
        Get.snackbar("Error", "Failed to send OTP: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception: $e");
      Get.snackbar("Error", "Exception occurred while sending OTP");
    }
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
    mobileController.dispose(); // controller dispose karna zaroori hai
  }

  void increment() => count.value++;
}
