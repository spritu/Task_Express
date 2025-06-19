import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:worknest/app/modules/bottom/views/bottom_view.dart';
import 'colors.dart';

class OTPScreen extends StatefulWidget {
  String verificationid;

  OTPScreen({super.key, required this.verificationid});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController OtpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                   Text(
                      'Please enter the 4-digit code sent',
                      // ' on\n+91 ${controller.mobileNumber.value}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: OtpController,
                        autoDisposeControllers: false,
                        keyboardType: TextInputType.number,
                        enableActiveFill: true,
                        // enables box background color
                        cursorColor: Colors.black,
                        // ✅ sets the cursor (blinking line) color
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
                          //controller.verifyOtp(otp);
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
                    onPressed: () async {
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
                      // controller.verifyOtp(
                      //   "otp",
                      // ); // No need to pass mobileNumber // This should handle actual verification and navigation
                      try {
                        PhoneAuthCredential credential =
                            await PhoneAuthProvider.credential(
                              verificationId: widget.verificationid,
                              smsCode: OtpController.text.toString(),
                            );
                        FirebaseAuth.instance
                            .signInWithCredential(credential)
                            .then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BottomView(),
                                ),
                              );
                            });
                      } catch (ex) {
                        log(ex.toString() as num);
                      }
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
