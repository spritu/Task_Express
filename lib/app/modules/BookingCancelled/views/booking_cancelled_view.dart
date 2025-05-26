import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:worknest/app/modules/bottom/views/bottom_view.dart';
import 'package:worknest/colors.dart';

import '../controllers/booking_cancelled_controller.dart';

class BookingCancelledView extends GetView<BookingCancelledController> {
  const BookingCancelledView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(BookingCancelledController());
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFAEC6F9), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.center,
            stops: [0.1, 0.4],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: () {
                      Get.back();
                    }, icon: Icon(Icons.arrow_back)),
                    Text(
                      "Booking Cancelled",
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(""),
                  ],
                ),
                SizedBox(height: 30),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/Cancelledbooking.png",
                        height: 276,
                        width: 276,
                      ),
                      SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: "Your booking has been",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            fontFamily: "poppins",
                            color: Colors.black, // Required for RichText
                          ),
                          children: [
                            TextSpan(
                              text: " cancelled",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                fontFamily: "poppins",
                                color: Color(0xFF114BCA),
                              ),
                            ),
                            TextSpan(
                              text: ". \n     Thank you for your feedback.",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                fontFamily: "poppins",
                                color: Colors.black, // Required for RichText
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 34,
                            width: 112,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF114BCA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {

                              },
                              child: FittedBox(
                                // Ensures single-line
                                child: Text(
                                  "My Bookings",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "poppins",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          SizedBox(
                            height: 34,
                            width: 112,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Color(0xFF114BCA)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {Get.to(BottomView());
                               // showBookingBottomSheet(context);
                              },
                              child: FittedBox(
                                // Ensures single-line
                                child: Text(
                                  "Back to Home",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "poppins",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF114BCA),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

void showBookingBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: Color(0xFFF5F7FD),
    builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage("assets/images/amit.png"),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Amit Sharma",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF114BCA),
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "If this conversation with Amit Sharma\nmeet your expectations, book now:",

                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4F4F4F),
                ),
              ),
              SizedBox(height: 16),
              buildServiceTile("Plumber", "₹ 300"),
              buildServiceTile("Electrician", "₹ 350"),
              buildServiceTile("Carpenter", "₹ 400"),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Not Satisfied? Let’s help you find someone else",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Poppins",
                    color: Color(0xFF4F4F4F),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 34,
                  width: 119,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFF114BCA)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(Icons.close, color: Color(0xFF114BCA)),
                    label: Text(
                      "Cancel",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF114BCA),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildServiceTile(String title, String price) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Row(
          children: [
            Text(
              price,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF114BCA),
              ),
            ),
            SizedBox(width: 12),
            SizedBox(
              height: 25,
              width: 80,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF114BCA),
                  minimumSize: Size(79, 25),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  "Book Now",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}