import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JobsController extends GetxController {
  //TODO: Implement JobsController
  int selectedIndex = 0;
  final count = 0.obs;
  var isLoading = false.obs;

  var bookingDataList = <Map<String, dynamic>>[].obs;


  Future<void> fetchCurrentBooking() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
      //  Get.snackbar("Error", "User not logged in");
        return;
      }

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/getserprorunningbooking'),
      );
      request.body = json.encode({
        "serviceProId": userId,
      }); // or hardcoded if needed
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print("📥 API Response Body123: $responseBody");

      if (response.statusCode == 200) {
        var jsonRes = jsonDecode(responseBody);
        if (jsonRes['data'] is List && jsonRes['data'].isNotEmpty) {
          bookingDataList.value = List<Map<String, dynamic>>.from(
            jsonRes['data'],
          );

          // Extract bookingId from first item (you can change index)
          String bookingId =
          bookingDataList[0]['_id']; // assuming _id is bookingId
          String phone = bookingDataList[0]['userMobile'] ?? "";
          await prefs.setString('currentBookingId', bookingId);
          await prefs.setString('currentBookingPhone', phone);
          print("💾 Booking ID saved to SharedPreferences12: $bookingId");
        } else {
          bookingDataList.clear();
        }

        if (jsonRes['data'] is List) {
          bookingDataList.value = List<Map<String, dynamic>>.from(
            jsonRes['data'],
          );
        } else {
          bookingDataList.clear();
        }
      } else {
      //  Get.snackbar("Error", "Failed to fetch booking");
      }
    } catch (e) {
      print("❌ Exception in fetchCurrentBooking: $e");
     // Get.snackbar("Error", "Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onInit() {
    super.onInit();
    fetchCurrentBooking();
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
