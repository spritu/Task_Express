import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../account/views/account_view.dart';
import '../../booking/views/booking_view.dart';
import '../../chat/views/chat_view.dart';
import '../../home/views/home_view.dart';
import '../../setting/views/setting_view.dart';
import '../../worknest/views/worknest_view.dart';
import '../controllers/bottom_controller.dart';

class BottomView extends GetView<BottomController> {
  const BottomView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => _buildBody(controller.selectedIndex.value)),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.selectedIndex.value = index,
          selectedItemColor: Color(0xFF114BCA),
          unselectedItemColor: Color(0xFF9F9F9F),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Bookings'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          ],
        ),
      ),
    );
  }
}

Widget _buildBody(int index) {
  switch (index) {
    case 0:
      return HomeView();
    case 1:
      return BookingView();
    case 2:
      return SettingView();
    case 3:
      return ChatView();
    case 4:
      return AccountView();
    default:
      return Center(child: Text('Unknown'));
  }
}
