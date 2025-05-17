import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Bottom2/views/bottom2_view.dart';
import '../../provider_profile/views/provider_profile_view.dart';
class ProviderOtpController extends GetxController {
  //TODO: Implement ProviderOtpController

  String? mobileNumber;
  TextEditingController otpTextController = TextEditingController();

  List<TextEditingController> otpControllers =
  List.generate(4, (index) => TextEditingController());

  @override
  void onInit() {
    super.onInit();
    loadMobileNumber();
  }
  Future<void> loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    mobileNumber = prefs.getString('mobileNumber');

  }




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
  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty || otp.length != 4) {
      Get.snackbar("Error", "Please enter a valid 4-digit OTP");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobileNumber = prefs.getString('mobileNumber');

    if (mobileNumber == null || mobileNumber.isEmpty) {
      Get.snackbar("Error", "Mobile number not found. Please try again.");
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

        final userId = responseData['id']?.toString() ?? '';
        final token = responseData['token'] ?? '';
        final userType = responseData['userType'] ?? 0;

        await prefs.setString('userId', userId);
        await prefs.setString('token', token);
        await prefs.setInt('userType', userType);

        final userData = responseData['userData'];
        bool isProfileComplete = false;

        if (userData != null && userData is Map<String, dynamic>) {
          final name = userData['name']?.toString().trim() ?? '';
          final email = userData['email']?.toString().trim() ?? '';
          final dob = userData['dob']?.toString().trim() ?? '';

          print("👤 Name: $name, Email: $email, DOB: $dob");

          // Save to SharedPreferences
          await prefs.setString('name', name);
          await prefs.setString('email', email);
          await prefs.setString('dob', dob);
          await prefs.setString('gender', userData['gender']?.toString() ?? '');
          await prefs.setString('city', userData['city']?.toString() ?? '');
          await prefs.setString('state', userData['state']?.toString() ?? '');
          await prefs.setString('pincode', userData['pincode']?.toString() ?? '');
          await prefs.setString('profileImage', userData['profileImage']?.toString() ?? '');

          // Profile check
          isProfileComplete = name.isNotEmpty && email.isNotEmpty && dob.isNotEmpty;
        }

        otpTextController.clear();
        Get.snackbar("✅ Success", responseData['msg'], colorText: Colors.green);

        if (isProfileComplete) {
          Get.offAll(() => Bottom2View());
        } else {
          Get.offAll(() => ProviderProfileView());
        }

      } else {
        print("❌ Failed to verify OTP: ${response.body}");
        Get.snackbar("Error", "❌ Failed to verify OTP", colorText: Colors.red);
      }

    } catch (e) {
      print("❌ Exception: $e");
      Get.snackbar("Error", "❌ Something went wrong", colorText: Colors.red);
    }
  }










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
