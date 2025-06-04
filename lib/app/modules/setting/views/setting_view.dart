import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:worknest/app/modules/booking/views/booking_view.dart';
import '../../../../colors.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingController());
    final bottomController = Get.put(BottomController());

    return WillPopScope(
      onWillPop: () async {
        bottomController.selectedIndex.value = 0;
        Get.offAll(() => BottomView());
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff4f7ff),
        appBar: AppBar(
          backgroundColor: const Color(0xfff4f7ff),
          elevation: 0,

          title: Text(
            "Notification",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: "poppins",
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                bottomController.notifications.clear(); // Optional: clear logic
              },
              child: const Text(
                "Clear All",
                style: TextStyle(
                  color: Color(0xff6055D8),
                  fontFamily: "poppins",
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: Obx(() {
          final notifications = bottomController.notifications;
          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                "No notifications yet.",
                style: TextStyle(fontSize: 14, fontFamily: "poppins"),
              ),
            );
          }

          return InkWell(
            onTap: () {
              Get.to(BookingView());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                final message = notif['message'] ?? "No message";
                final fullname =
                    "${notif['senderId']['firstName'] ?? ''} ${notif['senderId']['lastName'] ?? ''}";
                print("firstnamessss: $fullname");

                String formatDateTime(String dateTimeStr) {
                  try {
                    final dateTime =
                        DateTime.parse(
                          dateTimeStr,
                        ).toLocal(); // optional .toLocal()
                    return DateFormat(
                      "MMM d, yyyy 'at' h:mm a",
                    ).format(dateTime);
                  } catch (e) {
                    return "";
                  }
                }

                final formattedDate = formatDateTime(notif['createdAt'] ?? "");

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.notifications,
                          color: Color(0xff6055D8),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$message ",
                                style: TextStyle(
                                  fontFamily: "poppins",
                                  fontSize: 14,
                                  color: Color(0xff091C3F),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontFamily: "poppins",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1),
                    ),
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:get/get.dart';
// import '../../../../colors.dart';
// import '../../PrivacydataView/views/privacydata_view_view.dart';
// import '../../bottom/controllers/bottom_controller.dart';
// import '../../bottom/views/bottom_view.dart';
// import '../controllers/setting_controller.dart';
//
// class SettingView extends GetView<SettingController> {
//   const SettingView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     Get.put(SettingController());
//     final bottomController  = Get.put(BottomController());
//     return WillPopScope(
//       onWillPop: () async {
//         Get.find<BottomController>().selectedIndex.value = 0;
//         Get.offAll(() => BottomView());
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: const Color(0xfff4f7ff),
//         appBar: AppBar(
//           backgroundColor: const Color(0xfff4f7ff),
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: Center(
//             child: const Text(
//               "Notification",
//               style: TextStyle(
//                 color: Colors.black,fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: "poppins",
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {},
//               child: const Text(
//                 "Clear All",
//                 style: TextStyle(
//                   color: Color(0xff6055D8),
//                   fontFamily: "poppins",fontSize: 10,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: bottomController.notifications.length,
//           itemBuilder: (context, index) {
//            final notifictionData = bottomController.notifications.value,
//             return Column(
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.notifications,
//                       color: Color(0xff6055D8),
//                       size: 22,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "We know that—for children AND adults—learning is most effective when it is",
//                             style: TextStyle(
//                               fontFamily: "poppins",
//                               fontSize: 14,
//                               color: Color(0xff091C3F),
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           SizedBox(height: 6),
//                           Text(
//                             "Aug 12, 2020 at 12:08 PM",
//                             style: TextStyle(
//                               fontFamily: "poppins",
//                               fontSize: 13,fontWeight: FontWeight.w400,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   child: Divider(height: 1),
//                 ),
//               ],
//             );
//           },
//         ),
//
//       )
//     );
//   }
// }
//
//
