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
    controller.fetchCurrentBooking();
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
                horizontal: 8.0,
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
                          Obx(() {
                            return controller.hasBooking.value
                                ? // If booking exists, show full booking details
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9E4FC),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Header Row: "Current Booking" + Help
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
                                      ),
                                      InkWell(
                                        onTap: () => Get.to(UserHelpView()),
                                        child: const Text(
                                          "Help",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff114BCA),
                                            fontFamily: "poppins",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Booking Card
                                  buildBookingCard(),

                                  const SizedBox(height: 9),

                                  // Info Bar
                                  buildChargeAndArrivalCard(),

                                  const SizedBox(height: 9),

                                  // Action Buttons: Cancel, Call, Chat
                                  buildActionButtons(controller),

                                  const SizedBox(height: 9),

                                  // Close Job & Pay
                                  buildCloseJobCard(),
                                ],
                              ),
                            )
                                :
                            // If no booking, show this small container
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9E4FC),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Current Booking",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "poppins",
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "No current booking",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "poppins",
                                      color: Color(0xff114BCA),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          SizedBox(height: 10),

                          SizedBox(height: 10),
                          Card(color: Color(0xFFD9E4FC),
                            child: Padding(
                              padding:  EdgeInsets.symmetric(
                                horizontal: 3,
                                vertical: 15,
                              ),
                              child: Column(
                                children: [
                                  Row(crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [SizedBox(width: 10),
                                      Text(
                                        "Past Bookings",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          fontFamily: "poppins",
                                        ),
                                      ),
                                    ],
                                  ),SizedBox(height: 10),  ListView.builder(
                                    itemCount: 6,shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {},
                                        child: Card(color: AppColors.white,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 4),
                                            // padding: const EdgeInsets.all(12),
                                            child: Column(
                                              children: [
                                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    /// Left Section - Text
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        /// Name
                                                        Row(
                                                          children: [CircleAvatar(
                                                            backgroundImage: AssetImage("assets/images/professional_profile.png"),
                                                          ),

                                                            Column(mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                const Text(
                                                                  "Amit Sharma",
                                                                  style: TextStyle(
                                                                    fontFamily: "poppins",
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ), const SizedBox(height: 4),
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
                                                                          fontWeight: FontWeight.w400,
                                                                          fontSize: 12,
                                                                          color: Color(
                                                                            0xFF114BCA,
                                                                          ), // Blue color
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),

                                                        const SizedBox(height: 15),
                                                        /// Booked (optional additional line)
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: 'Booked: ',
                                                                style: TextStyle(
                                                                  fontFamily: 'Poppins',
                                                                  fontWeight: FontWeight.w400, // 400 = regular
                                                                  fontSize: 14,

                                                                  letterSpacing: 0,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: '12/12/2024, 11:34 PM',
                                                                style: TextStyle(
                                                                  fontFamily: 'Poppins',
                                                                  fontWeight: FontWeight.w500, // 500 = medium
                                                                  fontSize: 11,

                                                                  letterSpacing: 0,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ],
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
                                                          width: 85,
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
                                                          width: 85,
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Get.to(ServiceCompletedView());
                                                            },
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
                                                SizedBox(height: 5),

                                              ],
                                            ),
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

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildBookingCard() => Container(
    height: 83,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      boxShadow: [
        BoxShadow(blurRadius: 4, color: Colors.grey.shade400),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Image.asset("assets/images/rajesh.png"),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Suraj Sen", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: "poppins")),
              const Text("Fixed Charge Helper", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: "poppins", color: Color(0xFF575757))),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, fontFamily: "poppins", fontWeight: FontWeight.w500, color: Colors.black),
                  children: [
                    TextSpan(text: "Booked: "),
                    TextSpan(text: "Today, 10:45 am", style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget buildChargeAndArrivalCard() => Container(
    height: 48,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      boxShadow: [BoxShadow(blurRadius: 4, color: Colors.grey.shade400)],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:  [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(fontSize: 14, fontFamily: "poppins", fontWeight: FontWeight.w500, color: Colors.black),
            children: [
              TextSpan(text: "Charge\n"),
              TextSpan(text: "₹ 250 per day", style: TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        VerticalDivider(width: 1, color: Color(0xff746E6E), thickness: 1),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(fontSize: 14, fontFamily: "poppins", fontWeight: FontWeight.w500, color: Colors.black),
            children: [
              TextSpan(text: "Arrive in\n"),
              TextSpan(text: "30 minutes", style: TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    ),
  );

  Widget buildActionButtons(controller) => Container(
    height: 42,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      boxShadow: [BoxShadow(blurRadius: 4, color: Colors.grey.shade400)],
    ),
    child: Row(
      children: [
        buildButton("Cancel Booking", AppColors.white, const Color(0xFF114BCA), () => controller.rejectBooking()),
        buildButton("Call", const Color(0xFF114BCA), Colors.white, () => controller.makePhoneCall("phoneNumber")),
        buildButton("Chat", const Color(0xFF114BCA), Colors.white, () => Get.to(ChatView())),
      ],
    ),
  );

  Widget buildButton(String text, Color bgColor, Color textColor, VoidCallback onTap) => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: 28,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.zero,
          ),
          child: FittedBox(
            child: Text(
              text,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: "poppins",
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget buildCloseJobCard() => Container(
    height: 104,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      boxShadow: [BoxShadow(blurRadius: 4, color: Colors.grey.shade400)],
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Task finished? Tap ‘Close Job’ to complete \nthe process and pay your worker.",
            style: TextStyle(fontFamily: "poppins", fontSize: 13, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 36,
                width: 135,
                child: ElevatedButton(
                  onPressed: () => Get.to(ServiceCompletedView()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF114BCA),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "Close Job & Pay",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: "poppins", color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

}