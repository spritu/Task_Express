import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  //TODO: Implement SignUpController
  var selectedGender = ''.obs; // To store selected gender
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController(text: "+91 8754236955");
  TextEditingController emailController = TextEditingController();
  final count = 0.obs;
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
