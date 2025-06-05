import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../colors.dart';
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
        Future.delayed(Duration(milliseconds: 100), () {
          Get.offAll(() => Bottom2View());
        });
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
                bottom2Controller.globalNotifications
                    .clear(); // Optional: clear logic
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
          final notifications = bottom2Controller.globalNotifications;
          print("Notifications list: $notifications");
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
              bottom2Controller.selectedIndex.value = 0;
              Get.to(Bottom2View());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                final message = notif['message'] ?? "No message";
                final fullname =
                    "${notif['userId']['firstName'] ?? ''} ${notif['userId']['lastName'] ?? ''}";
                print("providerData123: $fullname");

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
                          color: Color(0xFFF67C0A),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$message",
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
