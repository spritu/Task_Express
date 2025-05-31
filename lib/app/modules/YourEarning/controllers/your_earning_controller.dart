import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class YourEarningController extends GetxController {
  final count = 0.obs;

  RxString filter = ''.obs;
  RxList<dynamic> bookings = <dynamic>[].obs;

  RxString globalCompletedBooking = ''.obs;
  var fullName = ''.obs;
  var date = ''.obs;
  var charge = ''.obs;
  var address = ''.obs;

  //   Fetch completed bookings based on filter

  Future<void> fetchCompletedBookingsTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null || userId.isEmpty) {
      print("❌ userId not found in SharedPreferences");
      return;
    }

    final uri = Uri.parse(
      'https://jdapi.youthadda.co/getcompletedbookingsfilter?userId=$userId&filter=${filter.value}',
    );

    try {
      var request = http.Request('GET', uri);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);

        if (data['bookings'] != null && data['bookings'] is List) {
          bookings.value = data['bookings'];

          if (bookings.isNotEmpty) {
            final booking = bookings[0];
            final bookedBy = booking['bookedBy'];

            // 🧠 Safely extract full name
            if (bookedBy is Map) {
              final firstName = bookedBy['firstName'];
              final lastName = bookedBy['lastName'];

              fullName.value =
                  (firstName is String && lastName is String)
                      ? "$firstName $lastName"
                      : "Unknown Name";

              final addr = bookedBy['address'];
              address.value = addr is String ? addr.trim() : 'N/A';
            } else {
              fullName.value = "Unknown Name";
              address.value = 'N/A';
            }

            // 💰 Set charge
            final pay = booking['pay'];
            charge.value = pay != null ? pay.toString() : "0";

            // 🕒 Format date
            final createdAtString = booking['jobStartTime'];
            if (createdAtString is String && createdAtString.isNotEmpty) {
              final parsedDate = DateTime.tryParse(createdAtString);
              if (parsedDate != null) {
                date.value =
                    "${parsedDate.day.toString().padLeft(2, '0')}/"
                    "${parsedDate.month.toString().padLeft(2, '0')}/"
                    "${parsedDate.year}";
              } else {
                date.value = 'N/A';
              }
            } else {
              date.value = 'N/A';
            }

            print("✅ fullName: ${fullName.value}");
            print("✅ Address: ${address.value}");
            print("✅ Date: ${date.value}");
          }
        }
      } else {
        address.value = 'N/A';
        print("❌ Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    }
  }

  // Future<void> fetchCompletedBookingsTotal() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userId = prefs.getString('userId');
  //
  //   if (userId == null || userId.isEmpty) {
  //     print("❌ userId not found in SharedPreferences");
  //     return;
  //   }
  //
  //   final uri = Uri.parse(
  //     'https://jdapi.youthadda.co/getcompletedbookingsfilter?userId=$userId&filter=${filter.value}',
  //   );
  //
  //   try {
  //     var request = http.Request('GET', uri);
  //     http.StreamedResponse response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       String responseData = await response.stream.bytesToString();
  //       final data = jsonDecode(responseData);
  //
  //       if (data['bookings'] != null) {
  //         bookings.value = data['bookings'];
  //         final createdAtString = bookings[0]['jobStartTime'] ?? '';
  //         if (bookings.isNotEmpty) {
  //           final booking = bookings[0];
  //           fullName.value =
  //               "${bookings[0]['bookedBy']['firstName']} ${bookings[0]['bookedBy']['lastName']}";
  //           charge.value = "${bookings[0]['pay']}";
  //           address.value =
  //               "${bookings[0]['bookedBy']['address'] ?? ''.trim()}";
  //           if (createdAtString.isNotEmpty) {
  //             final parsedDate = DateTime.parse(createdAtString);
  //             date.value =
  //                 "${parsedDate.day.toString().padLeft(2, '0')}/"
  //                 "${parsedDate.month.toString().padLeft(2, '0')}/"
  //                 "${parsedDate.year}";
  //           } else {
  //             date.value = 'N/A';
  //           }
  //           print("fullname:$bookings");
  //           print("Date:$date");
  //         }
  //       }
  //     } else {
  //       address.value = 'N/A';
  //       print("  Error: ${response.reasonPhrase}");
  //     }
  //   } catch (e) {
  //     print("  Exception: $e");
  //   }
  // }

  @override
  void onInit() {
    super.onInit();

    // ✅ Get filter from navigation arguments
    if (Get.arguments != null && Get.arguments['filter'] != null) {
      filter.value = Get.arguments['filter'];
      print("📥 Received filter: ${filter.value}");
    }

    // 🔹 Now fetch the data using the correct filter
    fetchCompletedBookingsTotal();
  }

  void increment() => count.value++;
}
