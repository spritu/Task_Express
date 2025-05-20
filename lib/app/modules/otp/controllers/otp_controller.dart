import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../bottom/views/bottom_view.dart';
import '../../home/views/home_view.dart';
import '../../signUp/views/sign_up_view.dart';

class OtpController extends GetxController {
  TextEditingController otpController = TextEditingController();
  String? mobileNumber;
  var userId = ''.obs;
  var token = ''.obs;
  var email = ''.obs;
  List<TextEditingController> otpControllers =
  List.generate(4, (index) => TextEditingController());
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final cityController = TextEditingController();
  final pinCodeController = TextEditingController();
  final stateController = TextEditingController();
  final referralCodeController = TextEditingController();

  final genderValue = ''.obs;
  final profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadMobileNumber();
    _loadUserData();
  }
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    String? userId2 = prefs.getString('userId');
    String? token = prefs.getString('token');
    String? email = prefs.getString('email');

    // Use the loaded data as needed
    print("🔑 Loaded userId: $userId2");
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
    //  Get.snackbar("Error", "Please enter a valid 4-digit OTP", colorText: Colors.red);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobileNumber = prefs.getString('mobileNumber');

    if (mobileNumber == null || mobileNumber.isEmpty) {
     // Get.snackbar("Error", "Mobile number not found. Please try again.", colorText: Colors.red);
      return;
    }

    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({"phone": mobileNumber, "otp": otp});
    final url = Uri.parse('https://jdapi.youthadda.co/user/verifyotp');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("✅ OTP Verified. Full Response:\n${jsonEncode(responseData)}");


        final userId2 = responseData['id'] ?? '';
               await prefs.setString('userId', userId2.toString()); // ✅ Save it properly
        final token = responseData['token'];
        final userId = responseData['id'];
        final userType = responseData['userType'] ?? 0;
        final userData = responseData['userData'];

        otpController.clear();

        if (token != null && token.isNotEmpty) {
          // Save basic data
          await prefs.setString('token', token);
          await prefs.setString('userId', userId);
          await prefs.setInt('userType', userType);
          await prefs.setString('mobile', userData?['phone'] ?? '');

          final email = userData?['email'] ?? '';
          final firstName = userData?['firstName'] ?? '';

          if (email.isNotEmpty && firstName.isNotEmpty) {
            await prefs.setString('email', email);
            await prefs.setString('firstName', firstName);
            await prefs.setString('lastName', userData?['lastName'] ?? '');

            // ✅ Mark as logged in
            final box = GetStorage();
            box.write('isLoggedIn', true);

          //  Get.snackbar("✅ Success", responseData['msg'], colorText: Colors.green);
            Get.offAllNamed('/bottom'); // Navigate to home screen
          } else {
          //  Get.snackbar("Complete Signup", "Please complete your profile", colorText: Colors.orange);
            Get.offAll(() => SignUpView());
          }
        } else {
        //  Get.snackbar("Error", "Token not received. Please complete your registration.", colorText: Colors.orange);
          Get.offAll(() => SignUpView());
        }
      } else {
        print("❌ OTP Verification Failed: ${response.body}");
      //  Get.snackbar("Error", "❌ Invalid OTP", colorText: Colors.red);
      }
    } catch (e) {
      print("❌ Exception: $e");
     // Get.snackbar("Error", "❌ Something went wrong", colorText: Colors.red);
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
      //  Get.snackbar("Success", "OTP resent successfully to +91 $mobileNumber");
      } else {
        print("Failed to resend OTP: ${response.reasonPhrase}");
     //   Get.snackbar("", "please fill the Correct OTP");
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