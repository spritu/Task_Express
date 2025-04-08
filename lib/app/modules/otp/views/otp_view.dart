import 'package:flutter/material.dart';

import 'package:get/get.dart';


import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
      body: SafeArea(
        child: Text("data")
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       'Verification code',
        //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        //     ),
        //     SizedBox(height: 8),
        //     Text(
        //       'Please enter the 4-digit code sent on\n+91 976397883',
        //       textAlign: TextAlign.center,
        //       style: TextStyle(fontSize: 14, color: Colors.grey),
        //     ),
        //     SizedBox(height: 30),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 60),
        //       child: PinCodeTextField(
        //         appContext: context,
        //         length: 4,
        //         keyboardType: TextInputType.number,
        //         controller: controller.otpController,
        //         onChanged: (value) {},
        //         onCompleted: (value) {
        //           // Call your verify function here
        //           print("OTP Entered: $value");
        //         },
        //         pinTheme: PinTheme(
        //           shape: PinCodeFieldShape.box,
        //           borderRadius: BorderRadius.circular(8),
        //           fieldHeight: 50,
        //           fieldWidth: 50,
        //           inactiveColor: Colors.grey,
        //           activeColor: Colors.black,
        //           selectedColor: Colors.blue,
        //         ),
        //       ),
        //     ),
        //     SizedBox(height: 20),
        //     TextButton(
        //       onPressed: () {
        //         // Add resend logic
        //       },
        //       child: Text(
        //         'Resend',
        //         style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }
}
