import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../auth_controller.dart';

class ProviderAccountController extends GetxController with WidgetsBindingObserver{
  //TODO: Implement ProviderAccountController
  RxBool showServiceCard = false.obs;
  RxString selectedProfession = "Choose Your Profession".obs;
  RxString selectCategory = "Choose Category".obs;
  RxString selectSubCategory = "Choose Sub-category".obs;
  RxString selectCharge = "₹ ".obs;
  final RxString mobileNumber = ''.obs;
  final count = 0.obs;
  final RxString firstName = ''.obs;
  final RxString lastName = ''.obs;
  final RxString imagePath = ''.obs;

  Future<void> logout() async {
    // Clear SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Clear GetStorage
    final box = GetStorage();
    await box.erase();

    // Set login status to false in AuthController
    final authController = Get.find<AuthController>();
    authController.isLoggedIn.value = false;

    // Navigate to login screen
    Get.offAllNamed('/provider-login');
  }

  void toggleServiceCard() {
    showServiceCard.value = !showServiceCard.value;
  }
  var charge = "250".obs;
  void setCharge(String charge) {
    selectCharge.value = charge;
  }
  void setProfession(String profession) {
    selectedProfession.value = profession;
  }
  void setSubCategory(String SubCategory) {
    selectSubCategory.value = SubCategory;
  }
  void setCategory(String category) {
    selectCategory.value = category;
  }
  Future<void> loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final number = prefs.getString('mobileNumber') ?? '';
    mobileNumber.value = number;
    print("📱 Loaded mobile number: $number");
  }
  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    firstName.value = prefs.getString('firstName') ?? '';
    lastName.value = prefs.getString('lastName') ?? '';
    mobileNumber.value = prefs.getString('mobile') ?? '';

    String? base64Image = prefs.getString('userImgBase64');

    if (base64Image != null && base64Image.isNotEmpty) {
      final bytes = base64Decode(base64Image);
      final tempDir = Directory.systemTemp;
      final file = await File('${tempDir.path}/profile.jpg').writeAsBytes(bytes);
      imagePath.value = file.path;
    }

    print("✅ Reloaded: ${firstName.value}, ${mobileNumber.value}");
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadUserInfo(); // Reload when back from another screen
    }
  }
  @override
  void onInit()  {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadMobileNumber();
     loadUserInfo();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void increment() => count.value++;
}
