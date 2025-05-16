import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../CancelBooking/views/cancel_booking_view.dart';
import '../../RequestPandding/views/request_pandding_view.dart';
import '../../booking/views/booking_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../../home/controllers/home_controller.dart';

class ProfessionalPlumberController extends GetxController with WidgetsBindingObserver{
  final HomeController userController = Get.put(HomeController());
  bool _callInitiated = false;var showRequestPending = false.obs;
  var helperName = ''.obs;
  var bookingData = {}.obs; var selectedIndex = 0.obs;
  Map<String, dynamic>? _callParams;
  //TODO: Implement ProfessionalPlumberController
  void loadSkills() async {
    List<Map<String, dynamic>> skills = await userController.getSkillsFromPrefs();
    print("🛠️ Retrieved Skills: $skills");
  }

  final landMark = Rx<String>('');final houseNo = Rx<String>('');
  Future<void> bookServiceProvider({
    required String bookedBy,
    required String bookedFor,
    required List<String> serviceIds,
    required String selectedHelperName,
  }) async {
    var headers = {'Content-Type': 'application/json'};

    var body = json.encode({
      "bookedBy": bookedBy,
      "bookedFor": bookedFor,
      "bookServices": serviceIds,
    });

    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/bookserviceprovider'),
    );

    request.body = body;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);

      print("✅ Booking successful: $responseData");

      var acceptStatus = responseData['data']['accept'];
      helperName.value = selectedHelperName;

      // Check if still pending
      if (acceptStatus == null) {
        showRequestPending.value = true;
      } else {
        showRequestPending.value = false;
      }

      // Optionally save full booking data
      bookingData.value = responseData['data'];
   selectedIndex.value = 0;
      final BottomController controller = Get.find<BottomController>();

      controller.helperName.value = selectedHelperName;
      controller.showRequestPending.value = (acceptStatus == null);
      controller.selectedIndex.value = 1;  // Booking tab

      Get.to(() => BottomView());
      // final BottomController controller = Get.find<BottomController>();
      // // Navigate to Booking screen
      // Get.to(
      // controller.selectedIndex.value = 0);
    } else {
      print("❌ Booking failed: ${response.reasonPhrase}");
      // Show error/snackbar here
    }
  }


  Future<void> rejectBooking() async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/acceptreject'),
    );

    request.body = json.encode({
      "bookingId": "680883961c5342a65525df76",
      "accept": "no",
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
      Get.to(CancelBookingView());
      Get.snackbar("Success", "Booking rejected");
    } else {
      print(response.reasonPhrase);
      Get.snackbar("Error", "Something went wrong");
    }
  }


  void makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
  }
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

  }


  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void increment() => count.value++;
}
