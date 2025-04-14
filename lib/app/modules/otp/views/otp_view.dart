import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/colors.dart';
import '../../signUp/views/sign_up_view.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Container(
          decoration: BoxDecoration( gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87AAF6),
              Colors.white,
            ],
          ),),
          child: SafeArea(
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
                      fontFamily: 'Poppins',color: AppColors.textColor
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please enter the 4-digit code sent on\n+91 ${controller.mobileNumber}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,fontWeight: FontWeight.w400,
                      color: Colors.black54,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 50,
                        height: 50,
                        child: TextField(
                          controller: controller.otpControllers[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) {
                            controller.moveToNext(index, value);
                          },
                          onSubmitted: (_) {
                            // Optional: move focus on done
                            if (index < 3) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          onTap: () {
                            // Optional: clear text when tapped
                            controller.otpControllers[index].selection = TextSelection.collapsed(offset: controller.otpControllers[index].text.length);
                          },
                        ),

                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: controller.resendCode,
                    child: const Text(
                      'Resend',
                      style: TextStyle(
                        color: Color(0xFF114BCA),fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: (){Get.to(SignUpView());},
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
      );
  }
}
