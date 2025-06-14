// import 'package:flutter/material.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:get/get.dart';
// import 'package:worknest/app/modules/Bottom2/views/bottom2_view.dart';
// import 'package:worknest/app/modules/jobs/views/jobs_view.dart';
//
// import '../../../../colors.dart';
// import '../../Activejob_screen/views/activejob_screen_view.dart';
// import '../../Bottom2/controllers/bottom2_controller.dart';
// import '../../YourEarning/views/your_earning_view.dart';
// import '../../provider_location/controllers/provider_location_controller.dart';
// import '../controllers/provider_home_controller.dart';
//
// class ProviderHomeView extends GetView<ProviderHomeController> {
//   const ProviderHomeView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final locationController = Get.find<ProviderLocationController>();
//     return Scaffold(
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(gradient: AppColors.appGradient2),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 30),
//                     const SizedBox(width: 8),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               'Current Address  ',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 12,
//                                 // color: AppColors.textColor,
//                               ),
//                             ),
//                             SizedBox(width: 5),
//                             Icon(Icons.keyboard_arrow_down_rounded, size: 20),
//                           ],
//                         ),
//                         Obx(() {
//                           return Text(
//                             locationController.currentAddress.value.isNotEmpty
//                                 ? locationController.currentAddress.value
//                                 : "Fetching current location...",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           );
//                         }),
//                       ],
//                     ),
//                     const Spacer(),
//                     Container(
//                       width: 30, // You can adjust size
//                       height: 30,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.transparent,
//                         border: Border.all(color: Colors.black, width: 1),
//                       ),
//                       child: const Center(
//                         child: Icon(
//                           Icons.notifications,
//                           color: Colors.black,
//                           size: 20,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//
//                 Container(
//                   height: 95,
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(14),
//                     color: Color(0xFFFCD8B7),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       // Available Switch Column
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             height: 46,
//                             width: 154,
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(14),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(color: Colors.black12, blurRadius: 4),
//                               ],
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   "Available",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                     fontFamily: "Poppins",
//                                   ),
//                                 ),
//                                 Obx(
//                                       () => FlutterSwitch(
//                                     width: 53.0,
//                                     height: 26.18,
//                                     toggleSize: 23.0,
//                                     value: controller.isAvailable.value,
//                                     borderRadius: 20.0,
//                                     activeColor: Colors.green,
//                                     inactiveColor: Colors.grey.shade400,
//                                     toggleColor: Colors.white,
//                                     padding: 1.0,
//                                     onToggle: (val) {
//                                       controller.isAvailable.value = val;
//                                       controller.updateAvailability(val);
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: Text(
//                               "Available or Not available",
//                               style: TextStyle(
//                                 fontSize: 9,
//                                 fontFamily: "Poppins",
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               textAlign: TextAlign.start,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(width: 2),
//                       // Service Profile Switch Column
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             height: 46,
//                             width: 154,
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(14),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(color: Colors.black12, blurRadius: 4),
//                               ],
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   "Service\n Profile",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                     fontFamily: "Poppins",
//                                   ),
//                                 ),
//                                 Obx(
//                                       () => FlutterSwitch(
//                                     width: 53.0,
//                                     height: 26.18,
//                                     toggleSize: 23.0,
//                                     value: controller.isServiceProfile.value,
//                                     borderRadius: 20.0,
//                                     activeColor: Colors.orange,
//                                     inactiveColor: Colors.grey.shade400,
//                                     padding: 1.0,
//                                     onToggle: (val) {
//                                       controller.isServiceProfile.value = val;
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           InkWell(
//                             onTap: () {
//                               Get.to(ActivejobScreenView());
//                             },
//                             child: const Text(
//                               "Service profile or User profile",
//                               style: TextStyle(
//                                 fontSize: 9,
//                                 fontFamily: "Poppins",
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//
//                 Container(
//                   height: 54,
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 5,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: const Color(0xFFFCD8B7),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Obx(
//                             () => Text(
//                           "Hello ${controller.firstName.value}",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                             fontFamily: "Poppins",
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 2),
//                       RichText(
//                         text: TextSpan(
//                           style: const TextStyle(
//                             fontFamily: "Poppins",
//                             fontSize: 12,
//                             color: Colors.black54,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           children: [
//                             const TextSpan(text: "You’re "),
//                             const TextSpan(
//                               text: "Online",
//                               style: TextStyle(
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: "poppins",
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Job Request",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: "poppins",
//                             color: Color(0xFFF67C0A),
//                           ),
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width,
//                           child: Obx(() {
//                             if (controller.isLoading.value) {
//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }
//
//                             var bookingList = controller.bookingDataList;
//
//                             if (bookingList.isEmpty) {
//                               return const Center(
//                                 child: Text("No current booking"),
//                               );
//                             }
//
//                             return ListView.builder(
//                               itemCount: bookingList.length,
//                               physics: NeverScrollableScrollPhysics(),
//                               scrollDirection: Axis.vertical,
//                               shrinkWrap: true,
//                               itemBuilder: (context, index) {
//                                 final booking = bookingList[index];
//
//                                 final bookedBy = booking['bookedBy'] ?? {};
//                                 final firstName =
//                                     bookedBy['firstName']?.toString() ??
//                                         'Unknown';
//                                 final lastName =
//                                     bookedBy['lastName']?.toString() ?? '';
//                                 final city =
//                                     bookedBy['city']?.toString() ?? 'No city';
//
//                                 final bookServices =
//                                     booking['bookServices'] ?? [];
//                                 final serviceName =
//                                 bookServices.isNotEmpty
//                                     ? bookServices[0]['name']?.toString() ??
//                                     'Service'
//                                     : 'Service';
//
//                                 final earning =
//                                     booking['earning']?.toString() ?? '0';
//                                 final duration =
//                                     booking['duration']?.toString() ?? '--';
//                                 print('Booking index: $index');
//                                 print('First name: $firstName');
//                                 print('Last name: $lastName');
//                                 return Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Card(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     elevation: 4,
//                                     child: Container(
//                                       width:
//                                       MediaQuery.of(context).size.width *
//                                           0.9,
//                                       padding: const EdgeInsets.all(10),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(12),
//                                         color: Colors.white,
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           // Top Row
//                                           Row(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               // Left Column
//                                               Expanded(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         const Icon(
//                                                           Icons.person,
//                                                           size: 16,
//                                                           color: Colors.grey,
//                                                         ),
//                                                         const SizedBox(
//                                                           width: 4,
//                                                         ),
//                                                         Text(
//                                                           "$firstName $lastName",
//                                                           style:
//                                                           const TextStyle(
//                                                             fontFamily:
//                                                             "Poppins",
//                                                             fontWeight:
//                                                             FontWeight
//                                                                 .w500,
//                                                             fontSize: 12,
//                                                             color: Color(
//                                                               0xFF7A7A7A,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     const SizedBox(height: 6),
//                                                     Row(
//                                                       crossAxisAlignment:
//                                                       CrossAxisAlignment
//                                                           .start,
//                                                       children: [
//                                                         const Icon(
//                                                           Icons.location_on,
//                                                           size: 16,
//                                                           color: Colors.black,
//                                                         ),
//                                                         const SizedBox(
//                                                           width: 4,
//                                                         ),
//                                                         Expanded(
//                                                           child: Text(
//                                                             city,
//                                                             style:
//                                                             const TextStyle(
//                                                               fontFamily:
//                                                               "Poppins",
//                                                               fontWeight:
//                                                               FontWeight
//                                                                   .w600,
//                                                               fontSize: 13,
//                                                               color:
//                                                               Colors
//                                                                   .black,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     const SizedBox(height: 4),
//                                                     const Padding(
//                                                       padding: EdgeInsets.only(
//                                                         left: 20,
//                                                       ),
//                                                       child: Text(
//                                                         "3.5 km, 28 min to reach",
//                                                         style: TextStyle(
//                                                           fontFamily: "Poppins",
//                                                           fontWeight:
//                                                           FontWeight.w600,
//                                                           fontSize: 12,
//                                                           color: Color(
//                                                             0xFFF67C0A,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     const SizedBox(height: 8),
//                                                     Row(
//                                                       children: [
//                                                         const Icon(
//                                                           Icons.check_box,
//                                                           size: 16,
//                                                           color: Colors.black45,
//                                                         ),
//                                                         const SizedBox(
//                                                           width: 4,
//                                                         ),
//                                                         Text(
//                                                           serviceName,
//                                                           style:
//                                                           const TextStyle(
//                                                             fontFamily:
//                                                             "Poppins",
//                                                             fontWeight:
//                                                             FontWeight
//                                                                 .w500,
//                                                             fontSize: 12,
//                                                             color: Color(
//                                                               0xFF7A7A7A,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               // Right Column (Earning + Duration)
//                                               Column(
//                                                 children: [
//                                                   _infoCard(
//                                                     title: "Earning",
//                                                     value: "₹$earning",
//                                                   ),
//                                                   const SizedBox(height: 8),
//                                                   _infoCard(
//                                                     title: "Duration",
//                                                     value: "$duration Hrs",
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 20),
//                                           // Action Buttons
//                                           Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               _actionButton(
//                                                 "Reject",
//                                                 Colors.white,
//                                                 const Color(0xFFF67C0A),
//                                                 textColor: const Color(
//                                                   0xFFF67C0A,
//                                                 ),
//                                                 onTap: () {
//                                                   Get.defaultDialog(
//                                                     title: "Confirmation",
//                                                     middleText:
//                                                     "Are you sure you want to reject?",
//                                                     textConfirm: "Yes",
//                                                     textCancel: "Back",
//                                                     confirmTextColor:
//                                                     Colors.white,
//                                                     cancelTextColor:
//                                                     Colors.black,
//                                                     buttonColor: const Color(
//                                                       0xFFF67C0A,
//                                                     ),
//                                                     onConfirm: () {
//                                                       Get.back(); // Close dialog
//                                                       controller
//                                                           .updateBookingStatus(
//                                                         acceptStatus: "no",
//                                                       );
//                                                       controller
//                                                           .fetchCurrentBooking();
//                                                     },
//                                                     onCancel: () {
//                                                       Get.back(); // Just close dialog
//                                                     },
//                                                   );
//                                                 },
//                                               ),
//
//                                               _actionButton(
//                                                 "Call",
//                                                 const Color(0xFFF67C0A),
//                                                 Colors.white,
//                                                 onTap: controller.makePhoneCall,
//                                               ),
//
//                                               _actionButton(
//                                                 "Accept",
//                                                 const Color(0xFFF67C0A),
//                                                 Colors.white,
//                                                 onTap: () {
//                                                   Get.defaultDialog(
//                                                     title: "Confirmation",
//                                                     middleText:
//                                                     "Are you sure you want to accept?",
//                                                     textConfirm: "Yes",
//                                                     textCancel: "Back",
//                                                     confirmTextColor:
//                                                     Colors.white,
//                                                     cancelTextColor:
//                                                     Colors.black,
//                                                     buttonColor: const Color(
//                                                       0xFFF67C0A,
//                                                     ),
//                                                     onConfirm: () {
//                                                       // Set the selected index in Bottom2Controller before navigation
//                                                       final bottomController =
//                                                       Get.put(
//                                                         Bottom2Controller(),
//                                                       );
//                                                       bottomController
//                                                           .selectedIndex
//                                                           .value = 1;
//                                                       Get.to(
//                                                         Bottom2View(),
//                                                       ); // Close the dialog first
//                                                       controller
//                                                           .updateBookingStatus(
//                                                         acceptStatus: "yes",
//                                                       );
//                                                       controller
//                                                           .fetchCurrentBooking();
//                                                     },
//                                                     onCancel: () {
//                                                       Get.back(); // Just close the dialog
//                                                     },
//                                                   );
//                                                 },
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           }),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           "Today’s Dashboard",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: "poppins",
//                             color: Color(0xFFF67C0A),
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: _dashboardCard(
//                                     title: "Today's\n Jobs",
//                                     value: "2",
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: _dashboardCard(
//                                     title: "Earnings\n Today",
//                                     value: "₹750",
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: _dashboardCard(
//                                     title: " Hour’s\nWorked",
//                                     value: "5",
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: _dashboardCard(
//                                     title: "Average\n Rating",
//                                     value: "4.7",
//                                     icon: Icons.star,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           "Your Earnings",
//                           style: TextStyle(
//                             fontFamily: "poppins",
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                             color: Color(0xFFF67C0A),
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         InkWell(
//                           onTap: () {
//                             Get.to(YourEarningView());
//                           },
//                           child: Card(
//                             color: Colors.white,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 _earningsCard(
//                                   title: "This Week",
//                                   amount: "₹2450",
//                                 ),
//                                 _earningsCard(
//                                   title: "This Month",
//                                   amount: "₹8450",
//                                 ),
//                                 _earningsCard(
//                                   title: "Total",
//                                   amount: "₹34,450",
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           "Recent Jobs",
//                           style: TextStyle(
//                             fontFamily: "poppins",
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                             color: Color(0xFFF67C0A),
//                           ),
//                         ),
//                         SizedBox(height: 10),
//
//                         // Card List Container
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.grey.shade300),
//                           ),
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: 5, // or your dynamic length
//                             padding: const EdgeInsets.symmetric(horizontal: 0),
//                             physics: BouncingScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               return Column(
//                                 children: [
//                                   _jobItem(),
//                                   if (index != 4) // itemCount - 1
//                                     Divider(
//                                       color: Colors.grey.shade300,
//                                       height: 1,
//                                     ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//
//                         const SizedBox(height: 8),
//
//                         // Round orange border button (no icon inside per image)
//                         InkWell(
//                           onTap: () {
//                             Get.to(ActivejobScreenView());
//                           },
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child: Container(
//                               height: 28,
//                               width: 80,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: Color(0xFFF67C0A),
//                                   width: 1,
//                                 ),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "View More", // or any text you want
//                                   style: TextStyle(
//                                     fontFamily: "Poppins",
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _infoCard({required String title, required String value}) {
//     return Container(
//       height: 43,
//       width: 82,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF7A7A7A),
//               fontFamily: "Poppins",
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w700,
//               color: Colors.black,
//               fontFamily: "Poppins",
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _actionButton(
//       String text,
//       Color bgColor,
//       Color borderColor, {
//         Color? textColor,
//         VoidCallback? onTap, // <-- Add this line
//       }) {
//     return GestureDetector(
//       onTap: onTap, // <-- Add this line
//       child: Container(
//         height: 30,
//         width: 95,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: borderColor),
//         ),
//         alignment: Alignment.center,
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontFamily: "Poppins",
//               fontWeight: FontWeight.w500,
//               fontSize: 12,
//               color: textColor ?? Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _earningsCard({required String title, required String amount}) {
//     return Expanded(
//       child: Container(
//         height: 119,
//         margin: EdgeInsets.symmetric(horizontal: 6),
//         padding: EdgeInsets.symmetric(vertical: 12),
//
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontFamily: "Poppins",
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//               ),
//             ),
//             SizedBox(height: 4),
//             Container(
//               height: 0.8,
//               width: 53,
//               color: Color(0xFF7B7B7B),
//               margin: EdgeInsets.symmetric(vertical: 4),
//             ),
//             Text(
//               amount,
//               style: TextStyle(
//                 fontFamily: "Poppins",
//                 fontWeight: FontWeight.w700,
//                 fontSize: 14,
//                 color: Color(0xFFF67C0A),
//               ),
//             ),
//             SizedBox(height: 15),
//             // Details button
//             Container(
//               height: 24,
//               width: 54,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Color(0xFFF67C0A)),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Center(
//                 child: Text(
//                   "Details",
//                   style: TextStyle(
//                     fontFamily: "Poppins",
//                     fontSize: 10,
//
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _jobItem() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       child: Row(
//         children: [
//           // Job details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   "Plumbing job",
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     fontFamily: "Poppins",
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   "Pipe Repair",
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     fontFamily: "Poppins",
//                     color: Color(0xFFF67C0A),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Amount
//           const Text(
//             "₹8450",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               fontFamily: "Poppins",
//               color: Color(0xFFF67C0A),
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           // Date
//           const Text(
//             "10 Apr 2025",
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//               fontFamily: "Poppins",
//               color: Color(0xFF1F1F1F),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// Widget _infoCard({required String title, required String value}) {
//   return Container(
//     height: 43,
//     width: 82,
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10),
//       boxShadow: [
//         BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
//       ],
//     ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF7A7A7A),
//             fontFamily: "Poppins",
//           ),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w700,
//             color: Colors.black,
//             fontFamily: "Poppins",
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _actionButton(
//     String text,
//     Color bgColor,
//     Color borderColor, {
//       Color? textColor,
//     }) {
//   return Container(
//     height: 30,
//     width: 105,
//     decoration: BoxDecoration(
//       color: bgColor,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: borderColor),
//     ),
//     alignment: Alignment.center,
//     child: Center(
//       child: Text(
//         text,
//         style: TextStyle(
//           fontFamily: "Poppins",
//           fontWeight: FontWeight.w500,
//           fontSize: 12,
//           color: textColor ?? Colors.white,
//         ),
//       ),
//     ),
//   );
// }
//
// Widget _dashboardCard({
//   required String title,
//   required String value,
//   Color valueColor = const Color(0xFFE66800),
//   IconData? icon,
// }) {
//   return Container(
//     height: 56,
//     width: 162,
//     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: Colors.grey.shade300),
//       boxShadow: [
//         BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
//       ],
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Title
//         Flexible(
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               fontFamily: "Poppins",
//               color: Colors.black,
//             ),
//           ),
//         ),
//
//         // Divider
//         Container(
//           height: 24,
//           width: 1,
//           color: Color(0xff7b7b7b),
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//         ),
//
//         // Value (with optional icon)
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (icon != null) Icon(icon, size: 16, color: Colors.amber),
//             if (icon != null) const SizedBox(width: 4),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 fontFamily: "Poppins",
//                 color: valueColor,
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:worknest/app/modules/Bottom2/views/bottom2_view.dart';
import 'package:worknest/app/modules/jobs/views/jobs_view.dart';

import '../../../../colors.dart';
import '../../Activejob_screen/views/activejob_screen_view.dart';
import '../../Bottom2/controllers/bottom2_controller.dart';
import '../../YourEarning/views/your_earning_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../provider_location/controllers/provider_location_controller.dart';
import '../controllers/provider_home_controller.dart';

class ProviderHomeView extends GetView<ProviderHomeController> {
  const ProviderHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ProviderHomeController(), permanent: true).fetchDashboardData();
    final locationController = Get.find<ProviderLocationController>();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: AppColors.appGradient2),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 30),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Current Address  ',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                // color: AppColors.textColor,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                          ],
                        ),
                        Obx(() {
                          return Text(
                            locationController.currentAddress.value.isNotEmpty
                                ? locationController.currentAddress.value
                                : "Fetching current location...",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }),
                      ],
                    ),
                    const Spacer(),
                    // Container(
                    //   width: 30,
                    //   height: 30,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: Colors.transparent,
                    //     border: Border.all(color: Colors.black, width: 1),
                    //   ),
                    //   child: InkWell(
                    //     borderRadius: BorderRadius.circular(15),
                    //     onTap: () {
                    //       final userBottomController = Get.put(
                    //         BottomController(),
                    //       );
                    //       userBottomController.fetchNotifications();
                    //     },
                    //     child: Center(
                    //       child: Icon(
                    //         Icons.notifications,
                    //         color: Colors.black,
                    //         size: 18, // Slightly smaller for better fit
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 10),

                Container(
                  height: 95,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Color(0xFFFCD8B7),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Available Switch Column
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 46,
                            width: 154,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 4),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Available",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                Obx(
                                  () => IgnorePointer(
                                    ignoring:
                                        !controller
                                            .canToggleAvailability
                                            .value, // disable jab false ho
                                    child: FlutterSwitch(
                                      width: 53.0,
                                      height: 26.18,
                                      toggleSize: 23.0,
                                      value: controller.isAvailable.value,
                                      borderRadius: 20.0,
                                      activeColor: Colors.green,
                                      inactiveColor: Colors.grey.shade400,
                                      toggleColor: Colors.white,
                                      padding: 1.0,
                                      onToggle: (val) {
                                        controller.isAvailable.value = val;
                                        controller.updateAvailability(val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Available or Not available",
                              style: TextStyle(
                                fontSize: 9,
                                fontFamily: "Poppins",
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 2),
                      // Service Profile Switch Column
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 46,
                            width: 154,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 4),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "User\n Profile",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                Obx(
                                  () => FlutterSwitch(
                                    width: 53.0,
                                    height: 26.18,
                                    toggleSize: 23.0,
                                    value: controller.isServiceProfile.value,
                                    borderRadius: 20.0,
                                    activeColor: Colors.orange,
                                    inactiveColor: Colors.grey.shade400,
                                    padding: 1.0,
                                    onToggle: (val) async {
                                      if (val) {
                                        await Get.toNamed(
                                          '/bottom',
                                          arguments: {
                                            'firstName':
                                                controller.firstName.value,
                                            'houseNo': controller.houseNo.value,
                                            'landMark':
                                                controller.landMark.value,
                                            'skills': controller.skills.value,
                                            'charge': controller.charge.value,
                                          },
                                        );

                                        // Always reset to OFF
                                        controller.isAvailable.value = false;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () {
                              Get.to(ActivejobScreenView());
                            },
                            child: const Text(
                              "Service profile or User profile",
                              style: TextStyle(
                                fontSize: 9,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  height: 54,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFFCD8B7),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => Text(
                              "Hello ${controller.firstName.value}",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),

                          const SizedBox(height: 2),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(text: "You’re "),
                                TextSpan(
                                  text: "Online",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "poppins",
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Obx(() {
                        if (controller.bookingDataList.isEmpty) {
                          return SizedBox(); // Return empty widget if no booking
                        }
                        return InkWell(
                          onTap: () {
                            Get.to(
                              ActivejobScreenView(),
                              arguments: {
                                "bookingData": controller.bookingDataList,
                                "dashboardData": controller.dashboardData,
                                "pastbookings": controller.pastBookings,
                                "firstName": controller.firstName,
                              },
                            );
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: 28,
                              width: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFF67C0A),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "View Map", // or any text you want
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Job Request",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "poppins",
                            color: Color(0xFFF67C0A),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Obx(() {
                            if (controller.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            var bookingList = controller.bookingDataList;

                            if (bookingList.isEmpty) {
                              return const Center(
                                child: Text("No current booking"),
                              );
                            }

                            return ListView.builder(
                              itemCount: bookingList.length,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final booking = bookingList[index];

                                final bookedBy = booking['bookedBy'] ?? {};
                                final firstName =
                                    bookedBy['firstName']?.toString() ??
                                    'Unknown';
                                final lastName =
                                    bookedBy['lastName']?.toString() ?? '';
                                final city =
                                    bookedBy['city']?.toString() ?? 'No city';

                                final bookServices =
                                    booking['bookServices'] ?? [];
                                final serviceName =
                                    bookServices.isNotEmpty
                                        ? bookServices[0]['name']?.toString() ??
                                            'Service'
                                        : 'Service';

                                final earning =
                                    booking['earning']?.toString() ?? '0';
                                final duration =
                                    booking['duration']?.toString() ?? '--';
                                print('Booking index: $index');
                                print('First name: $firstName');
                                print('Last name: $lastName');
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.9,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Top Row
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Left Column
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.person,
                                                          size: 16,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "$firstName $lastName",
                                                          style:
                                                              const TextStyle(
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12,
                                                                color: Color(
                                                                  0xFF7A7A7A,
                                                                ),
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(
                                                          Icons.location_on,
                                                          size: 16,
                                                          color: Colors.black,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            city,
                                                            style:
                                                                const TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 13,
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 20,
                                                      ),
                                                      child: Text(
                                                        "3.5 km, 28 min to reach",
                                                        style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                          color: Color(
                                                            0xFFF67C0A,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.check_box,
                                                          size: 16,
                                                          color: Colors.black45,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "Assigned for : $serviceName",
                                                          style:
                                                              const TextStyle(
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12,
                                                                color: Color(
                                                                  0xFF7A7A7A,
                                                                ),
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Right Column (Earning + Duration)
                                              Column(
                                                children: [
                                                  _infoCard(
                                                    title: "Earning",
                                                    value: "₹$earning",
                                                  ),
                                                  const SizedBox(height: 8),
                                                  _infoCard(
                                                    title: "Duration",
                                                    value: "$duration Hrs",
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          // Action Buttons
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              _actionButton(
                                                "Reject",
                                                Colors.white,
                                                const Color(0xFFF67C0A),
                                                textColor: const Color(
                                                  0xFFF67C0A,
                                                ),
                                                onTap: () {
                                                  Get.defaultDialog(
                                                    title: "Confirmation",
                                                    middleText:
                                                        "Are you sure you want to reject?",
                                                    textConfirm: "Yes",
                                                    textCancel: "Back",
                                                    confirmTextColor:
                                                        Colors.white,
                                                    cancelTextColor:
                                                        Colors.black,
                                                    buttonColor: const Color(
                                                      0xFFF67C0A,
                                                    ),
                                                    onConfirm: () async {
                                                      Get.back();
                                                      controller
                                                          .isLoading
                                                          .value = true;
                                                      await controller
                                                          .updateBookingStatus(
                                                            acceptStatus: "no",
                                                          ); // Close dialog
                                                      controller.bookingDataList
                                                          .clear();
                                                      controller
                                                          .connectSocketReject();
                                                      controller
                                                          .isLoading
                                                          .value = false;

                                                      await controller
                                                          .fetchCurrentBooking();
                                                    },
                                                    onCancel: () {
                                                      Get.back(); // Just close dialog
                                                    },
                                                  );
                                                },
                                              ),

                                              _actionButton(
                                                "Call",
                                                const Color(0xFFF67C0A),
                                                Colors.white,
                                                onTap:
                                                    controller
                                                        .makePhoneCallFromSharedPrefs, // Replace with dynamic number
                                              ),

                                              _actionButton(
                                                "Accept",
                                                const Color(0xFFF67C0A),
                                                Colors.white,
                                                onTap: () {
                                                  Get.defaultDialog(
                                                    title: "Confirmation",
                                                    middleText:
                                                        "Are you sure you want to accept?",
                                                    textConfirm: "Yes",
                                                    textCancel: "Back",
                                                    confirmTextColor:
                                                        Colors.white,
                                                    cancelTextColor:
                                                        Colors.black,
                                                    buttonColor: const Color(
                                                      0xFFF67C0A,
                                                    ),
                                                    onConfirm: () {
                                                      Get.back();
                                                      bookingList.clear();

                                                      final bottomController =
                                                          Get.put(
                                                            Bottom2Controller(),
                                                          );
                                                      bottomController
                                                          .selectedIndex
                                                          .value = 1;
                                                      Get.to(
                                                        Bottom2View(),
                                                      ); // Close the dialog first
                                                      controller
                                                          .disableAvailabilityUntilPayment();
                                                      controller
                                                          .updateBookingStatus(
                                                            acceptStatus: "yes",
                                                          );
                                                      controller
                                                          .fetchCurrentBooking();
                                                      controller
                                                          .connectSocketAccept();
                                                    },
                                                    onCancel: () {
                                                      Get.back(); // Just close the dialog
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Today’s Dashboard",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "poppins",
                            color: Color(0xFFF67C0A),
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(() {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _dashboardCard(
                                      title: "Today's\n Jobs",
                                      value:
                                          controller.dashboardData['todayJobs']
                                              .toString(),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _dashboardCard(
                                      title: "Earnings\n Today",
                                      value:
                                          "₹${controller.dashboardData['todayEarnings'].toString()}",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _dashboardCard(
                                      title: " Hour’s\nWorked",
                                      value:
                                          controller
                                              .dashboardData['todayHoursWorked']
                                              .toString(),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _dashboardCard(
                                      title: "Average\n Rating",
                                      value:
                                          controller
                                              .dashboardData['averageRating']
                                              .toString(),
                                      icon: Icons.star,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                        SizedBox(height: 10),
                        Text(
                          "Your Earnings",
                          style: TextStyle(
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFFF67C0A),
                          ),
                        ),
                        SizedBox(height: 5),
                        Obx(() {
                          return Card(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _earningsCard(
                                  title: "This Week",
                                  amount:
                                      "₹${controller.dashboardData['weekEarnings'].toString()}",
                                  filter: 'week',
                                ),
                                _earningsCard(
                                  title: "This Month",
                                  amount:
                                      "₹${controller.dashboardData['monthEarnings'].toString()}",
                                  filter: 'month',
                                ),
                                _earningsCard(
                                  title: "Total",
                                  amount:
                                      "₹${controller.dashboardData['totalEarnings'].toString()}",
                                  filter: 'all',
                                ),
                              ],
                            ),
                          );
                        }),
                        SizedBox(height: 10),
                        Text(
                          "Recent Jobs",
                          style: TextStyle(
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFFF67C0A),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Card List Container
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Obx(() {
                            int itemCount =
                                controller.showAllPastBookings.value
                                    ? controller.pastBookings.length
                                    : controller.pastBookings.length > 3
                                    ? 3
                                    : controller.pastBookings.length;

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: itemCount,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final booking = controller.pastBookings[index];

                                final serviceName =
                                    booking['bookServices'] != null &&
                                            booking['bookServices'] is List &&
                                            booking['bookServices'].isNotEmpty
                                        ? booking['bookServices'][0]['name'] ??
                                            'N/A'
                                        : 'N/A';

                                final jobStartTimeStr = booking['jobStartTime'];
                                final jobStartTime =
                                    jobStartTimeStr != null
                                        ? DateTime.tryParse(jobStartTimeStr)
                                        : null;
                                final pay = booking['pay'];

                                return Column(
                                  children: [
                                    _jobItem(
                                      serviceName: serviceName,
                                      pay:
                                          pay, // Replace with actual field if available
                                      date:
                                          jobStartTime != null
                                              ? DateFormat(
                                                'dd MMM yyyy',
                                              ).format(jobStartTime)
                                              : 'N/A',
                                    ),
                                    if (index !=
                                        controller.pastBookings.length - 1)
                                      Divider(
                                        color: Colors.grey.shade300,
                                        height: 1,
                                      ),
                                  ],
                                );
                              },
                            );
                          }),
                        ),

                        const SizedBox(height: 8),

                        // Round orange border button (no icon inside per image)
                        Obx(() {
                          if (controller.pastBookings.length <= 3) {
                            return SizedBox();
                          }
                          return InkWell(
                            onTap: () {
                              controller.showAllPastBookings.value =
                                  !controller.showAllPastBookings.value;
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 28,
                                width: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFF67C0A),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "View More", // or any text you want
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 30),
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

  Widget _infoCard({required String title, required String value}) {
    return Container(
      height: 43,
      width: 82,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7A7A7A),
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    String text,
    Color bgColor,
    Color borderColor, {
    Color? textColor,
    VoidCallback? onTap, // <-- Add this line
  }) {
    return GestureDetector(
      onTap: onTap, // <-- Add this line
      child: Container(
        height: 30,
        width: 95,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        alignment: Alignment.center,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: textColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _earningsCard({
    required String title,
    required String amount,
    required String filter, // 👈 add this
  }) {
    return Expanded(
      child: Container(
        height: 119,
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Container(
              height: 0.8,
              width: 53,
              color: Color(0xFF7B7B7B),
              margin: EdgeInsets.symmetric(vertical: 4),
            ),
            Text(
              amount,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFFF67C0A),
              ),
            ),
            SizedBox(height: 15),
            // Details button
            InkWell(
              onTap: () {
                // ✅ Pass filter as argument
                Get.to(() => YourEarningView(), arguments: {'filter': filter});
              },
              child: Container(
                height: 24,
                width: 54,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFF67C0A)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Details",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobItem({
    required String serviceName,
    required int pay,
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          // Job details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Past Booking",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    color: Color(0xFFF67C0A),
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            "₹$pay",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
              color: Color(0xFFF67C0A),
            ),
          ),

          const SizedBox(width: 12),

          // Date
          Text(
            date,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Color(0xFF1F1F1F),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _infoCard({required String title, required String value}) {
  return Container(
    height: 43,
    width: 82,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7A7A7A),
            fontFamily: "Poppins",
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: "Poppins",
          ),
        ),
      ],
    ),
  );
}

Widget _actionButton(
  String text,
  Color bgColor,
  Color borderColor, {
  Color? textColor,
}) {
  return Container(
    height: 30,
    width: 105,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: borderColor),
    ),
    alignment: Alignment.center,
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: textColor ?? Colors.white,
        ),
      ),
    ),
  );
}

Widget _dashboardCard({
  required String title,
  required String value,
  Color valueColor = const Color(0xFFE66800),
  IconData? icon,
}) {
  return Container(
    height: 56,
    width: 162,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
        Flexible(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Colors.black,
            ),
          ),
        ),

        // Divider
        Container(
          height: 24,
          width: 1,
          color: Color(0xff7b7b7b),
          margin: const EdgeInsets.symmetric(horizontal: 10),
        ),

        // Value (with optional icon)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 16, color: Colors.amber),
            if (icon != null) const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: "Poppins",
                color: valueColor,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
