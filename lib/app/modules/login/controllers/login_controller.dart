import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  final TextEditingController mobileController = TextEditingController();
  var isChecked = false.obs; // Observable state
  void toggleCheck(bool value) {
    isChecked.value = value;
  }
  void openTerms() {
    print('Terms & Conditions clicked');
    // Aap yahan Get.toNamed('/terms') ya URL launch kar sakte hain
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
    // Aap yahan Get.toNamed('/privacy') ya URL launch kar sakte hain
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
