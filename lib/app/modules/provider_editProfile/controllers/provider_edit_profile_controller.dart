import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider_account/controllers/provider_account_controller.dart';

class ProviderEditProfileController extends GetxController {
  //TODO: Implement ProviderEditProfileController
  RxString imagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();
  RxString selectedImagePath = ''.obs; // ⬅️ Add this in your controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  var userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();getUserData();
  }

  void toggleEdit(RxBool fieldEditable) {
    fieldEditable.value = !fieldEditable.value;
  }
  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('userData');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      userData.value = userMap;

      nameController.text = userMap['name'] ?? '';
      genderController.text = userMap['gender'] ?? '';
      dobController.text = userMap['dob'] ?? '';
      emailController.text = userMap['email'] ?? '';
    }
  }
  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? firstName = prefs.getString('firstName');
    final String? lastName = prefs.getString('lastName');
    final String? gender = prefs.getString('gender');
    final String? dob = prefs.getString('dob');
    final String? email = prefs.getString('email');
    final String? image = prefs.getString('userImg');

    nameController.text = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    genderController.text = gender ?? '';
    dobController.text = dob ?? '';
    emailController.text = email ?? '';

    if (image != null && image.isNotEmpty) {
      imagePath.value = image.startsWith("http")
          ? image
          : 'https://jdapi.youthadda.co/$image';
    }

    update();
  }


  Future<void> getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      imagePath.value = image.path;
      update();
    }
  }

  Future<void> updateUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      Get.snackbar("Error", "User ID not found. Please log in again.");
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/user/updateUser'),
    );

    final firstName = nameController.text.split(" ").first;
    final lastName = nameController.text.split(" ").length > 1
        ? nameController.text.split(" ").sublist(1).join(" ")
        : "";

    request.fields.addAll({
      "_id": userId,
      "firstName": firstName,
      "lastName": lastName,
      "email": emailController.text,
      "gender": genderController.text,
      "dob": dobController.text,
    });

    if (imagePath.value.isNotEmpty && !imagePath.value.startsWith("http")) {
      request.files.add(await http.MultipartFile.fromPath('userImg', imagePath.value));
    }

    try {
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseBody);

      if (response.statusCode == 200 && responseJson['code'] == 200) {
        // Save updated data into SharedPreferences immediately
        await prefs.setString('firstName', firstName);
        await prefs.setString('lastName', lastName);
        await prefs.setString('email', emailController.text);
        await prefs.setString('gender', genderController.text);
        await prefs.setString('dob', dobController.text);

        if (imagePath.value.isNotEmpty) {
          if (imagePath.value.startsWith("http")) {
            await prefs.setString('userImg', imagePath.value);
          } else {
            // For local path, you might want to upload first or handle differently.
            // Here just save the local path temporarily.
            await prefs.setString('userImg', imagePath.value);
          }
        }

        // Update userData observable for immediate UI refresh
        userData.value = {
          "firstName": firstName,
          "lastName": lastName,
          "email": emailController.text,
          "gender": genderController.text,
          "dob": dobController.text,
          "userImg": prefs.getString('userImg') ?? '',
        };

        // Update controllers (optional, but useful if server might change data)
        nameController.text = "$firstName $lastName".trim();
        genderController.text = genderController.text;
        dobController.text = dobController.text;
        emailController.text = emailController.text;

        update(); // refresh UI

        // Also update AccountController's info to keep app consistent
        final accountController = Get.find<ProviderAccountController>();
        await accountController.loadUserInfo();
        await accountController.loadMobileNumber();

        Get.snackbar("Success", responseJson['msg'] ?? "Profile updated successfully");
      } else {
        Get.snackbar("Error", responseJson['msg'] ?? "Failed to update profile");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.");
    }
  }

}
