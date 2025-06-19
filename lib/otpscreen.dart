import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worknest/app/modules/signUp/views/sign_up_view.dart';

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
  void initState() {
    super.initState();
    _loadUserData();  // ✅ use initState instead of onInit
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // reload() is not required here for Flutter shared_preferences
    String? userId2 = prefs.getString('userId');
    String? token = prefs.getString('token');
    String? email = prefs.getString('email');

    // Use the loaded data as needed
    print("🔑 Loaded userId: $userId2");
    print("🔑 Loaded token: $token");
    print("🔑 Loaded email: $email");
  }

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
                    'Please enter the 6-digit code sent',
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
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: OtpController,
                        autoDisposeControllers: false,
                        keyboardType: TextInputType.number,
                        enableActiveFill: true,
                        cursorColor: Colors.black,
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
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                          verificationId: widget.verificationid,
                          smsCode: OtpController.text.trim(),
                        );
                        final userCredential = await FirebaseAuth.instance
                            .signInWithCredential(credential);

                        String? idToken = await userCredential.user?.getIdToken();
                        print('Firebase ID Token: $idToken');
                        // ✅ FCM Token (for push notifications)
                        final String? fcmToken =
                        await FirebaseMessaging.instance.getToken();
                        print('FCM Token: $fcmToken');
                        if (idToken != null) {
                          final response = await http.post(
                            Uri.parse(
                                'https://jdapi.youthadda.co/user/verifyotp'),
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({'token': idToken, 'fcmToken': fcmToken,}),
                          );

                          final responseData = jsonDecode(response.body);
                          print("Server Response: $responseData");

                          if (response.statusCode == 200) {
                            final userId = responseData['id'].toString();
                            print("UserID from backend: $userId");

                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            await prefs.setString('userId', userId);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpView()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Verification failed: ${responseData['msg'] ?? 'Server error'}",
                                ),
                              ),
                            );
                          }
                        }
                      } catch (ex) {
                        print(ex.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Invalid OTP"),
                          ),
                        );
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
