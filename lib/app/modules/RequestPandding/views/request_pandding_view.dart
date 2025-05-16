import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../BookingConfirm/views/booking_confirm_view.dart';
import '../../bottom/views/bottom_view.dart';
import '../controllers/request_pandding_controller.dart';

class RequestPanddingView extends GetView<RequestPanddingController> {
  final String helperName;
  const RequestPanddingView({super.key,required this.helperName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xFFEEF3FE),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    Text(
                      "Bookings",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: "poppins",
                        fontSize: 15,
                      ),
                    ),
                    Text("        "),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(onTap: (){
                          Get.to(BookingConfirmView());
                        },
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 10,
                              ),
                              child: SizedBox(
                                //height: 396,
                                width: MediaQuery.of(context).size.width,

                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Waiting for',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontFamily: "poppins",
                                        ),
                                        children: <TextSpan>[
                                           TextSpan(
                                            text: ' $helperName ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xFF114BCA),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "poppins",
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            'to accept \n        your job request…',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontFamily: "poppins",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Image.asset("assets/images/Waiting.png"),
                                    SizedBox(height: 20),
                                    Text(
                                      "We’ve notified $helperName . You’ll be updated\nas soon as he responds.",
                                      style: TextStyle(
                                        fontFamily: "poppins",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Color(0xFF595959),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20),
                                    RichText(
                                      text: TextSpan(
                                        text: "Estimated response time:",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "poppins",
                                          color: Color(0xFF595959),
                                        ),
                                        children: [
                                          TextSpan(
                                            text: " within 2 minutes",
                                            style: TextStyle(
                                              fontFamily: "poppins",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Color(0xFF114BCA),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 50),
                        Column(
                          children: [
                            const Text(
                              "You can cancel the request anytime !",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: "poppins",
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ), // Space between text and buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Cancel Request Button (Blue)
                                SizedBox(
                                  height: 34,
                                  width: 112,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF114BCA),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.zero,
                                      elevation: 0,
                                    ),
                                    onPressed: () {
                                      // Handle cancel request
                                    },
                                    child: const Text(
                                      "Cancel Request",
                                      style: TextStyle(
                                        fontFamily: "poppins",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ), // Space between buttons
                                // Back to Home Button (Outlined)
                                SizedBox(
                                  height: 34,
                                  width: 112,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: Color(0xFF114BCA),
                                        width: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () {
                                 Get.to(BottomView());
                                    },
                                    child: const Text(
                                      "Back to Home",
                                      style: TextStyle(
                                        fontFamily: "poppins",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Color(0xFF114BCA),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}