import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/colors.dart';
import '../../BookingCancelled/views/booking_cancelled_view.dart';
import '../controllers/cancel_booking_controller.dart';

class CancelBookingView extends GetView<CancelBookingController> {
  const CancelBookingView({super.key});

  @override
  Widget build(BuildContext context) {
 Get.put(CancelBookingController());

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFAEC6F9), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.center,
            stops: [0.1, 0.4],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Cancel Booking",
                    style: TextStyle(
                      fontFamily: "poppins",
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 40), // To balance arrow & title
                ],
              ),
           //   const SizedBox(height: 30),
              // Body
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                        Text(
                          "We’re sorry to hear you want to cancel.\nPlease let us know why.",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            fontFamily: "poppins",
                            color: Color(0xFF000000),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50),
                        // Reason List
                        Card(
                          color: Colors.white,
                          child: Container(
                            height: 330,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    0.1,
                                  ),
                                  blurRadius: 4,
                                  offset: Offset(
                                    0,
                                    2,
                                  ), // Slight downward shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Column(
                                children: [
                                  Column(
                                    children:
                                    controller.reasons.map((reason) {
                                      return GestureDetector(
                                        onTap: () {
                                          controller.selectedReason.value =
                                              reason;
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Obx(
                                                    () => CustomDottedRadio(
                                                  isSelected:
                                                  controller
                                                      .selectedReason
                                                      .value ==
                                                      reason,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  reason,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: "poppins",
                                                    fontWeight:
                                                    FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      FocusScope.of(
                                        context,
                                      ).unfocus(); // This removes focus from TextField
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          // side: BorderSide(
                                          //   color: Color(0xFFAEC6F9),
                                          //   width: 1,
                                          // ),
                                        ),
                                        child: Container(
                                          height: 69,
                                          width: double.infinity,

                                          alignment: Alignment.topLeft,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 4,
                                                offset: Offset(
                                                  0,
                                                  2,
                                                ), // Slight downward shadow
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: TextField(
                                            maxLines: null,
                                            autofocus: false,
                                            textAlignVertical:
                                            TextAlignVertical.top,
                                            keyboardType: TextInputType.multiline,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Input text here",
                                              hintStyle: TextStyle(
                                                fontFamily: "poppins",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF9A9A9A),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        SizedBox(
                          height: 45,
                          width: 239,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF114BCA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Get.to(BookingCancelledView());
                              },
                            child: Text(
                              "Submit & Cancel Booking",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontFamily: "poppins",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // Other reason input
                        // Obx(() {
                        //   return controller.selectedReason.value ==
                        //           "Other (please specify)"
                        //       ? Padding(
                        //         padding: const EdgeInsets.only(top: 10),
                        //         child: TextField(
                        //           controller: controller.otherReasonController,
                        //           decoration: InputDecoration(
                        //             hintText: "Input text here",
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(8),
                        //             ),
                        //             contentPadding: const EdgeInsets.symmetric(
                        //               horizontal: 12,
                        //               vertical: 10,
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //       : const SizedBox();
                        // }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class CustomDottedRadio extends StatelessWidget {
  final bool isSelected;

  const CustomDottedRadio({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white, // Ensures background is white always
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(0xFF979797),
          width: 1.5,
          style: BorderStyle.solid, // Dotted not natively supported
        ),
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}