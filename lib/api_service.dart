import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://dg-sandbox.setu.co/api/okyc';
  static const String clientId = 'test-client';
  static const String clientSecret = 'YOUR_CLIENT_SECRET';
  static const String productInstanceId = 'YOUR_PRODUCT_INSTANCE_ID';

  static Future<Map<String, dynamic>?> verifyAadhaar(
      String aadhaarNumber, String captchaCode) async {
    final String requestId = DateTime.now().millisecondsSinceEpoch.toString();
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
      return null; // Return null on failure instead of throwing an exception
    }
  }
}
