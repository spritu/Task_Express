import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../account/controllers/account_controller.dart';

class EditProfileController extends GetxController {
  bool isEditingName = false;
  bool isEditingGender = false;
  bool isEditingDOB = false;
  bool isEditingEmail = false;

  final RxString firstName = ''.obs;
  final RxString lastName = ''.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final RxString imagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadUserInfo(); // Fetch data when controller initializes
  }

  // Load user data from SharedPreferences
  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? firstName = prefs.getString('firstName');
    final String? lastName = prefs.getString('lastName');
    final String? gender = prefs.getString('gender');
    final String? dob = prefs.getString('dob');
    final String? email = prefs.getString('email');
    final String? image = prefs.getString('userImg');

    nameController.text = '${firstName ?? ''} ${lastName ?? ''}';
    genderController.text = gender ?? '';
    dobController.text = dob ?? '';
    emailController.text = email ?? '';

    // Set image if available
    if (image != null && image.isNotEmpty) {
      imagePath.value = image;
    }

    update(); // Update UI if necessary
  }

  // Get image from camera or gallery
  Future<void> getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      imagePath.value = image.path;
      update(); // Update UI after image selection
    }
  }

  // Update user data
  Future<void> updateUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId'); // Get stored ID from registration

    if (userId == null) {
    //  Get.snackbar("Error", "User ID not found. Please log in again.");
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/user/updateUser'),
    );

    // Fields
    request.fields.addAll({
      "_id": userId,
      "firstName": nameController.text.split(" ").first,
      "lastName": nameController.text.split(" ").length > 1
          ? nameController.text.split(" ").sublist(1).join(" ")
          : "",
      "email": emailController.text,
      "gender": genderController.text,
      "dob": dobController.text,
    });

    // Optional image file
    if (imagePath.value.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('userImg', imagePath.value));
    }

    try {
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("🔁 Response Status: ${response.statusCode}");
      print("🔁 Raw Response Body: $responseBody");

      final responseJson = jsonDecode(responseBody);

      if (response.statusCode == 200 && responseJson['code'] == 200) {
      //  Get.snackbar("Success", responseJson['msg'] ?? "Profile updated successfully");

        final accountController = Get.find<AccountController>();
        await accountController.loadUserInfo();
        await accountController.loadMobileNumber();
      } else {
        print("❌ Error from API: ${responseJson['msg']}");
       // Get.snackbar("Error", responseJson['msg'] ?? "Failed to update profile");
      }
    } catch (e) {
      print("❌ Exception caught: $e");
     // Get.snackbar("Error", "Something went wrong. Please try again.");
    }

  }
}
