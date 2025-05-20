import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
    prefs.reload();

    mobileNumber = prefs.getString('mobileNumber');
    String? userId = prefs.getString('userId');
    print("🔑 Loaded userId: $userId");
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


  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty || otp.length != 4) {
      Get.snackbar("Error", "Please enter a valid 4-digit OTP", colorText: Colors.red);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobileNumber = prefs.getString('mobileNumber');

    if (mobileNumber == null || mobileNumber.isEmpty) {
      Get.snackbar("Error", "Mobile number not found. Please try again.", colorText: Colors.red);
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
        final userId = responseData['id'] ?? '';
        await prefs.setString('userId', userId.toString()); // ✅ Save it properly

        final token = responseData['token'] ?? '';
        final userType = responseData['userType'] ?? 0;
        final userData = responseData['userData'] ?? {};

        // Extract individual user fields safely
        final firstName = userData['firstName']?.toString() ?? '';
        final lastName = userData['lastName']?.toString() ?? '';
        final email = userData['email']?.toString() ?? '';
        final phone = userData['phone']?.toString() ?? '';

        otpTextController.clear();
        final skills = userData['skills'];
        if (skills != null && skills.isNotEmpty) {
          final skill = skills[0]; // assuming single skill for now
          await prefs.setString('profession', skill['professionName'] ?? '');
          await prefs.setString('category', skill['categoryName'] ?? '');
          await prefs.setString('subCategory', skill['subCategoryName'] ?? '');
          await prefs.setString('charge', skill['charge']?.toString() ?? '');
        }
        final profileImage = userData['userImg'] ?? '';
        await prefs.setString('profileImage', profileImage);
        if (token.isNotEmpty) {
          // ✅ Save all details in SharedPreferences
          await prefs.setString('userId', userId);

          await prefs.setString('token', token);
          await prefs.setInt('userType', userType);
          await prefs.setString('firstName', firstName);
          await prefs.setString('lastName', lastName);
          await prefs.setString('email', email);
          await prefs.setString('mobile', phone);
          print("✅ Saved userId: $userId");

          // ✅ Mark as logged in
          final box = GetStorage();
          box.write('isLoggedIn2', true);

          print("📦 Saved User Data:");
          print("👤 First Name: $firstName");
          print("👤 Last Name: $lastName");
          print("📧 Email: $email");
          print("📱 Phone: $phone");

          if (firstName.isNotEmpty && email.isNotEmpty) {
            Get.snackbar("✅ Success", responseData['msg'], colorText: Colors.green);
            Get.offAllNamed('/bottom2'); // Navigate to home screen
          } else {
            Get.snackbar("Complete Signup", "Please complete your profile", colorText: Colors.orange);
            Get.offAll(() => ProviderProfileView());
          }
        } else {
       //   Get.snackbar("Error", "Token not received. Please complete your registration.", colorText: Colors.orange);
          Get.offAll(() => ProviderProfileView());
        }
      } else {
        print("❌ OTP Verification Failed: ${response.body}");
       // Get.snackbar("Error", "❌ Invalid OTP", colorText: Colors.red);
      }
    } catch (e) {
      print("❌ Exception: $e");
    //  Get.snackbar("Error", "❌ Something went wrong", colorText: Colors.red);
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