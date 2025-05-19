import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../colors.dart';
import '../../provider_location/views/provider_location_view.dart';
import '../../provider_profile/views/provider_profile_view.dart';
import '../controllers/provider_otp_controller.dart';

class ProviderOtpView extends GetView<ProviderOtpController> {
  const ProviderOtpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration( gradient: AppColors.appGradient2 ),
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
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      controller: controller.otpTextController,
                      autoDisposeControllers: false,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
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
                        // Track changes (if necessary)
                      },
                      onCompleted: (otp) {
                        controller.verifyOtp(otp); // Call verifyOtp when OTP is completed
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: controller.resendOtp,
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
                  onPressed: () {
                    // Get.to(() => ProviderProfileView());
                    controller.verifyOtp("otp"); // This should handle actual verification and navigation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orage,
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