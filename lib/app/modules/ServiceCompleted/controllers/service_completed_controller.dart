import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../ServiceCompletedSuccessfully/views/service_completed_successfully_view.dart';
import '../../booking/controllers/booking_controller.dart';

class ServiceCompletedController extends GetxController {
  final rating = 0.0.obs;
  final review = ''.obs;
  var bookingId = ''.obs;late UserModel user;
  void setRating(double value) {
    rating.value = value;
  }
  final Map<String, dynamic> booking = Get.arguments;
  Future<void> submitReview(String bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId'); // Reviewer (logged-in user)

    if (userId == null) {
      print("❌ User ID not found in SharedPreferences");
      return;
    }

    if (rating.value == 0.0) {
      print("❌ Rating is required");
      return;
    }

    // ✅ Get reviewed user's ID from bookedFor._id
    final reviewedUserId = booking['data']['bookedFor']['_id'];

    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "reviewer": userId,
      "reviewedUser": reviewedUserId, // ✅ This is now correct
      "bookingId": bookingId,
      "rating": rating.value.toString(),
      "review": review.value.toString()
    });

    try {
      final request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/addeditreview'),
      );
      request.body = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        print("✅ Review submitted: $responseData");
        Get.to(() => const ServiceCompletedSuccessfullyView());
      } else {
        print("❌ Review submit failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception while submitting review: $e");
    }
  }

  void fetchReviewById(String bookingId) async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/getreviewbyid'),
    );
    request.body = json.encode({"bookingId": bookingId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      print("✅ Review response: $responseData");
    } else {
      print("❌ Error: ${response.reasonPhrase}");
    }
  }

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is Map) {
      final data = Map<String, dynamic>.from(arguments);
      bookingId.value = data['data']['_id'];
    } else {
      print("❌ Expected arguments to be a Map, got ${arguments.runtimeType}");
    }
  }

}
