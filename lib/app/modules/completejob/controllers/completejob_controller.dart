import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../ServiceCompleted/views/service_completed_view.dart';

class CompletejobController extends GetxController {
  //TODO: Implement CompletejobController

  final count = 0.obs;
  late var bookedby = ''.obs;
  var bookingId = ''.obs;
  TextEditingController payController = TextEditingController();

  // Function to call API and close job
  Future<void> closeJob(String bookingId) async {
    if (payController.text.isEmpty) {
      print('❌ Pay is empty');
      return;
    }

    final pay = int.tryParse(payController.text);
    if (pay == null) {
      print('❌ Invalid pay input');
      return;
    }

    final url = Uri.parse('https://jdapi.youthadda.co/jobdone');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "bookingId": bookingId,
      "pay": pay,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        Get.to(ServiceCompletedView());
        print('✅ Success: ${response.body}');
      } else {
        print('❌ Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Exception: $e');
    }
  }

  String formatCreatedAt1234(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final date =
          "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
      final time =
          "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      return "$date, $time";
    } catch (e) {
      return "Invalid date";
    }
  }

  @override
  void onInit() {
    super.onInit();

    final Map<String, dynamic> booking = Get.arguments;

    bookingId.value = booking['data']['_id']; // ✅ Correct booking ID
    bookedby.value = booking['data']['bookedBy']['_id']; // (optional, if you need user ID elsewhere)

    print("📦 Booking ID: $bookingId");
    print("👤 Booked By User ID: ${bookedby.value}");

    closeJob(bookingId.value);
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