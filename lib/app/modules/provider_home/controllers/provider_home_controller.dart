import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ProviderHomeController extends GetxController {
  //TODO: Implement ProviderHomeController
  RxBool isAvailable2 = false.obs;
  var firstName = ''.obs;
  Future<void> updateAvailability(bool status) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({
        "serviceProId": "6800d7448480f1bedc178e39",
        "avail": status ? 1 : 0,
      });

      final response = await http.post(
        Uri.parse('https://jdapi.youthadda.co/user/changeavailstatus'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        Get.snackbar("Success", "Availability updated successfully");
      } else {
        Get.snackbar("Error", "Failed to update availability");
        isAvailable2.value = !status; // revert toggle
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
      isAvailable2.value = !status; // revert toggle
    }
  }
  final count = 0.obs;
  var isAvailable = true.obs;
  var isServiceProfile = false.obs;

  final List<Map<String, String>> jobs = List.generate(
    3,
        (index) => {
      "title": "Plumbing job",
      "subtitle": "Pipe Repair",
      "amount": "₹8450",
      "date": "10 Apr 2025",
    },
  );
  void fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    firstName.value = prefs.getString('firstName') ?? '';
  }
  @override
  void onInit() {
    super.onInit();
    fetchUserName();
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