import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  //TODO: Implement OtpController
  String mobileNumber = '976397883'; // set your number here

  List<TextEditingController> otpControllers =
  List.generate(4, (index) => TextEditingController());

  void moveToNext(int index, String value) {
    if (value.length == 1 && index < otpControllers.length - 1) {
      FocusScope.of(Get.context!).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(Get.context!).previousFocus();
    }
  }


  void resendCode() {
    // Add your resend logic here
    Get.snackbar("OTP", "Code resent successfully");
  }

  void verifyOtp() {
    String otp = otpControllers.map((e) => e.text).join();
    if (otp.length == 4) {
      // Your verification logic here
      Get.snackbar("OTP", "Verifying $otp");
      // Navigate or handle success
    } else {
      Get.snackbar("Error", "Please enter all 4 digits");
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
