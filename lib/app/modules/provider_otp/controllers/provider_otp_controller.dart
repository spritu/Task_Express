// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import '../../Bottom2/views/bottom2_view.dart';
// import '../../provider_profile/views/provider_profile_view.dart';
// class ProviderOtpController extends GetxController {
//   //TODO: Implement ProviderOtpController
//   var imagePath = ''.obs;
//   String? mobileNumber;
//   TextEditingController otpTextController = TextEditingController();
//
//   List<TextEditingController> otpControllers =
//   List.generate(4, (index) => TextEditingController());
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadMobileNumber();
//   }
//   Future<void> loadMobileNumber() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.reload();
//
//     mobileNumber = prefs.getString('mobileNumber');
//     String? userId = prefs.getString('userId');
//     print("🔑 Loaded userId: $userId");
//   }
//
//
//
//
//   void moveToNext(int index, String value) {
//     if (value.length == 1) {
//       if (index < otpControllers.length - 1) {
//         FocusScope.of(Get.context!).nextFocus();
//       } else {
//         FocusScope.of(Get.context!).unfocus();
//       }
//     } else if (value.isEmpty && index > 0) {
//       FocusScope.of(Get.context!).previousFocus();
//     }
//   }
//
//
//
//   // Future<void> verifyOtp(String otp) async {
//   //   if (otp.isEmpty || otp.length != 4) return;
//   //
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? mobileNumber = prefs.getString('mobileNumber');
//   //   if (mobileNumber == null || mobileNumber.isEmpty) return;
//   //
//   //   final headers = {'Content-Type': 'application/json'};
//   //   final body = json.encode({"phone": mobileNumber, "otp": otp});
//   //   final url = Uri.parse('https://jdapi.youthadda.co/user/verifyotp');
//   //
//   //   try {
//   //     final response = await http.post(url, headers: headers, body: body);
//   //
//   //     if (response.statusCode == 200) {
//   //       final responseData = json.decode(response.body);
//   //       print("✅ OTP Verified. Full Response:\n${jsonEncode(responseData)}");
//   //
//   //       // Extract userData
//   //       final userData = responseData['userData'];
//   //       final userImg = userData?['userImg']?? ''; // from userData
//   //       final token = responseData['token'] ?? '';
//   //       final userId = responseData['id'].toString();
//   //       final userType = responseData['userType'] ?? 0;
//   //
//   //       // Construct final image URL
//   //       String finalImage = '';
//   //       if (userImg.isNotEmpty) {
//   //         finalImage = userImg.startsWith('http')
//   //             ? userImg
//   //             : 'https://jdapi.youthadda.co/$userImg';
//   //       }
//   //
//   //       print("🖼️ Final User Image URL: $finalImage");
//   //
//   //       // Save to SharedPreferences
//   //       await prefs.setString('token', token);
//   //       await prefs.setString('userId', userId);
//   //       await prefs.setInt('userType', userType);
//   //       await prefs.setString('image', finalImage);
//   //
//   //       // Other user data
//   //       await prefs.setString('email', userData?['email'] ?? '');
//   //       await prefs.setString('firstName', userData?['firstName'] ?? '');
//   //       await prefs.setString('lastName', userData?['lastName'] ?? '');
//   //       await prefs.setString('dob', userData?['dateOfBirth'] ?? '');
//   //       await prefs.setString('gender', userData?['gender'] ?? '');
//   //       await prefs.setString('mobile', userData?['phone'] ?? '');
//   //       await prefs.setString('userImg', userData?['userImg'] ?? '');
//   //
//   //       // Confirm
//   //       print("✅ Image Saved to SharedPreferences: ${prefs.getString('image')}");
//   //
//   //       otpTextController.clear();
//   //
//   //       final box = GetStorage();
//   //       if ((userData?['email'] ?? '').isNotEmpty &&
//   //           (userData?['firstName'] ?? '').isNotEmpty) {
//   //         box.write('isLoggedIn2', true);
//   //         Get.offAllNamed('/bottom2');
//   //       } else {
//   //         box.write('isLoggedIn2', false);
//   //         Get.offAll(() => ProviderProfileView());
//   //       }
//   //     } else {
//   //       print("❌ OTP Verification Failed: ${response.body}");
//   //     }
//   //   } catch (e) {
//   //     print("❌ Exception: $e");
//   //   }
//   // }
//   Future<void> verifyOtp(String otp) async {
//     if (otp.isEmpty || otp.length != 4) {
//       print("❌ Invalid OTP");
//       return;
//     }
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? mobileNumber = prefs.getString('mobileNumber');
//
//     if (mobileNumber == null || mobileNumber.isEmpty) {
//       print("❌ Mobile number not found");
//       return;
//     }
//
//     final headers = {'Content-Type': 'application/json'};
//     final body = json.encode({"phone": mobileNumber, "otp": otp});
//     final url = Uri.parse('https://jdapi.youthadda.co/user/verifyotp');
//
//     try {
//       final response = await http.post(url, headers: headers, body: body);
//
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         print("✅ OTP Verified: ${jsonEncode(responseData)}");
//
//         final token = responseData['token'] ?? '';
//         final userType = responseData['userType'] ?? 0;
//         final userId = responseData['id']?.toString() ?? '';
//
//         final userData = responseData['userData'] ?? {};
//         final firstName = userData['firstName']?.toString() ?? '';
//         final lastName = userData['lastName']?.toString() ?? '';
//         final email = userData['email']?.toString() ?? '';
//         final phone = userData['phone']?.toString() ?? '';
//         final userImg = userData?['userImg']?? ''; // from userData
//         String finalImage = '';
//         if (userImg.isNotEmpty) {
//           finalImage = userImg.startsWith('http')
//               ? userImg
//               : 'https://jdapi.youthadda.co/$userImg';
//         }
//
//         print("🖼️ Final User Image URL: $finalImage");
//
//         otpTextController.clear();
//
//         // Save profession details if available
//         final skills = userData['skills'];
//
//         if (skills != null && skills.isNotEmpty) {
//           final skill = skills[0];
//           final categoryName = skill['categoryId']?['name'] ?? '';
//           final subCategoryName = skill['sucategoryId']?['name'] ?? '';
//           final charge = skill['charge']?.toString() ?? '';
//           final spType = skill['categoryId']?['spType']?.toString() ?? '';
//           print("💡 spType: $spType");
//           await prefs.setString('spType', spType);
//           await prefs.setString('image', finalImage);
//
//           await prefs.setString('category', categoryName);
//           await prefs.setString('subCategory', subCategoryName);
//           await prefs.setString('charge', charge); await prefs.setString('spType', spType);
//         }
//         final dob = userData?['dateOfBirth'] ?? '';
//         final gender = userData?['gender'] ?? '';
//         // Save to SharedPreferences
//        // 👈 Save spType in SharedPreferences
//         await prefs.setString('userId', userId);
//         await prefs.setString('token', token);
//         await prefs.setInt('userType', userType);
//         await prefs.setString('firstName', firstName);
//         await prefs.setString('lastName', lastName);
//         await prefs.setString('email', email);
//         await prefs.setString('mobile', phone);
//         await prefs.setString('userImg', userData?['userImg'] ?? '');
//
//         // Confirm
//         print("✅ Image Saved to SharedPreferences: ${prefs.getString('image')}");
//
//         await prefs.setString('dob', dob);
//         await prefs.setString('gender', gender);
//         final box = GetStorage();
//         box.remove('isLoggedIn');
//         box.write('isLoggedIn2', true);
//
//         print("🔐 Saved userType: $userType");
//
//         // Navigate based on profile completeness
//         if (firstName.isNotEmpty && email.isNotEmpty) {
//           Get.offAllNamed('/bottom2'); // Home
//         } else {
//           Get.offAll(() => ProviderProfileView()); // Complete profile
//         }
//       } else {
//         print("❌ OTP Verification Failed: ${response.body}");
//       }
//     } catch (e) {
//       print("❌ Exception during OTP verification: $e");
//     }
//   }
//
//
//
//   // Resend OTP
//   Future<void> resendOtp() async {
//
//     final headers = {
//       'Content-Type': 'application/json',
//     };
//     final body = json.encode({"phone": mobileNumber});
//     final url = Uri.parse('https://jdapi.youthadda.co/user/sendotp');
//
//     try {
//       final request = http.Request('POST', url);
//       request.body = body;
//       request.headers.addAll(headers);
//
//       final response = await request.send();
//
//       if (response.statusCode == 200) {
//         final responseBody = await response.stream.bytesToString();
//         print("OTP resent successfully: $responseBody");
//        // Get.snackbar("Success", "OTP resent successfully to +91 $mobileNumber");
//       } else {
//         print("Failed to resend OTP: ${response.reasonPhrase}");
//       //  Get.snackbar("Error", "Failed to resend OTP: ${response.reasonPhrase}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//       //Get.snackbar("Error", "Something went wrong: $e");
//     }
//   }
//
//
//   @override
//   void onClose() {
//     for (var controller in otpControllers) {
//       controller.dispose();
//     }
//     super.onClose();
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Bottom2/views/bottom2_view.dart';
import '../../provider_profile/views/provider_profile_view.dart';
class ProviderOtpController extends GetxController {
  //TODO: Implement ProviderOtpController
  var imagePath = ''.obs;
  String? mobileNumber;
  TextEditingController otpTextController = TextEditingController();

  List<TextEditingController> otpControllers =
  List.generate(4, (index) => TextEditingController());

  @override
  void onInit() {
    super.onInit();
    loadMobileNumber();
  }
  Future<void> loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();

    mobileNumber = prefs.getString('mobileNumber');
    String? userId = prefs.getString('userId');
    print("🔑 Loaded userId: $userId");
  }




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
  //       // Extract userData
  //       final userData = responseData['userData'];
  //       final userImg = userData?['userImg']?? ''; // from userData
  //       final token = responseData['token'] ?? '';
  //       final userId = responseData['id'].toString();
  //       final userType = responseData['userType'] ?? 0;
  //
  //       // Construct final image URL
  //       String finalImage = '';
  //       if (userImg.isNotEmpty) {
  //         finalImage = userImg.startsWith('http')
  //             ? userImg
  //             : 'https://jdapi.youthadda.co/$userImg';
  //       }
  //
  //       print("🖼️ Final User Image URL: $finalImage");
  //
  //       // Save to SharedPreferences
  //       await prefs.setString('token', token);
  //       await prefs.setString('userId', userId);
  //       await prefs.setInt('userType', userType);
  //       await prefs.setString('image', finalImage);
  //
  //       // Other user data
  //       await prefs.setString('email', userData?['email'] ?? '');
  //       await prefs.setString('firstName', userData?['firstName'] ?? '');
  //       await prefs.setString('lastName', userData?['lastName'] ?? '');
  //       await prefs.setString('dob', userData?['dateOfBirth'] ?? '');
  //       await prefs.setString('gender', userData?['gender'] ?? '');
  //       await prefs.setString('mobile', userData?['phone'] ?? '');
  //       await prefs.setString('userImg', userData?['userImg'] ?? '');
  //
  //       // Confirm
  //       print("✅ Image Saved to SharedPreferences: ${prefs.getString('image')}");
  //
  //       otpTextController.clear();
  //
  //       final box = GetStorage();
  //       if ((userData?['email'] ?? '').isNotEmpty &&
  //           (userData?['firstName'] ?? '').isNotEmpty) {
  //         box.write('isLoggedIn2', true);
  //         Get.offAllNamed('/bottom2');
  //       } else {
  //         box.write('isLoggedIn2', false);
  //         Get.offAll(() => ProviderProfileView());
  //       }
  //     } else {
  //       print("❌ OTP Verification Failed: ${response.body}");
  //     }
  //   } catch (e) {
  //     print("❌ Exception: $e");
  //   }
  // }
  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty || otp.length != 4) {
      print("❌ Invalid OTP");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobileNumber = prefs.getString('mobileNumber');

    if (mobileNumber == null || mobileNumber.isEmpty) {
      print("❌ Mobile number not found");
      return;
    }

    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({"phone": mobileNumber, "otp": otp});
    final url = Uri.parse('https://jdapi.youthadda.co/user/verifyotp');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("✅ OTP Verified: ${jsonEncode(responseData)}");

        final token = responseData['token'] ?? '';
        final userType = responseData['userType'] ?? 0;
        final userId = responseData['id']?.toString() ?? '';

        final userData = responseData['userData'] ?? {};
        final firstName = userData['firstName']?.toString() ?? '';
        final lastName = userData['lastName']?.toString() ?? '';
        final email = userData['email']?.toString() ?? '';
        final phone = userData['phone']?.toString() ?? '';
        final userImg = userData?['userImg']?? ''; // from userData
        String finalImage = '';
        if (userImg.isNotEmpty) {
          finalImage = userImg.startsWith('http')
              ? userImg
              : 'https://jdapi.youthadda.co/$userImg';
        }

        print("🖼️ Final User Image URL: $finalImage");

        otpTextController.clear();

        // Save profession details if available
        final skills = userData['skills'];

        if (skills != null && skills.isNotEmpty) {
          final skill = skills[0];
          final categoryName = skill['categoryId']?['name'] ?? '';
          final subCategoryName = skill['sucategoryId']?['name'] ?? '';
          final charge = skill['charge']?.toString() ?? '';
          final spType = skill['categoryId']?['spType']?.toString() ?? '';
          print("💡 spType: $spType");
          await prefs.setString('spType', spType);
          await prefs.setString('image', finalImage);

          await prefs.setString('category', categoryName);
          await prefs.setString('subCategory', subCategoryName);
          await prefs.setString('charge', charge); await prefs.setString('spType', spType);
        }
        final dob = userData?['dateOfBirth'] ?? '';
        final gender = userData?['gender'] ?? '';
        // Save to SharedPreferences
        // 👈 Save spType in SharedPreferences
        await prefs.setString('userId', userId);
        await prefs.setString('token', token);
        await prefs.setInt('userType', userType);
        await prefs.setString('firstName', firstName);
        await prefs.setString('lastName', lastName);
        await prefs.setString('email', email);
        await prefs.setString('mobile', phone);
        await prefs.setString('userImg', userData?['userImg'] ?? '');

        // Confirm
        print("✅ Image Saved to SharedPreferences: ${prefs.getString('image')}");

        await prefs.setString('dob', dob);
        await prefs.setString('gender', gender);
        final box = GetStorage();
        box.remove('isLoggedIn');
        box.write('isLoggedIn2', true);

        print("🔐 Saved userType: $userType");

        // Navigate based on profile completeness
        if (firstName.isNotEmpty && email.isNotEmpty) {
          Get.offAllNamed('/bottom2'); // Home
        } else {
          Get.offAll(() => ProviderProfileView()); // Complete profile
        }
      } else {
        print("❌ OTP Verification Failed: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception during OTP verification: $e");
    }
  }



  // Resend OTP
  Future<void> resendOtp() async {

    final headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode({"phone": mobileNumber});
    final url = Uri.parse('https://jdapi.youthadda.co/user/sendotp');

    try {
      final request = http.Request('POST', url);
      request.body = body;
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("OTP resent successfully: $responseBody");
        // Get.snackbar("Success", "OTP resent successfully to +91 $mobileNumber");
      } else {
        print("Failed to resend OTP: ${response.reasonPhrase}");
        //  Get.snackbar("Error", "Failed to resend OTP: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
      //Get.snackbar("Error", "Something went wrong: $e");
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