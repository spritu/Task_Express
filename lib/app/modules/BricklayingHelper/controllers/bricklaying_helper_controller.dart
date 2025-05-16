import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../BookingConfirm/views/booking_confirm_view.dart';
import '../../RequestPandding/views/request_pandding_view.dart';

class BricklayingHelperController extends GetxController {
  //TODO: Implement BricklayingHelperController
  final RxList<double> _ratings = List.generate(10, (index) => 3.0).obs;

  double getRating(int index) => _ratings[index];
  var workers = <Map<String, dynamic>>[].obs;
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
      'Content-Type': 'application/json'
    };
    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/acceptreject'),
    );
    request.body = json.encode({
      "bookingId": "680151e5b65cf6b90ed15986",
      "accept": "yes"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print(responseBody);
      // Optional: Show confirmation to user
    } else {
      print(response.reasonPhrase);
      // Optional: Show error message
    }}
  @override
  void onInit() {
    super.onInit();
    fetchWorkers();
  }
  Future<void> bookServiceProvider() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
      };

      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/bookserviceprovider'),
      );

      request.body = json.encode({
        "bookedBy": "67fe4d6e642ad80d6b59d1a9",  // Replace with dynamic ID
        "bookedFor": "67fe4d45642ad80d6b59d1a5", // Replace with dynamic ID
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final resBody = await response.stream.bytesToString();
      print("📦 Response: $resBody");

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Service provider booked successfully");
        Get.to( RequestPanddingView(helperName: '',));
      } else {
        print("❌ Error: ${response.reasonPhrase}");
        Get.snackbar("Error", "Booking failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception during booking: $e");
      Get.snackbar("Error", "Something went wrong during booking.");
    }
  }

  void fetchWorkers() {
    workers.value = [
      {
        'name': 'Suraj sen',
        'image': 'assets/images/rajesh.png', // your local image asset
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },
      {
        'name': 'Rajesh kumar',
        'image': 'assets/images/rajesh.png',
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },  {
        'name': 'Suraj sen',
        'image': 'assets/images/rajesh.png', // your local image asset
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },
      {
        'name': 'Rajesh kumar',
        'image': 'assets/images/rajesh.png',
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },  {
        'name': 'Suraj sen',
        'image': 'assets/images/rajesh.png', // your local image asset
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },
      {
        'name': 'Rajesh kumar',
        'image': 'assets/images/rajesh.png',
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },
      // Add more if needed
    ];
  }
  void setRating(int index, double rating) {
    _ratings[index] = rating;
  }
  final count = 0.obs;

  void showAfterCallSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Color(0xFFD9E4FC),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: 70,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Close button at top-right
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),

              /// Profile Picture
              CircleAvatar(
                radius: 47.5, // for 95x95
                backgroundImage: AssetImage("assets/images/rajesh.png"),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 8),

              /// Name
              Text(
                "Suraj Sen",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),

              /// Main Container with question and buttons
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "Are you satisfied with this conversation?",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: "poppins",
                        color: Color(0xFF4F4F4F),
                      ),
                    ),
                    SizedBox(height: 16),

                    /// Book Now Button
                    SizedBox(
                      height: 42,
                      width: 176,
                      child: ElevatedButton(
                        onPressed: () async {
                        await Future.delayed(Duration(milliseconds: 200)); // Smooth UX
                        showAreUSureSheet(context); // close the sheet if needed
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF114BCA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, color: Colors.white, size: 18),
                            SizedBox(width: 10),
                            Text(
                              "Book Now",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: "poppins",
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    /// Not Satisfied text
                    Text(
                      "Not Satisfied, let’s find another",
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color(0xFF4F4F4F),
                      ),
                    ),
                    SizedBox(height: 10),
                    /// Cancel Button
                    SizedBox(
                      height: 42,
                      width: 176,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            // side: BorderSide(color: Color(0xFF114BCA)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close, color: Color(0xFF114BCA), size: 18),
                            SizedBox(width: 10),
                            Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: "poppins",
                                color: Color(0xFF114BCA),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  void showAreUSureSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Color(0xFFD9E4FC),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: 70,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Close button at top-right
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),

              /// Profile Picture
              CircleAvatar(
                radius: 47.5, // for 95x95
                backgroundImage: AssetImage("assets/images/rajesh.png"),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 8),

              /// Name
              Text(
                "Suraj Sen",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),

              /// Main Container with question and buttons
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "Are you sure you want to continue with this booking?",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: "poppins",
                        color: Color(0xFF4F4F4F),
                      ),
                    ),
                    SizedBox(height: 16),

                    /// Book Now Button
                    SizedBox(
                      height: 42,
                      width: 176,
                      child: ElevatedButton(
                        onPressed: () async {
                         await bookServiceProvider();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF114BCA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, color: Colors.white, size: 18),
                            SizedBox(width: 10),
                            Text(
                              "Yes",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: "poppins",
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    SizedBox(height: 10),

                    /// Cancel Button
                    SizedBox(
                      height: 42,
                      width: 176,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            // side: BorderSide(color: Color(0xFF114BCA)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close, color: Color(0xFF114BCA), size: 18),
                            SizedBox(width: 10),
                            Text(
                              "No",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: "poppins",
                                color: Color(0xFF114BCA),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
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
