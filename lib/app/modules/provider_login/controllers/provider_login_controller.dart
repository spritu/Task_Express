import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../auth_controller.dart';
import '../../provider_home/views/provider_home_view.dart';
import '../../provider_otp/views/provider_otp_view.dart';
import '../views/provider_login_view.dart';
class ProviderLoginController extends GetxController {
  //TODO: Implement ProviderLoginController

  final TextEditingController mobileeController = TextEditingController();
  var isChecked = false.obs;
  //final box = GetStorage();
  // final box = GetStorage();
  // void main() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await GetStorage.init();
  //   final box = GetStorage();
  // }

  Future<void> sendOtp() async {
    final phone = mobileeController.text.trim();

    if (phone.isEmpty || phone.length != 10) {
      Get.snackbar("Error", "Please enter a valid 10-digit mobile number");
      return;
    }

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({"phone": phone});
    final url = Uri.parse('https://jdapi.youthadda.co/user/sendotp');

    try {
      final request = http.Request('POST', url);
      request.body = body;
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final box = GetStorage();
        box.remove('isLoggedIn');
        final responseBody = await response.stream.bytesToString();
        print("✅ OTP sent successfully: $responseBody");

        final jsonResponse = json.decode(responseBody);

        // 👇 Extract and show OTP in snackbar for 10 seconds
        final otp = jsonResponse['otp']?.toString() ?? 'N/A';
        Get.snackbar(
          "🔐 OTP Received",
          "Your OTP is: $otp",
          duration: Duration(seconds: 10),
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // ✅ Save phone number
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('mobileNumber', phone);
        await prefs.reload();
        final authController = Get.find<AuthController>();
        authController.isLoggedIn2.value = true;

        //
        // await box.write('isLoggedIn2', true);
        // await box.write('mobile', phone);
        mobileeController.clear();

        // ✅ Navigate to OTP screen
        Get.to(() => ProviderOtpView());
      } else {
        print("❌ Failed to send OTP: ${response.reasonPhrase}");
       // Get.snackbar("Error", "Failed to send OTP: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    //  Get.snackbar("Error", "Something went wrong: $e");
    }
  }


  void toggleCheck(bool value) {
    isChecked.value = value;
  }
  void openTerms() {
    print('Terms & Conditions clicked');

  }
  final String baseUrl = 'https://dg-sandbox.setu.co/api/okyc';
  final String clientId = 'test-client';
  final String clientSecret = 'YOUR_CLIENT_SECRET';
  final String productInstanceId = 'YOUR_PRODUCT_INSTANCE_ID';

  Future<Map<String, dynamic>> verifyAadhaarCard(
      String requestId, String aadhaarNumber, String captchaCode) async {
    final url = Uri.parse('$baseUrl/$requestId/verify');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-client-id': clientId,
        'x-client-secret': clientSecret,
        'x-product-instance-id': productInstanceId,
      },
      body: jsonEncode({
        'aadhaarNumber': aadhaarNumber,
        'captchaCode': captchaCode,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify Aadhaar card: ${response.reasonPhrase}');
    }
  }
  void openPrivacy() {
    print('Privacy Policy clicked');

  }
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}