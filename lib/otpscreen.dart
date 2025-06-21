import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
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
    String? mobileNumber = prefs.getString('mobileNumber');
    // Use the loaded data as needed
    print("🔑 Loaded userId: $userId2");
    print("🔑 Loaded token: $token");
    print("🔑 Loaded email: $email");
    print("🔑 Loaded mobileNumber: $mobileNumber");
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
                      // onPressed: () async {
                      //   try {
                      //     final enteredOtp = OtpController.text.trim();
                      //     print('📌 Entered OTP: $enteredOtp'); // ✅ Your debugging log
                      //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      //       verificationId: widget.verificationid,
                      //       smsCode: OtpController.text.trim(),
                      //     );
                      //
                      //     final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                      //
                      //     String? idToken = await userCredential.user?.getIdToken();
                      //     print('Firebase ID Token: $idToken');
                      //
                      //     final String? fcmToken = await FirebaseMessaging.instance.getToken();
                      //     print('FCM Token: $fcmToken');
                      //
                      //     if (idToken != null) {
                      //       final response = await http.post(
                      //         Uri.parse('https://jdapi.youthadda.co/user/verifyotp'),
                      //         headers: {'Content-Type': 'application/json'},
                      //         body: jsonEncode({
                      //           'token': idToken,
                      //           'fcmToken': fcmToken,
                      //         }),
                      //       );
                      //
                      //       final responseData = jsonDecode(response.body);
                      //       print("Server Response: $responseData");
                      //
                      //       if (response.statusCode == 200) {
                      //         // ✅ Get full user data
                      //         final userId = responseData['id'].toString();
                      //         final userData = responseData['data'] ?? {};
                      //
                      //         SharedPreferences prefs = await SharedPreferences.getInstance();
                      //
                      //         // ✅ Save IDs
                      //         await prefs.setString('userId2', userId);
                      //         if (idToken != null) {
                      //           await prefs.setString('firebaseIdToken', idToken);
                      //           print("✅ Firebase ID Token saved");
                      //         }
                      //         if (fcmToken != null) {
                      //           await prefs.setString('fcmToken', fcmToken);
                      //           print("✅ FCM Token saved");
                      //         }
                      //
                      //         // ✅ Save user fields from data map
                      //         await prefs.setString('userId', userData['_id'] ?? '');
                      //         await prefs.setString('email', userData?['email'] ?? '');
                      //         await prefs.setString('firstName', userData?['firstName'] ?? '');
                      //         await prefs.setString('lastName', userData?['lastName'] ?? '');
                      //         await prefs.setString('dob', userData?['dateOfBirth'] ?? '');
                      //
                      //         await prefs.setString('gender', userData?['gender'] ?? '');
                      //         await prefs.setString('mobile', userData?['phone'] ?? '');
                      //         await prefs.setString('city', userData?['city'] ?? '');
                      //         await prefs.setString('state', userData?['state'] ?? '');
                      //         await prefs.setString('referralCode', userData?['referralCode']?.toString() ?? '');
                      //         await prefs.setString('pinCode', userData?['pinCode']?.toString() ?? '');
                      //
                      //         // ✅ Build full image URL
                      //         final rawImg = userData['userImg'] ?? '';
                      //         String finalImage = '';
                      //         if (rawImg.toString().isNotEmpty) {
                      //           finalImage = rawImg.toString().startsWith('http')
                      //               ? rawImg
                      //               : 'https://jdapi.youthadda.co/$rawImg';
                      //         }
                      //         await prefs.setString('userImg', finalImage);
                      //
                      //         print("✅ ALL USER DATA SAVED SUCCESSFULLY!");
                      //
                      //         // ✅ Move to SignUpView
                      //         Get.to(SignUpView());
                      //       } else {
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           SnackBar(
                      //             content: Text("Verification failed: ${responseData['msg'] ?? 'Server error'}"),
                      //           ),
                      //         );
                      //       }
                      //     }
                      //   } catch (ex) {
                      //     print(ex.toString());
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text("Invalid OTP")),
                      //     );
                      //   }
                      // },
                    onPressed: () async {
                      try {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String? mobileNumber = prefs.getString('mobileNumber');
                        if (mobileNumber == null || mobileNumber.isEmpty) return;

                        final enteredOtp = OtpController.text.trim();
                        print('📌 Entered OTP: $enteredOtp');

                        if (enteredOtp.isEmpty || enteredOtp.length != 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter a valid 6-digit OTP")),
                          );
                          return;
                        }

                        // ✅ 1️⃣ VERIFY WITH FIREBASE
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: widget.verificationid,
                          smsCode: enteredOtp,
                        );

                        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

                        String? idToken = await userCredential.user?.getIdToken();
                        print('✅ Firebase ID Token: $idToken');

                        final String? fcmToken = await FirebaseMessaging.instance.getToken();
                        print('✅ FCM Token: $fcmToken');

                        if (idToken == null) {
                          throw Exception("Firebase ID Token is null");
                        }

                        // ✅ 2️⃣ VERIFY ON BACKEND
                        final response = await http.post(
                          Uri.parse('https://jdapi.youthadda.co/user/verifyotp'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({
                            'token': idToken,
                            'fcmToken': fcmToken,
                            'phone': mobileNumber,
                            'otp': enteredOtp,
                          }),
                        );

                        final responseData = jsonDecode(response.body);
                        print("🌐 Server Response: $responseData");

                        if (response.statusCode == 200) {
                          final userId = responseData['id'].toString();
                          final userData = responseData['userData'] ?? {};
                          final userType = responseData['userType'] ?? 0;
                          final rawImg = userData['userImg'] ?? '';

                          // ✅ Save ID & tokens
                          await prefs.setString('userId2', userId);
                          await prefs.setString('firebaseIdToken', idToken);
                          if (fcmToken != null) {
                            await prefs.setString('fcmToken', fcmToken);
                          }
                          await prefs.setInt('userType', userType);
                          final userImg = userData?['userImg'] ?? '';

                          // Set full image path
                          String finalImage = '';
                          if (userImg.isNotEmpty) {
                            finalImage = userImg.startsWith('http') ? userImg : 'https://jdapi.youthadda.co/$userImg';
                          }
                          // ✅ Save basic profile info
                          await prefs.setString('email', userData['email'] ?? '');
                          await prefs.setString('firstName', userData['firstName'] ?? '');
                          await prefs.setString('lastName', userData['lastName'] ?? '');
                          await prefs.setString('dob', userData['dateOfBirth'] ?? '');
                          await prefs.setString('gender', userData['gender'] ?? '');
                          await prefs.setString('mobile', userData['phone'] ?? '');
                          await prefs.setString('city', userData['city'] ?? '');
                          await prefs.setString('state', userData['state'] ?? '');
                          await prefs.setString('referralCode', userData['referralCode']?.toString() ?? '');
                          await prefs.setString('pinCode', userData['pinCode']?.toString() ?? '');

                          // ✅ Save image if exists

                          await prefs.setString('userImg', finalImage);

                          // ✅ If service provider, save skills too
                          if (userType == 2) {
                            final skills = userData['skills'];
                            if (skills != null && skills.isNotEmpty) {
                              final skill = skills[0];
                              final categoryName = skill['categoryId']?['name'] ?? '';
                              final subCategoryName = skill['sucategoryId']?['name'] ?? '';
                              final charge = skill['charge']?.toString() ?? '';
                              final spType = skill['categoryId']?['spType']?.toString() ?? '';

                              await prefs.setString('category', categoryName);
                              await prefs.setString('subCategory', subCategoryName);
                              await prefs.setString('charge', charge);
                              await prefs.setString('spType', spType);

                              print("✅ Skills saved: $categoryName → $subCategoryName | ₹$charge");
                            } else {
                              print("ℹ️ No skills found for this service provider.");
                            }
                          }

                          // ✅ Clear OTP field
                          OtpController.clear();

                          // ✅ Navigate: if profile complete → bottom, else signup

                          // ✅ Save backend token too:
                          final token = responseData['token'] ?? '';
                          await prefs.setString('token', token);

// ✅ Clear OTP field
                          OtpController.clear();

// ✅ Robust: if token exists → trust backend → go to bottom
                          final box = GetStorage();
                          if (token.isNotEmpty && response.statusCode == 200) {
                            box.write('isLoggedIn', true);
                            print("✅ Server token present → navigating to BottomView");
                            Get.offAllNamed('/bottom');
                          } else {
                            box.write('isLoggedIn', false);
                            print("⚠️ No token → navigating to SignUpView");
                            Get.offAll(() => SignUpView());
                          }

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Verification failed: ${responseData['msg'] ?? 'Server error'}"),
                            ),
                          );
                        }

                      } catch (ex) {
                        print("❌ Exception: $ex");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Invalid OTP or verification failed")),
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
