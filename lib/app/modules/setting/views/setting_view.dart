import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../../PrivacydataView/views/privacydata_view_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<BottomController>().selectedIndex.value = 0;
        Get.offAll(() => BottomView());
        return false;
      },
      child: Scaffold(backgroundColor: Colors.white,
        body: Container( height:MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [Color(0xFF87AAF6), Colors.white],
          ),
        ),child: SingleChildScrollView(child: Column(children: [ SizedBox(height: 40),
            Text(
            "Settings",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "poppins",
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
           SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 12,right: 12),
              child: Card(color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16,right: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 56,
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/moon.png",
                              color: AppColors.textColor,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "Dark mode",
                              style: TextStyle(
                                fontFamily: "poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Spacer(),
                            Obx(
                                  () => FlutterSwitch(
                                    width: 33.0,
                                    height: 18.0,
                                toggleSize: 21.0,
                                value: controller.isDarkMode.value,
                                borderRadius: 30.0,
                                padding: 1,
                                activeColor: Color(0xff114BCA),
                                inactiveColor: AppColors.grey,
                                onToggle: (val) {
                                  controller.toggleTheme();
                                },
                              ),
                            ),
                          ],
                        ),
                      ), SizedBox(
                        height: 56,
                        child: Row(
                          children: [
                            Image.asset("assets/images/msg.png"),
                            SizedBox(width: 20),
                            Text(
                              "Updates on SMS",
                              style: TextStyle(
                                fontFamily: "poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Spacer(),
                            Obx(
                                  () => FlutterSwitch(
                                    width: 33.0,
                                    height: 18.0,
                                toggleSize: 21.0,
                                value: controller.isSmsUpdates.value,
                                borderRadius: 30.0,
                                padding: 1.0,
                                activeColor: Color(0xff114BCA),
                                inactiveColor: AppColors.grey,
                                onToggle: (val) {
                                  controller.toggleSmsUpdates();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 56,
                        child: Row(
                          children: [
                            Image.asset("assets/images/whatapp.png"),
                            SizedBox(width: 20),
                            Text(
                              "Updates on WhatsApp",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Spacer(),
                            Obx(
                                  () => FlutterSwitch(
                                    width: 33.0,
                                    height: 18.0,
                                toggleSize: 21.0,
                                value: controller.isWhatsappUpdates.value,
                                borderRadius: 30.0,
                                padding: 1.0,
                                activeColor: Color(0xff114BCA),
                                inactiveColor: AppColors.grey,
                                onToggle: (val) {
                                  controller.toggleWhatsappUpdates();
                                  // Toggle theme
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 56,
                        child: Row(
                          children: [
                            Image.asset("assets/images/privacy.png"),
                            SizedBox(width: 20),
                            Text(
                              "Privacy & Data",
                              style: TextStyle(
                                fontFamily: "poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),


                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],),),)
      ),
    );
  }
}


