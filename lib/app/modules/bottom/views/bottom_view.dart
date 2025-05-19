import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/app/modules/chat_screen/controllers/chat_screen_controller.dart';
import 'package:worknest/colors.dart';
import '../../account/views/account_view.dart';
import '../../booking/views/booking_view.dart';
import '../../chat_screen/views/chat_screen_view.dart';
import '../../home/views/home_view.dart';
import '../../setting/views/setting_view.dart';
import '../controllers/bottom_controller.dart';


class BottomView extends GetView<BottomController> {
  const BottomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // Controller's reactive variables se values lo
        return _buildBody(
          controller.selectedIndex.value,
          controller.showRequestPending.value,
          controller.helperName.value,
        );
      }),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          backgroundColor: AppColors.white,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.selectedIndex.value = index,
          selectedItemColor: const Color(0xFF114BCA),
          unselectedItemColor: const Color(0xFF9F9F9F),
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Bookings'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          ],
        ),
      ),
    );
  }
}

final ChatScreenController chatScreenController = Get.put(ChatScreenController());
Widget _buildBody(int index, bool showRequestPending, String helperName) {
  switch (index) {
    case 0:
      return const HomeView();
    case 1:
      return Stack(
        children: [
          const BookingView(),
          if (showRequestPending)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: RequestPendingBottomCard(helperName: helperName),
              ),
            ),
        ],
      );
    case 2:
      return const SettingView();
    case 3:

      chatScreenController.fetchLastMessages();
      return   ChatScreenView();
    case 4:
      return const AccountView();
    default:
      return const Center(child: Text('Unknown'));
  }
}
