import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/app/modules/bottom/controllers/bottom_controller.dart';
import 'package:worknest/app/modules/jobs/controllers/jobs_controller.dart';
import 'package:worknest/app/modules/provider_ChatScreen/views/provider_chat_screen_view.dart';
import 'package:worknest/app/modules/provider_home/controllers/provider_home_controller.dart';
import '../../../../colors.dart';
import '../../jobs/views/jobs_view.dart';
import '../../provider_ChatScreen/controllers/provider_chat_screen_controller.dart';
import '../../provider_account/views/provider_account_view.dart';
import '../../provider_chat/views/provider_chat_view.dart';
import '../../provider_home/views/provider_home_view.dart';
import '../../provider_setting/views/provider_setting_view.dart';
import '../controllers/bottom2_controller.dart';

class Bottom2View extends GetView<Bottom2Controller> {
  const Bottom2View({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(Bottom2Controller());
    final proChatScreenController = Get.put(ProviderChatScreenController());
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => _buildBody(controller.selectedIndex.value)),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: AppColors.white,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) async {
            controller.selectedIndex.value = index;

            if (index == 2) {
              await bottom2Controller
                  .fetchNotificationsPro(); // Optional refresh
              bottom2Controller.hasUnreadNotifications.value =
                  false; // Hide red dot
              // Optionally call an API to mark all notifications as read
            }
            // Clear the red dot if user opens Chat tab
            if (index == 3) {
              await bottom2Controller.markChatNotificationAsSeen();
              proChatScreenController.hasUnreadnotify.value = false;
            }
          },
          selectedItemColor: Color(0xFFF67C0A),
          unselectedItemColor: Color(0xFF9F9F9F),
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Jobs'),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.notifications),
                  Obx(() {
                    if (bottom2Controller.hasUnreadNotifications.value) {
                      return Positioned(
                        top: -1,
                        right: -1,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                ],
              ),
              label: 'Notifications',
            ),

            BottomNavigationBarItem(
              icon: Obx(
                () => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.chat),
                    if (proChatScreenController.hasUnreadnotify.value)
                      Positioned(
                        top: -1,
                        right: -1,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          ],
        ),
      ),
    );
  }
}

final JobsController jobsController = Get.put(JobsController());
final bottom2Controller = Get.put(Bottom2Controller());
final ProviderHomeController providerHomeController = Get.put(
  ProviderHomeController(),
);
final ProviderChatScreenController providerChatScreenController = Get.put(
  ProviderChatScreenController(),
);
Widget _buildBody(int index) {
  switch (index) {
    case 0:
      providerHomeController.fetchCurrentBooking();
      return ProviderHomeView();
    case 1:
      jobsController.fetchCurrentBooking();
      return JobsView();
    case 2:
      // bottom2Controller.fetchNotificationsPro();
      return ProviderSettingView();
    case 3:
      providerChatScreenController.fetchLastMessages();
      return ProviderChatScreenView();
    case 4:
      return ProviderAccountView();
    default:
      return Center(child: Text('Unknown'));
  }
}
