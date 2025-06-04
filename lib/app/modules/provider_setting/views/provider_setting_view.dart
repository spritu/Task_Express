import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Bottom2/controllers/bottom2_controller.dart';
import '../../Bottom2/views/bottom2_view.dart';
import '../controllers/provider_setting_controller.dart';

class ProviderSettingView extends GetView<ProviderSettingController> {
  const ProviderSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProviderSettingController());
    final bottom2Controller = Get.put(Bottom2Controller());

    return WillPopScope(
      onWillPop: () async {
        Get.find<Bottom2Controller>().selectedIndex.value = 0;
        Get.offAll(() => Bottom2View());
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xfff4f7ff),
        appBar: AppBar(
          backgroundColor: const Color(0xfff4f7ff),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Get.back();
            },
          ),
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
                bottom2Controller.globalNotifications
                    .clear(); // Optional: clear logic
              },
              child: Text(
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
          final notifications = bottom2Controller.globalNotifications;
          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                "No notifications yet.",
                style: TextStyle(fontSize: 14, fontFamily: "poppins"),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              final message = notif['message'] ?? "No message";
              final fullname =
                  "${notif['userId']['firstName'] ?? ''} ${notif['userId']['lastName'] ?? ''}";
              print("ccvvvxxx: $fullname");

              String formatDateTime(String dateTimeStr) {
                try {
                  final dateTime =
                      DateTime.parse(
                        dateTimeStr,
                      ).toLocal(); // optional .toLocal()
                  return DateFormat("MMM d, yyyy 'at' h:mm a").format(dateTime);
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
                        color: Color(0xFFF67C0A),
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$message By $fullname",
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
// import '../../Bottom2/controllers/bottom2_controller.dart';
// import '../../Bottom2/views/bottom2_view.dart';
// import '../controllers/provider_setting_controller.dart';
//
// class ProviderSettingView extends GetView<ProviderSettingController> {
//   const ProviderSettingView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Get.put(ProviderSettingController());
//     return WillPopScope(
//       onWillPop: () async {
//         Get.find<Bottom2Controller>().selectedIndex.value = 0;
//         Get.offAll(() => Bottom2View());
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Container(
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(gradient: AppColors.appGradient2),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: 40),
//                 Text(
//                   "Settings",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontFamily: "poppins",
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 12, right: 12),
//                   child: Card(
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: 56,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 12, right: 12),
//                             child: Row(
//                               children: [
//                                 Image.asset(
//                                   "assets/images/moon.png",
//                                   color: AppColors.textColor,
//                                 ),
//                                 SizedBox(width: 20),
//                                 Text(
//                                   "Dark mode",
//                                   style: TextStyle(
//                                     fontFamily: "poppins",
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Obx(
//                                   () => FlutterSwitch(
//                                     width: 33.0,
//                                     height: 18.0,
//                                     toggleSize: 21.0,
//                                     value: controller.isDarkMode.value,
//                                     borderRadius: 30.0,
//                                     padding: 1,
//                                     activeColor: AppColors.orage,
//                                     inactiveColor: AppColors.grey,
//                                     onToggle: (val) {
//                                       controller.toggleTheme();
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Divider(thickness: 1),
//                         SizedBox(
//                           height: 56,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 12, right: 12),
//                             child: Row(
//                               children: [
//                                 Image.asset("assets/images/msg.png"),
//                                 SizedBox(width: 20),
//                                 Text(
//                                   "Updates on SMS",
//                                   style: TextStyle(
//                                     fontFamily: "poppins",
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Obx(
//                                   () => FlutterSwitch(
//                                     width: 33.0,
//                                     height: 18.0,
//                                     toggleSize: 21.0,
//                                     value: controller.isSmsUpdates.value,
//                                     borderRadius: 30.0,
//                                     padding: 1.0,
//                                     activeColor: AppColors.orage,
//                                     inactiveColor: AppColors.grey,
//                                     onToggle: (val) {
//                                       controller.toggleSmsUpdates();
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Divider(thickness: 1),
//                         SizedBox(
//                           height: 56,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 12, right: 12),
//                             child: Row(
//                               children: [
//                                 Image.asset("assets/images/whatapp.png"),
//                                 SizedBox(width: 20),
//                                 Text(
//                                   "Updates on WhatsApp",
//                                   style: TextStyle(
//                                     fontFamily: "Poppins",
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Obx(
//                                   () => FlutterSwitch(
//                                     width: 33.0,
//                                     height: 18.0,
//                                     toggleSize: 21.0,
//                                     value: controller.isWhatsappUpdates.value,
//                                     borderRadius: 30.0,
//                                     padding: 1.0,
//                                     activeColor: AppColors.orage,
//                                     inactiveColor: AppColors.grey,
//                                     onToggle: (val) {
//                                       controller.toggleWhatsappUpdates();
//                                       // Toggle theme
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Divider(thickness: 1),
//                         SizedBox(
//                           height: 56,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 12, right: 12),
//                             child: Row(
//                               children: [
//                                 Image.asset("assets/images/privacy.png"),
//                                 SizedBox(width: 20),
//                                 Text(
//                                   "Privacy & Data",
//                                   style: TextStyle(
//                                     fontFamily: "poppins",
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Divider(thickness: 1),
//                         SizedBox(
//                           height: 56,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 12, right: 12),
//                             child: Row(
//                               children: [
//                                 Image.asset("assets/images/delete.png"),
//                                 SizedBox(width: 20),
//                                 Text(
//                                   "Delete account",
//                                   style: TextStyle(
//                                     fontFamily: "poppins",
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.orage,
//                                   ),
//                                 ),
//                               ],
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
// }
