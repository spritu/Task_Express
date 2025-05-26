import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/booking_confirm_controller.dart';

class BookingConfirmView extends GetView<BookingConfirmController> {
  const BookingConfirmView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(BookingConfirmController());
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87AAF6), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Top Bar
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(onTap: (){
                        Get.back();
                      },
                          child: Icon(Icons.arrow_back)),
                    
                      const Text(
                        "Booking Confirmation",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: "poppins",
                        ),
                      ),Text("")
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// Location Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, size: 24),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Scheme No 54',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Fh-289, Vijaynagar, Indore',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// Main Container
                  Container(
                    height: 457,
                    width: 368,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "You’ve recently booked",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "poppins",
                          ),
                        ),
                        const SizedBox(height: 16),
                        const CircleAvatar(
                          radius: 47.5,
                          backgroundImage: AssetImage("assets/images/rajesh.png"),
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Suraj sen",
                          style: TextStyle(
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Fixed charge helper",
                          style: TextStyle(
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF757575),
                          ),
                        ),
                        const SizedBox(height: 16),
                        /// Charge Info
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "poppins",
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: "Fixed Charge: "),
                              TextSpan(
                                text: "₹250 per day",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "poppins",
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: "On the way — will reach your address in approximately "),
                              TextSpan(
                                text: "30 minutes.",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// Call & Chat Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                              width: 110,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF114BCA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Call",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "poppins",
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 30,
                              width: 110,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF114BCA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Chat",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "poppins",
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "For more details, go to Bookings",
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
    );
  }
}