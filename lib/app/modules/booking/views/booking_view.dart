import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/app/modules/chat/views/chat_view.dart';
import 'package:worknest/app/modules/chat_screen/views/chat_screen_view.dart';
import '../../../../colors.dart';
import '../../../routes/app_pages.dart';
import '../../ServiceCompleted/views/service_completed_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../../user_help/views/user_help_view.dart';
import '../controllers/booking_controller.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchCurrentBooking("680883961c5342a65525df76");
    return  WillPopScope(
      onWillPop: () async {
        Get.find<BottomController>().selectedIndex.value = 0; // 👈 Home tab
        Get.offAll(() => BottomView());
        return false;
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(gradient: AppColors.appGradient),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Top Bar
                  const SizedBox(width: 135),
                  const Text(
                    "Bookings",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: "poppins",
                    ),
                  ),
                  /// Location Row
                  const SizedBox(height: 20),
                  /// Main Container
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height*0.5,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFD9E4FC),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Current Booking",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "poppins",
                                      ),
                                    ),InkWell(onTap: (){
                                      Get.to(UserHelpView());
                                    },
                                      child: Text(
                                        "Help",
                                        style: TextStyle(
                                          fontSize: 14,color: Color(0xff114BCA),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "poppins",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  height: 83,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Image.asset("assets/images/rajesh.png"),
                                        SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Suraj Sen",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "poppins",
                                              ),
                                            ),
                                            Text(
                                              "Fixed Charge Helper",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                fontFamily: "poppins",
                                                color: Color(0xFF575757),
                                              ),
                                            ),
                                            SizedBox(height: 15),
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
                                                  TextSpan(text: "Booked: "),
                                                  TextSpan(
                                                    text: "Today, 10:45 am ",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 9),
                                Container(
                                  height: 48,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
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
                                            TextSpan(text: "Charge\n"),
                                            TextSpan(
                                              text: "₹ 250 per day",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(height: 16, width: 1, color: Color(0xff746E6E)),
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
                                            TextSpan(text: "Arrive in\n"),
                                            TextSpan(
                                              text: "30 minutes",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Container(
                                  height: 42,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                          //  height: 28,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                controller.rejectBooking();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text(
                                                "Cancle Booking",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "poppins",
                                                  color: Color(0xFF114BCA),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: SizedBox(
                                         //   height: 28,
                                            child: ElevatedButton(
                                              onPressed: () {

                                                controller.makePhoneCall("phoneNumber");
                                              },
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
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: SizedBox(
                                           // height: 28,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Get.to(ChatView());
                                              },
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
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )

                                ),
                                const SizedBox(height: 9),
                                Container(
                                  height: 104,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          "Task finished? Tap ‘Close Job’ to complete \nthe process and pay your worker.",
                                          style: TextStyle(
                                            fontFamily: "poppins",
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 36,
                                              width: 135,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Get.to(ServiceCompletedView());
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFF114BCA,
                                                  ),
                                                  elevation: 0, // Flat look
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(
                                                      10,
                                                    ), // Fully rounded edges
                                                  ),
                                                  padding:
                                                  EdgeInsets
                                                      .zero, // Remove extra padding
                                                ),
                                                child: const Text(
                                                  "Close Job & Pay",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "poppins",
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),    SizedBox(height: 10),
                          Divider(thickness: 1, color: Color(0xFFD9E4FC)),
                          SizedBox(height: 10),
                          Container(
                            height: 44,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xFFD9E4FC),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Past Bookings",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  fontFamily: "poppins",
                                ),
                              ),
                            ),
                          ),
                          ListView.builder(
                            itemCount: 3,shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          /// Left Section - Text
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              /// Name
                                              const Text(
                                                "Amit Sharma",
                                                style: TextStyle(
                                                  fontFamily: "poppins",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              /// Subtitle
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: "poppins",
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                  children: const [
                                                    TextSpan(
                                                      text:
                                                      "Visiting Professional, ",
                                                    ),
                                                    TextSpan(
                                                      text: "Electrician",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(
                                                          0xFF114BCA,
                                                        ), // Blue color
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              /// Booked (optional additional line)
                                              const Text(
                                                "Booked: Today, 10:30 AM",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "poppins",
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          /// Right Section - Buttons
                                          Column(
                                            children: [
                                              /// Re-book
                                              SizedBox(
                                                height: 32,
                                                width: 98,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    elevation: 0,
                                                    side: const BorderSide(
                                                      color: Colors.black,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(8),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: const Text(
                                                    "Re-Book",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: "poppins",
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              /// Rate Service
                                              SizedBox(
                                                height: 32,
                                                width: 98,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    elevation: 0,
                                                    side: const BorderSide(
                                                      color: Color(0xFF114BCA),
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(8),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: const Text(
                                                    "Rate Service ",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: "poppins",
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xFF114BCA),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Divider(thickness: 1),
                                    ],
                                  ),
                                ),
                              );
                            },
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
      ),
    );
  }
}