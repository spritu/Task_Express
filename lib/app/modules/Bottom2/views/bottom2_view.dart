import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../../jobs/views/jobs_view.dart';
import '../../provider_account/views/provider_account_view.dart';
import '../../provider_chat/views/provider_chat_view.dart';
import '../../provider_home/views/provider_home_view.dart';
import '../../provider_setting/views/provider_setting_view.dart';
import '../controllers/bottom2_controller.dart';

class Bottom2View extends GetView<Bottom2Controller> {
  const Bottom2View({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.white ,
      body: Obx(() => _buildBody(controller.selectedIndex.value)),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(backgroundColor: AppColors.white,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.selectedIndex.value = index,
          selectedItemColor: Color(0xFFF67C0A),
          unselectedItemColor: Color(0xFF9F9F9F),
          type: BottomNavigationBarType.fixed,showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Jobs'),
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
      return ProviderHomeView();
    case 1:
      return JobsView();
    case 2:
      return ProviderSettingView();
    case 3:
      return ProviderChatView();
    case 4:
      return ProviderAccountView();
    default:
      return Center(child: Text('Unknown'));
  }
}
