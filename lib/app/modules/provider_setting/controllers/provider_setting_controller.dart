import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderSettingController extends GetxController {
  //TODO: Implement ProviderSettingController

  RxBool isDarkMode = false.obs;
  final count = 0.obs;
  RxBool status = false.obs;
  RxBool isSmsUpdates = false.obs;
  RxBool isWhatsappUpdates = false.obs;
  RxBool isPrivacyData = false.obs;
  RxBool isDeleteAccount = false.obs;

  void toggleStatus() {
    status.value = !status.value;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    print("Theme Changed: ${isDarkMode.value ? 'Dark' : 'Light'}");
  }

  void toggleSmsUpdates() => isSmsUpdates.value = !isSmsUpdates.value;
  void toggleWhatsappUpdates() =>
      isWhatsappUpdates.value = !isWhatsappUpdates.value;
  void togglePrivacyData() => isPrivacyData.value = !isPrivacyData.value;
  void toggleDeleteAccount() => isDeleteAccount.value = !isDeleteAccount.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
