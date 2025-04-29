import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProviderEditProfileController extends GetxController {
  //TODO: Implement ProviderEditProfileController
  bool isEditingName = false;
  bool isEditingGender = false;
  bool isEditingDOB = false;
  bool isEditingEmail = false;

  TextEditingController nameController = TextEditingController(text: "Akash Gupta");
  TextEditingController genderController = TextEditingController(text: "Male");
  TextEditingController dobController = TextEditingController(text: "26/03/1992");
  TextEditingController emailController = TextEditingController(text: "star334@gmail.com");
  final count = 0.obs;
  final RxString imagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();
  Future<void> getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      imagePath.value = image.path;
      update();
    }
  }
  @override

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
