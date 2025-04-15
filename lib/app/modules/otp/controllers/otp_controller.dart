import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OtpController extends GetxController {
  String mobileNumber = '';
  TextEditingController otpTextController = TextEditingController();

  List<TextEditingController> otpControllers =
  List.generate(4, (index) => TextEditingController());

  @override
  void onInit() {
    super.onInit();
    _loadMobileNumber();
  }

  Future<void> _loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString('mobileNumber') ?? '';
    update();
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

  // Verify OTP
  // Verify OTP
  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty || otp.length != 4) {
      Get.snackbar("Error", "Please enter a valid 4-digit OTP");
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
      final request = http.Request('POST', url);
      request.body = body;
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("OTP verified successfully: $responseBody");
        Get.snackbar("Success", "OTP verified successfully");
        // You may navigate to the next screen or perform any other actions
        // Example: Get.to(NextScreen());
      } else {
        print("Failed to verify OTP: ${response.reasonPhrase}");
        Get.snackbar("Error", "Failed to verify OTP: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }


  // Resend OTP
  Future<void> resendOtp() async {
    if (mobileNumber.isEmpty) {
      Get.snackbar("Error", "No mobile number available for resend");
      return;
    }

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
        Get.snackbar("Error", "Failed to resend OTP: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar("Error", "Something went wrong: $e");
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
