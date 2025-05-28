import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../views/confirm_payment_recived_view.dart';

class ConfirmPaymentRecivedController extends GetxController {
  //TODO: Implement ConfirmPaymentRecivedController

  final count = 0.obs;

  RxList<Map<String, dynamic>> pendingPayments = <Map<String, dynamic>>[].obs;

  Future<void> fetchPendingPayments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? serviceProId = prefs.getString("userId");

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/pendingpaymentsp'),
    );

    request.body = json.encode({"serviceProId": serviceProId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      var responseData = json.decode(res);

      if (responseData['count'] > 0) {
        for (var payment in responseData['data']) {
          print('12121212:${payment}');
          pendingPayments.add(payment);
          showConfirmPopup(payment);
        }
      }
    } else {
      print("❌ Error: ${response.reasonPhrase}");
    }
  }

  void showConfirmPopup(Map<String, dynamic> paymentData) {
    Get.showSnackbar(
      GetSnackBar(
        messageText: ConfirmPaymentRecivedView(paymentData: paymentData),
        isDismissible: false,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.transparent,
        //  duration: const Duration(hours: 1),
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        borderRadius: 30,
      ),
    );
  }

  Future<void> sendPaymentConfirmation({
    required String bookingId,
    required bool acceptBySp,
  }) async {
    final url = Uri.parse("https://jdapi.youthadda.co/spaccept");

    final Map<String, dynamic> bodyData = {
      "bookingId": bookingId.trim(),
      "acceptbysp": acceptBySp, // ✅ convert to string "true"/"false"
    };

    print("📤 Sending payment confirmation...");
    print("Request body: $bodyData");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    );

    print("📥 Status Code: ${response.statusCode}");
    print("📥 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      print("✅ Payment confirmation sent: $acceptBySp");
      fetchPendingPayments(); // refresh the list
      Get.back(); // close popup
    } else {
      print("❌ Failed to send payment confirmation");
    }
  }

  // var bookingId = ''.obs;
  //
  // Future<void> acceptBooking() async {
  //   print('api called');
  //
  //   var url = Uri.parse('https://jdapi.youthadda.co/spaccept');
  //
  //   var headers = {'Content-Type': 'application/json'};
  //
  //   var body = json.encode({"bookingId": bookingId, "acceptbysp": true});
  //   print('api body${bookingId}');
  //
  //   try {
  //     print('api body${body}');
  //
  //     var response = await http.post(url, headers: headers, body: body);
  //     print('api resp${response}');
  //
  //     if (response.statusCode == 200) {
  //       print('Success12345: ${response.body}');
  //     } else {
  //       print('Failed: ${response.statusCode} - ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

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
