import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;

class BookingController extends GetxController {
  //TODO: Implement BookingController
  var currentBooking = {}.obs;
  var isLoading = false.obs;
  Future<void> fetchCurrentBooking(String serviceProId) async {
    isLoading.value = true;
    try {
      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/getserprocurrentbooking'),
      );
      request.body = json.encode({
        "serviceProId": serviceProId,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String res = await response.stream.bytesToString();
        currentBooking.value = json.decode(res);
      } else {
        Get.snackbar("Error", "Failed to fetch booking");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
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
      Get.snackbar("Success", "Booking rejected");
    } else {
      print(response.reasonPhrase);
      Get.snackbar("Error", "Something went wrong");
    }
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
