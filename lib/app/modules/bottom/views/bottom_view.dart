import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/app/modules/booking/controllers/booking_controller.dart';
import 'package:worknest/app/modules/chat_screen/controllers/chat_screen_controller.dart';
import 'package:worknest/colors.dart';
import '../../account/views/account_view.dart';
import '../../booking/controllers/booking_controller.dart';
import '../../booking/views/booking_view.dart';
import '../../chat_screen/views/chat_screen_view.dart';
import '../../home/views/home_view.dart';
import '../../setting/views/setting_view.dart';
import '../controllers/bottom_controller.dart';

class BottomView extends GetView<BottomController> {
  const BottomView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BottomController());
    final chatScreenController = Get.put(ChatScreenController());
    return Scaffold(
      body: Obx(() {
        return _buildBody(
          controller.selectedIndex.value,
          controller.showRequestPending.value,
          controller.helperName.value,
        );
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.blue,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 9,
            color: Colors.grey,
            height: 20 / 9, // line-height equivalent
            letterSpacing: 0.05, // 5% of 1em = ~0.05
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 9,
            height: 20 / 9,
            letterSpacing: 0.05,
          ),
          type: BottomNavigationBarType.fixed, // Needed for more than 3 items
          currentIndex: controller.selectedIndex.value,
          showUnselectedLabels: true,
          onTap: (index) async {
            controller.selectedIndex.value = index;
            if (index == 2) {
              await bottomController.fetchNotifications(); // Optional refresh
              bottomController.hasUnreadNotifications.value =
                  false; // Hide red dot
              // Optionally call an API to mark all notifications as read
            }
            // Clear the red dot if user opens Chat tab
            if (index == 3) {
              await bottomController.markChatNotificationAsSeen();
              chatScreenController.hasUnreadnotify.value = false;
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Obx(
                () => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.notifications),
                    if (bottomController.hasUnreadNotifications.value)
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
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Obx(
                () => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.chat),
                    if (chatScreenController.hasUnreadnotify.value)
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
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),

        //         BottomNavigationBar(
        //   backgroundColor: AppColors.white,
        //   currentIndex: controller.selectedIndex.value,
        //   onTap: (index) => controller.selectedIndex.value = index,
        //   selectedItemColor: const Color(0xFF114BCA),
        //   unselectedItemColor: const Color(0xFF9F9F9F),
        //   type: BottomNavigationBarType.fixed,
        //   showUnselectedLabels: true,
        //   items: const [
        //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        //     BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Bookings'),
        //     BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
        //     BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        //   ],
        // ),
      ),
    );
  }
}

final ChatScreenController chatScreenController = Get.put(
  ChatScreenController(),
);
final BookingController bookingController = Get.put(BookingController());
final bottomController = Get.put(BottomController());
Widget _buildBody(int index, bool showRequestPending, String helperName) {
  switch (index) {
    case 0:
      return const HomeView();
    case 1:
      bookingController.fetchCurrentBookings();
      return BookingView();

    case 2:
      // bottomController.fetchNotifications();
      return const SettingView();
    case 3:
      chatScreenController.fetchLastMessages();
      return ChatScreenView();
    case 4:
      return const AccountView();
    default:
      return const Center(child: Text('Unknown'));
  }
}
