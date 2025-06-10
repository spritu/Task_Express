import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ServiceCompletedSuccessfully/views/service_completed_successfully_view.dart';

class ServiceCompletedController extends GetxController {
  final rating = 0.0.obs;
  final review = ''.obs;
  var bookingId = ''.obs;
  void setRating(double value) {
    rating.value = value;
  }
  final Map<String, dynamic> booking = Get.arguments;
  Future<void> submitReview(String bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId'); // Get stored ID from registration
    String? userId2 = prefs.getString('userId');
    if (userId == null) {
    //  Get.snackbar("Error", "User ID not found. Please log in again.");
      return;
    }
    if (rating.value == 0.0) {
    //  Get.snackbar("Rating Required", "Please provide a rating before submitting.");
      return;
    }

    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "reviewer": userId, // Replace with dynamic value if needed
      "reviewedUser": userId2, // Replace with dynamic value if needed
      "bookingId": bookingId,
      "rating": rating.value.toString(),
      "review": review.value.toString()
    });

    try {
      final request = http.Request('POST', Uri.parse('https://jdapi.youthadda.co/addeditreview'));
      request.body = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        print("Review submitted: $responseData");
       // Get.snackbar("Success", "Thank you for your feedback!");

        // Navigate on success
        Get.to(() => const ServiceCompletedSuccessfullyView());
      } else {
        print("Review submit failed: ${response.reasonPhrase}");
       // Get.snackbar("Error", "Failed to submit review: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
     // Get.snackbar("Error", "Something went wrong: $e");
    }
  }
  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> booking = Get.arguments;
    print('65656565:${booking}');

    bookingId.value = booking['data']['_id'];
  }

}
