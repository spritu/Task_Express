import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:worknest/colors.dart';
import '../../signUp/views/sign_up_view.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OtpController());
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [Color(0xFF87AAF6), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Verification code',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => Text(
                      'Please enter the 4-digit code sent on\n+91 ${controller.mobileNumber.value}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        controller: controller.otpController,
                        autoDisposeControllers: false,
                        keyboardType: TextInputType.number,
                        enableActiveFill: true, // enables box background color
                        cursorColor:
                            Colors
                                .black, // ✅ sets the cursor (blinking line) color
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(8),
                          fieldHeight: 38,
                          fieldWidth: 38,
                          activeFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          activeColor: Colors.grey,
                          selectedColor: Colors.grey,
                          inactiveColor: Colors.grey,
                        ),
                        onChanged: (value) {
                          // handle change
                        },
                        onCompleted: (otp) {
                          controller.verifyOtp(otp);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // TextButton(
                  //   onPressed: controller.sendOtp,
                  //   child: const Text(
                  //     'Resend',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       fontFamily: 'Poppins',
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: 12,
                  //       height: 1.0, // 100% line-height
                  //       letterSpacing: 0.72, // 6% of 12px = 0.72
                  //       color: Color(0xFF114BCA),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.5),
                  ElevatedButton(
                    onPressed: () {
                      // String enteredOtp = controller.otpController.text.trim();

                      // if (enteredOtp.isEmpty) {
                      //   Get.snackbar(
                      //     'Empty Field',
                      //     'Please enter the 4-digit OTP code',
                      //     backgroundColor: Colors.redAccent,
                      //     colorText: Colors.white,
                      //     snackPosition: SnackPosition.BOTTOM,
                      //   );
                      //   return;
                      // }
                      //
                      // if (enteredOtp.length != 4) {
                      //   Get.snackbar(
                      //     'Invalid OTP',
                      //     'OTP must be exactly 4 digits',
                      //     backgroundColor: Colors.redAccent,
                      //     colorText: Colors.white,
                      //     snackPosition: SnackPosition.BOTTOM,E
                      //   );
                      //   return;
                      // }
                      // Get.to(() => SignUpView());
                      //  String otp = controller.otpController.text.trim();
                      controller.verifyOtp(
                        "otp",
                      ); // No need to pass mobileNumber // This should handle actual verification and navigation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF114BCA),
                      minimumSize: const Size(250, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 8,
                    ),
                    child: const Text(
                      'Proceed',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
