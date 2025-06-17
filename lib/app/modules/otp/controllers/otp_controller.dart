import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../auth_controller.dart';
import '../../signUp/views/sign_up_view.dart';

class OtpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController otpController = TextEditingController();
  final RxString mobileNumber = ''.obs;
  final phoneController = TextEditingController();

  var userId = ''.obs;
  var token = ''.obs;
  var email = ''.obs;
  List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final cityController = TextEditingController();
  final pinCodeController = TextEditingController();
  final stateController = TextEditingController();
  final referralCodeController = TextEditingController();
  final genderValue = ''.obs;
  final profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadMobileNumber();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    String? userId2 = prefs.getString('userId');
    String? token = prefs.getString('token');
    String? email = prefs.getString('email');

    // Use the loaded data as needed
    print("🔑 Loaded userId: $userId2");
    print("🔑 Loaded token: $token");
    print("🔑 Loaded email: $email");

    // You can also update the UI or variables as needed here
  }

  Future<void> loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final number = prefs.getString('mobileNumber') ?? '';
    mobileNumber.value = number;
    print("📱 Loaded mobile number: $number");
  }

  // Move focus on pin code fields
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

  var imagePath = ''.obs;

  String _verificationId = "";

  RxBool isOtpSent = false.obs;
  RxBool isLoading = false.obs;

  Future<void> sendOtp(String phoneNumber) async {
    isLoading.value = true;
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        isLoading.value = false;
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar("Error", e.message ?? "Verification failed");
        isLoading.value = false;
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        isOtpSent.value = true;
        isLoading.value = false;
        Get.snackbar("OTP Sent", "Please check your phone.");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> verifyOtp(String smsCode) async {
    isLoading.value = true;
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    try {
      UserCredential result = await _auth.signInWithCredential(credential);
      String? idToken = await result.user?.getIdToken();
      print("Firebase Token: $idToken");

      // TODO: Send this token to Express backend for verification

      Get.snackbar("Success", "Logged in successfully!");
    } catch (e) {
      Get.snackbar("Invalid OTP", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> verifyOtp(String otp) async {
  //   if (otp.isEmpty || otp.length != 4) return;
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? mobileNumber = prefs.getString('mobileNumber');
  //   if (mobileNumber == null || mobileNumber.isEmpty) return;
  //
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = json.encode({"phone": mobileNumber, "otp": otp});
  //   final url = Uri.parse('https://jdapi.youthadda.co/user/verifyotp');
  //
  //   try {
  //     final response = await http.post(url, headers: headers, body: body);
  //
  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       print("✅ OTP Verified. Full Response:\n${jsonEncode(responseData)}");
  //
  //       final userData = responseData['userData'];
  //       final token = responseData['token'] ?? '';
  //       final userId = responseData['id'].toString();
  //       final userType = responseData['userType'] ?? 0;
  //       final userImg = userData?['userImg'] ?? '';
  //
  //       // Set full image path
  //       String finalImage = '';
  //       if (userImg.isNotEmpty) {
  //         finalImage = userImg.startsWith('http') ? userImg : 'https://jdapi.youthadda.co/$userImg';
  //       }
  //
  //       // Save basic info
  //       await prefs.setString('token', token);
  //       await prefs.setString('userId', userId);
  //       await prefs.setInt('userType', userType);
  //       await prefs.setString('image', finalImage);
  //       await prefs.setString('userImg', userImg);
  //
  //       // Save profile info
  //       await prefs.setString('email', userData?['email'] ?? '');
  //       await prefs.setString('firstName', userData?['firstName'] ?? '');
  //       await prefs.setString('lastName', userData?['lastName'] ?? '');
  //       await prefs.setString('dob', userData?['dateOfBirth'] ?? '');
  //
  //       await prefs.setString('gender', userData?['gender'] ?? '');
  //       await prefs.setString('mobile', userData?['phone'] ?? '');
  //       await prefs.setString('city', userData?['city'] ?? '');
  //       await prefs.setString('state', userData?['state'] ?? '');
  //       await prefs.setString('referralCode', userData?['referralCode']?.toString() ?? '');
  //       await prefs.setString('pinCode', userData?['pinCode']?.toString() ?? '');
  //       // Save skills ONLY if userType == 2 (Service Provider)
  //       if (userType == 2) {
  //         final skills = userData['skills'];
  //         if (skills != null && skills.isNotEmpty) {
  //           final skill = skills[0];
  //           final categoryName = skill['categoryId']?['name'] ?? '';
  //           final subCategoryName = skill['sucategoryId']?['name'] ?? '';
  //           final charge = skill['charge']?.toString() ?? '';
  //           final spType = skill['categoryId']?['spType']?.toString() ?? '';
  //
  //           await prefs.setString('category', categoryName);
  //           await prefs.setString('subCategory', subCategoryName);
  //           await prefs.setString('charge', charge);
  //           await prefs.setString('spType', spType);
  //
  //           print("✅ Skills saved: $categoryName → $subCategoryName | ₹$charge");
  //         } else {
  //           print("ℹ️ No skills found for this service provider.");
  //         }
  //       }
  //
  //       // Navigate
  //       otpController.clear();
  //       final box = GetStorage();
  //
  //       final isProfileComplete = (userData?['email'] ?? '').isNotEmpty &&
  //           (userData?['firstName'] ?? '').isNotEmpty;
  //
  //       if (isProfileComplete) {
  //         box.write('isLoggedIn', true);
  //         Get.offAllNamed('/bottom');
  //       } else {
  //         box.write('isLoggedIn', false);
  //         Get.offAll(() => SignUpView());
  //       }
  //     } else {
  //       print("❌ OTP verification failed: ${response.body}");
  //     }
  //   } catch (e) {
  //     print("❌ Exception during OTP verification: $e");
  //   }
  // }
  //
  //
  // Future<void> resendOtp() async {
  //
  //   final headers = {
  //     'Content-Type': 'application/json',
  //   };
  //   final body = json.encode({"phone": mobileNumber.value});
  //   final url = Uri.parse('https://jdapi.youthadda.co/user/sendotp');
  //
  //   try {
  //     final request = http.Request('POST', url);
  //     request.body = body;
  //     request.headers.addAll(headers);
  //
  //     final response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       final responseBody = await response.stream.bytesToString();
  //       print("OTP resent successfully: $responseBody");
  //       final data = json.decode(responseBody);
  //
  //       final otp = data['otp'] ?? '';
  //       if (otp.isNotEmpty) {
  //         Get.snackbar(
  //           "🔐 OTP Received",
  //           "Your OTP is: $otp",
  //           duration: Duration(seconds: 10),
  //           backgroundColor: Colors.black87,
  //           colorText: Colors.white,
  //           snackPosition: SnackPosition.BOTTOM,
  //         );
  //       }
  //     //  Get.snackbar("Success", "OTP resent successfully to +91 $mobileNumber");
  //     } else {
  //       print("Failed to resend OTP: ${response.reasonPhrase}");
  //    //   Get.snackbar("", "please fill the Correct OTP");
  //     }
  //   } catch (e) {
  //     print("Exception: $e");
  //
  //   }
  // }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
