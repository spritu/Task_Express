import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../account/controllers/account_controller.dart';

class EditProfileController extends GetxController {
  RxString imagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();
  RxString profileImageUrl = ''.obs; // ✅ FINAL single source of truth

  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  var userData = {}.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    loadUserInfo();getUserData();
    final prefs = await SharedPreferences.getInstance();
    profileImageUrl.value = prefs.getString('profileImage') ?? '';

    print("✅ Initial Profile Image URL: ${profileImageUrl.value}");
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

    // Attach local file only
    if (imagePath.value.isNotEmpty && !imagePath.value.startsWith("http")) {
      request.files.add(await http.MultipartFile.fromPath('userImg', imagePath.value));
    }

    try {
      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();
      final responseJson = jsonDecode(responseBody);

      if (streamedResponse.statusCode == 200 && responseJson['code'] == 200) {
        final updatedData = responseJson['data'] ?? {};
        final rawImg = updatedData['userImg'] ?? '';
        final finalImage = rawImg.toString().startsWith('http')
            ? rawImg
            : 'https://jdapi.youthadda.co/$rawImg';

        // Save in SharedPreferences
        await prefs.setString('firstName', updatedData['firstName'] ?? firstName);
        await prefs.setString('lastName', updatedData['lastName'] ?? lastName);
        await prefs.setString('email', updatedData['email'] ?? emailController.text);
        await prefs.setString('gender', updatedData['gender'] ?? genderController.text);
        await prefs.setString('dob', updatedData['dob'] ?? dobController.text);
        await prefs.setString('userImg', finalImage);

        // Update local observable
        userData.value = {
          "firstName": updatedData['firstName'] ?? firstName,
          "lastName": updatedData['lastName'] ?? lastName,
          "email": updatedData['email'] ?? emailController.text,
          "gender": updatedData['gender'] ?? genderController.text,
          "dob": updatedData['dob'] ?? dobController.text,
          "userImg": finalImage,
        };

        imagePath.value = finalImage;

        // ✅ Force AccountController to reload SharedPreferences immediately
        final accountController = Get.find<AccountController>();
        await accountController.loadUserInfo();
        await accountController.loadMobileNumber();

        update();

        Get.snackbar("Success", responseJson['msg'] ?? "Profile updated successfully");
      } else {
        Get.snackbar("Error", responseJson['msg'] ?? "Failed to update profile");
      }
    } catch (e, st) {
      print("❌ Exception in updateUser: $e");
      print(st);
      Get.snackbar("Error", "Something went wrong. Please try again.");
    }
  }




}