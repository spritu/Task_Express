import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/app/modules/chat/views/chat_view.dart';
import 'package:worknest/app/modules/completejob/views/completejob_view.dart';
import '../../../../colors.dart';
import '../../BookingConfirm/views/booking_confirm_view.dart';
import '../../ServiceCompleted/views/service_completed_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../../user_help/views/user_help_view.dart';
import '../controllers/booking_controller.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BookingController());
    return WillPopScope(
      onWillPop: () async {
        Get.find<BottomController>().selectedIndex.value = 0; // 👈 Home tab
        Get.offAll(() => BottomView());
        return false;
      },
      child: Obx(
        () => Stack(
          children: [
            Scaffold(
              body: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: AppColors.appGradient,
                ),
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return controller.hasBooking.value
                                      ? // If booking exists, show full booking details
                                      buildBookingCard()
                                      // Container(
                                      //   width: double.infinity,
                                      //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                                      //   decoration: BoxDecoration(
                                      //     color: const Color(0xFFD9E4FC),
                                      //     borderRadius: BorderRadius.circular(18),
                                      //   ),
                                      //   child: Column(
                                      //     crossAxisAlignment: CrossAxisAlignment.start,
                                      //     children: [
                                      //       /// Header Row: "Current Booking" + Help
                                      //       Row(
                                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //         children: [
                                      //           const Text(
                                      //             "Current Booking",
                                      //             style: TextStyle(
                                      //               fontSize: 14,
                                      //               fontWeight: FontWeight.w500,
                                      //               fontFamily: "poppins",
                                      //             ),
                                      //           ),
                                      //           InkWell(
                                      //             onTap: () => Get.to(UserHelpView()),
                                      //             child: const Text(
                                      //               "Help",
                                      //               style: TextStyle(
                                      //                 fontSize: 14,
                                      //                 fontWeight: FontWeight.w600,
                                      //                 color: Color(0xff114BCA),
                                      //                 fontFamily: "poppins",
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //       const SizedBox(height: 16),
                                      //       // Booking Card
                                      //       buildBookingCard(),
                                      //       const SizedBox(height: 9),
                                      //       // Info Bar
                                      //       buildChargeAndArrivalCard(),
                                      //       const SizedBox(height: 9),
                                      //       // Action Buttons: Cancel, Call, Chat
                                      //       buildActionButtons(controller),
                                      //       const SizedBox(height: 9),
                                      //       // Close Job & Pay
                                      //       buildCloseJobCard(),
                                      //     ],
                                      //   ),
                                      // )
                                      :
                                      // If no booking, show this small container
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD9E4FC),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                Card(
                                  color: Color(0xFFD9E4FC),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3,
                                      vertical: 15,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(width: 10),
                                            Text(
                                              "Past Bookings",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                fontFamily: "poppins",
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        // Obx(() {
                                        // if (controller.isLoading.value) {
                                        //   return Center(child: CircularProgressIndicator());
                                        // }
                                        //
                                        // if (controller.userList.isEmpty) {
                                        //   return Center(child: Text("No users found."));
                                        // }
                                        //
                                        // return SizedBox(height: 300,
                                        // child:
                                        ListView.builder(
                                          itemCount: controller.userList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            final item =
                                                controller.userList[index];
                                            print(
                                              "Image URL: https://jdapi.youthadda.co/${item.userImg}",
                                            );
                                            return Card(
                                              color: AppColors.white,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 4,
                                                    ),
                                                // padding: const EdgeInsets.all(12),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        /// Left Section - Text
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            /// Name
                                                            Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 25,
                                                                  backgroundImage:
                                                                      item.userImg !=
                                                                                  null &&
                                                                              item.userImg!.isNotEmpty
                                                                          ? NetworkImage(
                                                                            "https://jdapi.youthadda.co/${item.userImg}",
                                                                          )
                                                                          : AssetImage(
                                                                                "assets/images/account.png",
                                                                              )
                                                                              as ImageProvider,
                                                                  onBackgroundImageError: (
                                                                    _,
                                                                    __,
                                                                  ) {
                                                                    debugPrint(
                                                                      "Error loading image for user: ${item.userImg}",
                                                                    );
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  width: 4,
                                                                ),

                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "${item.bookedFor['firstName']} ${item.bookedFor['lastName']}",
                                                                      style: TextStyle(
                                                                        fontFamily:
                                                                            "poppins",
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 3,
                                                                    ),

                                                                    /// Subtitle
                                                                    RichText(
                                                                      text: TextSpan(
                                                                        style: TextStyle(
                                                                          fontFamily:
                                                                              "poppins",
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Colors.grey.shade600,
                                                                        ),
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                item.spType ==
                                                                                        '2'
                                                                                    ? "Fixed Charge Helper"
                                                                                    : "Visiting Professional",
                                                                          ),

                                                                          // const TextSpan(
                                                                          //   text:
                                                                          //   "Electrician",
                                                                          //   style: TextStyle(
                                                                          //     fontWeight:
                                                                          //     FontWeight.w400,
                                                                          //     fontSize:
                                                                          //     12,
                                                                          //     color: Color(
                                                                          //       0xFF114BCA,
                                                                          //     ), // Blue color
                                                                          //   ),
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),

                                                            const SizedBox(
                                                              height: 8,
                                                            ),

                                                            /// Booked (optional additional line)
                                                            RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Booked: ',
                                                                    style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400, // 400 = regular
                                                                      fontSize:
                                                                          11,

                                                                      letterSpacing:
                                                                          0,
                                                                      color:
                                                                          Colors
                                                                              .black,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: formatDate(
                                                                      item.jobStartTime,
                                                                    ),
                                                                    // text:
                                                                    // '${item.jobStartTime}',
                                                                    style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500, // 500 = medium
                                                                      fontSize:
                                                                          14,

                                                                      letterSpacing:
                                                                          0,
                                                                      color:
                                                                          Colors
                                                                              .black,
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
                                                                onPressed:
                                                                    () {},
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  elevation: 0,
                                                                  side: const BorderSide(
                                                                    color:
                                                                        Colors
                                                                            .black,
                                                                  ),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                ),
                                                                child: const Text(
                                                                  "Re-Book",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        "poppins",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color:
                                                                        Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),

                                                            /// Rate Service
                                                            SizedBox(
                                                              height: 32,
                                                              width: 85,
                                                              child: ElevatedButton(
                                                                onPressed: () {
                                                                  Get.to(
                                                                    ServiceCompletedView(),
                                                                  );
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  elevation: 0,
                                                                  side: const BorderSide(
                                                                    color: Color(
                                                                      0xFF114BCA,
                                                                    ),
                                                                  ),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                ),
                                                                child: const Text(
                                                                  "Rate Service ",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        "poppins",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color(
                                                                      0xFF114BCA,
                                                                    ),
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
                                                //));
                                                // },
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
            if (controller.showRequestPending.value)
              Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: RequestPendingBottomCard(
                    helperName: controller.helperName.value,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildBookingCard() => Obx(() {
    if (controller.isLoading.value) {
      return Center(child: CircularProgressIndicator());
    }

    if (controller.bookings.isEmpty) {
      return Center(child: Text("No bookings found."));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // Prevents scroll conflicts
      padding: EdgeInsets.all(12),
      itemCount: controller.bookings.length,
      itemBuilder: (context, index) {
        final booking = controller.bookings[index];
        final bookedBy = booking['bookedBy'] ?? {};
        final bookedFor = booking['bookedFor'] ?? {};
        final skills = bookedFor['skills'] ?? [];
        final accept = booking['accept'];
        final name = bookedFor['firstName'] ?? 'No Name';
        final type =
            'Fixed Charge Helper'; // Or use category/subcategory if needed
        final time = '10:45 am'; // If not dynamic, keep static
        final charge =
            skills.isNotEmpty ? (skills[0]['charge']?.toString() ?? '0') : '0';
        final arriveIn = '30 min'; // Change if ETA available
        final imageUrl =
            bookedFor['userImg'] ?? 'https://via.placeholder.com/150';
        final String? acceptStatus = booking['accept'];
        Color borderColor;

        if (accept == null) {
          borderColor = Colors.orange;
        } else if (accept.toString().toLowerCase() == 'yes') {
          borderColor = Colors.green;
        } else if (accept.toString().toLowerCase() == 'no') {
          borderColor = Colors.red;
        } else {
          borderColor = Colors.grey; // fallback
        }
        String statusText;

        if (accept == null) {
          borderColor = Colors.orange;
          statusText = 'Pending';
        } else if (accept.toString().toLowerCase() == 'yes') {
          borderColor = Colors.green;
          statusText = 'Accepted';
        } else if (accept.toString().toLowerCase() == 'no') {
          borderColor = Colors.red;
          statusText = 'Rejected';

          // Show dialog once when rejected
          // Future.delayed(Duration.zero, () {
          //   if (controller.showBookingCard.value) {
          //     Get.defaultDialog(
          //       title: "Booking Rejected",
          //       middleText: "Your booking was rejected by $name.",
          //       textConfirm: "OK",
          //       confirmTextColor: Colors.white,
          //       onConfirm: () {
          //         Get.back();
          //         controller.showBookingCard.value = false;
          //         controller.bookings.removeAt(index);
          //         // Close dialog
          //       },
          //     );
          //   }
          // });
        } else {
          borderColor = Colors.grey;
          statusText = 'Unknown';
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFD9E4FC),
              border: Border.all(color: borderColor, width: 4),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                    Text(
                      'Status: $statusText',
                      style: TextStyle(color: Colors.black, fontSize: 14),
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
                Container(
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
                        Container(
                          width: 73,
                          height: 73,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          clipBehavior: Clip.hardEdge,
                          child:
                              imageUrl.isNotEmpty
                                  ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/account.png',
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  )
                                  : Image.asset(
                                    'assets/images/account.png',
                                    fit: BoxFit.cover,
                                  ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "poppins",
                              ),
                            ),
                            const Text(
                              "Fixed Charge Helper",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: "poppins",
                                color: Color(0xFF575757),
                              ),
                            ),
                            const SizedBox(height: 15),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "poppins",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(text: "Booked: "),
                                  TextSpan(
                                    text: controller.formatCreatedAt(
                                      bookedBy['createdAt'],
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
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
                const SizedBox(height: 9),
                // Info Bar
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 4, color: Colors.grey.shade400),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(text: "Charge\n"),
                            TextSpan(
                              text: "₹ " + charge + " per day",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        color: Color(0xff746E6E),
                        thickness: 1,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
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
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 9),
                // Action Buttons: Cancel, Call, Chat
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 4, color: Colors.grey.shade400),
                    ],
                  ),
                  child: Row(
                    children: [
                      buildButton(
                        "Cancel Booking",
                        AppColors.white,
                        const Color(0xFF114BCA),
                        () => controller.rejectBooking(),
                      ),
                      buildButton(
                        "Call",
                        const Color(0xFF114BCA),
                        Colors.white,
                        () => controller.makePhoneCall("phoneNumber"),
                      ),
                      buildButton(
                        "Chat",
                        const Color(0xFF114BCA),
                        Colors.white,
                        () {
                          final receiverId = bookedFor['_id'];
                          final receiverName =
                              '${bookedFor['firstName'] ?? ''} ${bookedFor['lastName'] ?? ''}'
                                  .trim();
                          final receiverImage = bookedFor['userImg'] ?? '';
                          final phoneNumber = bookedFor['phone'] ?? '';
                          print('bookingChat: $receiverId');
                          print('bookingChat: $receiverName');

                          Get.to(
                            ChatView(),
                            arguments: {
                              'receiverId': receiverId,
                              'receiverName':
                                  receiverName.isNotEmpty
                                      ? receiverName
                                      : 'No Name',
                              'receiverImage': receiverImage,
                              'phoneNumber': phoneNumber,
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 9),
                // Close Job & Pay
                buildCloseJobCard(booking),
              ],
            ),
          ),
        );
      },
    );
  });

  Widget buildActionButtons(controller) => Container(
    height: 42,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      boxShadow: [BoxShadow(blurRadius: 4, color: Colors.grey.shade400)],
    ),
    child: Row(
      children: [
        buildButton(
          "Cancel Booking",
          AppColors.white,
          const Color(0xFF114BCA),
          () => controller.rejectBooking(),
        ),
        buildButton(
          "Call",
          const Color(0xFF114BCA),
          Colors.white,
          () => controller.makePhoneCall("phoneNumber"),
        ),
        buildButton(
          "Chat",
          const Color(0xFF114BCA),
          Colors.white,
          () => Get.to(ChatView()),
        ),
      ],
    ),
  );

  Widget buildButton(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: 28,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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

  Widget buildCloseJobCard(Map<String, dynamic> booking) {
    final accept = booking['accept'];

    // Only show the card if the booking is accepted
    if (accept != null && accept.toString().toLowerCase() == 'yes') {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Task finished? Tap ‘Close Job’ to complete the process and pay your worker.",
              style: TextStyle(
                fontFamily: "poppins",
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 160,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => CompletejobView(),
                      arguments: {'data': booking},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF114BCA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Close Job & Pay",
                    style: TextStyle(
                      fontSize: 13,
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
      );
    } else {
      return const SizedBox.shrink(); // Do not render anything if not accepted
    }
  }
}

class RequestPendingBottomCard extends StatelessWidget {
  final String helperName;

  const RequestPendingBottomCard({super.key, required this.helperName});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      InkWell(
                        onTap: () {
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
                                    final BottomController controller =
                                        Get.find<BottomController>();
                                    controller.cancelRequest();
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
                                    final BottomController controller =
                                        Get.find<BottomController>();
                                    controller.selectedIndex.value = 0;
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
    );
  }
}
