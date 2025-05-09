import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../../Bottom2/controllers/bottom2_controller.dart';
import '../../Bottom2/views/bottom2_view.dart';
import '../controllers/provider_setting_controller.dart';

class ProviderSettingView extends GetView<ProviderSettingController> {
  const ProviderSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<Bottom2Controller>().selectedIndex.value = 0;
        Get.offAll(() => Bottom2View());
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(gradient: AppColors.appGradient2),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40),
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
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 56,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
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
                                    activeColor: AppColors.orage,
                                    inactiveColor: AppColors.grey,
                                    onToggle: (val) {
                                      controller.toggleTheme();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(thickness: 1),
                        SizedBox(
                          height: 56,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
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
                                    activeColor: AppColors.orage,
                                    inactiveColor: AppColors.grey,
                                    onToggle: (val) {
                                      controller.toggleSmsUpdates();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(thickness: 1),
                        SizedBox(
                          height: 56,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
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
                                    activeColor: AppColors.orage,
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
                        ),
                        Divider(thickness: 1),
                        SizedBox(
                          height: 56,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
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
                        ),
                        Divider(thickness: 1),
                        SizedBox(
                          height: 56,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: Row(
                              children: [
                                Image.asset("assets/images/delete.png"),
                                SizedBox(width: 20),
                                Text(
                                  "Delete account",
                                  style: TextStyle(
                                    fontFamily: "poppins",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.orage,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
