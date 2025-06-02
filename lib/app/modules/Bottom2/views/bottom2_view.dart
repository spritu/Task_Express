import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final ProviderChatScreenController chatController = Get.put(
    ProviderChatScreenController(),
  );
  @override
  Widget build(BuildContext context) {
    Get.put(Bottom2Controller());
    chatController.fetchLastMessages();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => _buildBody(controller.selectedIndex.value)),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          selectedItemColor: Color(0xFFF67C0A),
          unselectedItemColor: Color(0xFF9F9F9F),
          showUnselectedLabels: true,
          onTap: (index) {
            controller.selectedIndex.value = index;

            if (index == 3) {
              // User is viewing chat, clear notification

              chatController.fetchLastMessages();
            }
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Jobs'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.chat),
                  Obx(() {
                    if (chatController.hasNewMessage.value) {
                      return Positioned(
                        right: 0,
                        top: 0,
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
