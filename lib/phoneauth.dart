import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OTPscreen.dart';
import 'auth_controller.dart';
import 'colors.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [Color(0xFF87AAF6), Colors.white],
            ),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              //  crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                InkWell(
                  onTap: () async {
                    // final authController = Get.find<AuthController>();
                    // // Update GetStorage and observable state
                    // authController.box.write('isLoggedIn', false);
                    // authController.isLoggedIn.value = false;
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // await prefs.clear();
                    // // Navigate to BottomView
                    // Get.to(() => BottomView());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Skip for now",
                        textAlign: TextAlign.center, // text-align: center;
                        style: TextStyle(
                          fontSize: 12,
                          // font-size: 12px;
                          fontFamily: "Poppins",
                          // font-family: Poppins;
                          fontWeight: FontWeight.w500,
                          // font-weight: 500;
                          height: 20 / 12,
                          // line-height: 20px -> height = lineHeight / fontSize
                          letterSpacing: 1.2,
                          // letter-spacing: 10% of font-size (12 * 0.10 = 1.2)
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Task',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xff114BCA),
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          height: 0.476,
                          // equivalent to 20px line-height
                          letterSpacing: 2.1, // 5% of 42
                        ),
                      ),
                      TextSpan(
                        text: 'Express',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xffF67C0A),
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          height: 0.476,
                          letterSpacing: 2.1,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 14),
                Text(
                  'Find Trusted Service Providers\n Instantly!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    // font-family: Poppins
                    fontWeight: FontWeight.w600,
                    // font-weight: 600
                    fontSize: 14,
                    // font-size: 14px
                    height: 26 / 14,
                    // line-height: 26px → height factor
                    letterSpacing: 1.54,
                    // 11% of 14px → 14 * 0.11 = 1.54
                    color: Color(0xff2D2D2D), // color
                  ),
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/beg.png", height: 19, width: 20),
                    SizedBox(width: 5),
                    Text(
                      'Find work',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff746E6E),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(height: 16, width: 1, color: Color(0xff746E6E)),
                    SizedBox(width: 10),
                    Image.asset(
                      "assets/images/hired.png",
                      height: 19,
                      width: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Get Hired',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff746E6E),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(height: 16, width: 1, color: Color(0xff746E6E)),
                    SizedBox(width: 10),
                    Image.asset(
                      "assets/images/grow.png",
                      height: 19,
                      width: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Grow',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff746E6E),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Text(
                        "+91",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  // onTap: () async {
                  //   final phone = "+91${phoneController.text.trim()}";
                  //
                  //   await FirebaseAuth.instance.verifyPhoneNumber(
                  //     phoneNumber: phone,
                  //     verificationCompleted: (
                  //       PhoneAuthCredential credential,
                  //     ) async {
                  //       // Optional: handle auto verification
                  //       await FirebaseAuth.instance.signInWithCredential(
                  //         credential,
                  //       );
                  //     },
                  //     verificationFailed: (FirebaseAuthException ex) {
                  //       print("Verification failed: ${ex.message}");
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         SnackBar(
                  //           content: Text("Verification failed: ${ex.message}"),
                  //         ),
                  //       );
                  //     },
                  //     codeSent: (String verificationId, int? resendToken) {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder:
                  //               (context) =>
                  //                   OTPScreen(verificationid: verificationId),
                  //         ),
                  //       );
                  //     },
                  //     codeAutoRetrievalTimeout: (String verificationId) {},
                  //   );
                  // },
                  onTap: () async {
                    final phone = "+91${phoneController.text.trim()}";

                    if (phoneController.text.trim().isEmpty || phoneController.text.trim().length != 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter a valid 10-digit mobile number"),
                        ),
                      );
                      return;
                    }

                    // ✅ Save to SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('mobileNumber', phoneController.text.trim()); // save only digits
                    await prefs.setString('mobileNumber', phone); // optional: save with +91 too

                    print('✅ Phone number saved to SharedPreferences: ${phoneController.text.trim()}');
                    final authController = Get.find<AuthController>();
                    authController.isLoggedIn.value = true;

                    phoneController.clear();
                    // ✅ Show OTP in snackbar

                    // ✅ Continue with Firebase
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: phone,
                      verificationCompleted: (PhoneAuthCredential credential) async {
                        // Optional: handle auto verification
                        await FirebaseAuth.instance.signInWithCredential(credential);
                      },
                      verificationFailed: (FirebaseAuthException ex) {
                        print("Verification failed: ${ex.message}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Verification failed: ${ex.message}"),
                          ),
                        );
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPScreen(verificationid: verificationId),
                          ),
                        );
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  },

                  child: Card(
                    child: Container(
                      height: 64,
                      width: 262,
                      decoration: BoxDecoration(
                        color: const Color(0xff235CD7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Get Verification Code",
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                    children: [
                      const TextSpan(text: 'By continuing, you agree to our'),
                      TextSpan(
                        text: '\nTerms & Conditions',
                        style: const TextStyle(
                          color: Color(0xff235CD7),
                          fontWeight: FontWeight.bold,
                        ),
                        //  recognizer: TapGestureRecognizer()..onTap = controller.openTerms,
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          color: Color(0xff235CD7),
                          fontWeight: FontWeight.bold,
                        ),
                        //  recognizer: TapGestureRecognizer()..onTap = controller.openPrivacy,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
