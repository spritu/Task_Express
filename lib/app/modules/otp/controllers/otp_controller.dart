import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../signUp/views/sign_up_view.dart';

class OtpController extends GetxController {
  TextEditingController otpController = TextEditingController();
  String? mobileNumber;
  var userId = ''.obs;
  var token = ''.obs;
  var email = ''.obs;
  List<TextEditingController> otpControllers =
  List.generate(4, (index) => TextEditingController());

  @override
  void onInit() {
    super.onInit();
    loadMobileNumber();
  }
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    String? userId2 = prefs.getString('userId2');
    String? token = prefs.getString('token');
    String? email = prefs.getString('email');

    // Use the loaded data as needed
    print("🔑 Loaded userId2: $userId2");
    print("🔑 Loaded token: $token");
    print("🔑 Loaded email: $email");

    // You can also update the UI or variables as needed here
  }
  Future<void> loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    mobileNumber = prefs.getString('mobileNumber');

  }
  // Move focus on pin code fields
  void moveToNext(int index, String value) {
    if (value.length == 1) {
      if (index < otpControllers.length - 1) {
        FocusScope.of(Get.context!).nextFocus();
      } else {
        FocusScope.of(Get.context!).unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(Get.context!).previousFocus();
    }
  }


  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty || otp.length != 4) {
      Get.snackbar("Error", "Please enter a valid 4-digit OTP", colorText: Colors.red);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobileNumber = prefs.getString('mobileNumber');

    // Print all shared preferences data for debugging


    if (mobileNumber == null || mobileNumber.isEmpty) {
      Get.snackbar("Error", "Mobile number not found. Please try again.", colorText: Colors.red);
      return;
    }

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "phone": mobileNumber,
      "otp": otp,
    });

    final url = Uri.parse('https://jdapi.youthadda.co/user/verifyotp');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        print("✅ OTP Verified. Full Response:\n${jsonEncode(responseData)}");

        // Save the token and user data
        prefs.setString('token', responseData['token'] ?? '');
        prefs.setInt('userType', responseData['userType'] ?? 0);

        final userId = responseData['id'];
        await prefs.setString('userId2', userId ?? ''); // Ensure userId is saved properly
        final email = responseData['userData']?['email'] ?? '';
        if (email.isNotEmpty) {
          await prefs.setString('email', email);
        }

        // Reload preferences after saving
        await prefs.reload();

        otpController.clear();
        Get.snackbar("✅ Success", responseData['msg'], colorText: Colors.green);

        // Navigate after successful OTP verification
        Get.to(() {
          _loadUserData();  // Load data before navigation
          return SignUpView();
        });
      }
      else {
        print("❌ Failed to verify OTP: ${response.body}");
        Get.snackbar("Error", "❌ Invalid OTP", colorText: Colors.red);
      }
    } catch (e) {
      print("❌ Exception: $e");
      Get.snackbar("Error", "❌ Something went wrong", colorText: Colors.red);
    }
  }

  // Resend OTP
  Future<void> resendOtp() async {

    final headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode({"phone": mobileNumber});
    final url = Uri.parse('https://jdapi.youthadda.co/user/sendotp');

    try {
      final request = http.Request('POST', url);
      request.body = body;
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("OTP resent successfully: $responseBody");
        Get.snackbar("Success", "OTP resent successfully to +91 $mobileNumber");
      } else {
        print("Failed to resend OTP: ${response.reasonPhrase}");
        Get.snackbar("", "please fill the Correct OTP");
      }
    } catch (e) {
      print("Exception: $e");

    }
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}