import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ServiceCompletedSuccessfully/views/service_completed_successfully_view.dart';

class ServiceCompletedController extends GetxController {
  final rating = 0.0.obs;
  final review = ''.obs;

  void setRating(double value) {
    rating.value = value;
  }

  Future<void> submitReview() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId'); // Get stored ID from registration

    if (userId == null) {
      Get.snackbar("Error", "User ID not found. Please log in again.");
      return;
    }
    if (rating.value == 0.0) {
      Get.snackbar("Rating Required", "Please provide a rating before submitting.");
      return;
    }

    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "reviewer": userId, // Replace with dynamic value if needed
      "reviewedUser": "6800d9e2764d14e5400cc38e", // Replace with dynamic value if needed
      "rating": rating.value,
      "review": review.value
    });

    try {
      final request = http.Request('POST', Uri.parse('https://jdapi.youthadda.co/addeditreview'));
      request.body = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        print("Review submitted: $responseData");
        Get.snackbar("Success", "Thank you for your feedback!");

        // Navigate on success
        Get.to(() => const ServiceCompletedSuccessfullyView());
      } else {
        print("Review submit failed: ${response.reasonPhrase}");
        Get.snackbar("Error", "Failed to submit review: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }
}
