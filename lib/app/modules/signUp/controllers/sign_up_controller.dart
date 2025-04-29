import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../account/controllers/account_controller.dart';
import '../../edit_profile/controllers/edit_profile_controller.dart';
import '../../location/views/location_view.dart';

class SignUpController extends GetxController {
  final firstName = ''.obs;
  final lastName = ''.obs;
  final gender = ''.obs;
  final dateOfBirth = ''.obs;
  final email = ''.obs;
  final city = ''.obs;
  final pinCode = ''.obs;
  final state = ''.obs;
  final referralCode = ''.obs;
  final RxString imagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController dobController = TextEditingController();
  final Map<String, List<String>> stateCityMap = {
    'MP': ['Bhopal', 'Indore', 'jabalpur'],
    'UP': ['Lucknow', 'Kanpur', 'Varanasi'],
    'MH': ['Mumbai', 'Pune', 'Nagpur'],
  };
  List<String> get citiesForSelectedState {
    return stateCityMap[state.value] ?? [];
  }

  // Reset city when state changes
  void onStateChanged(String newState) {
    state.value = newState;
    city.value = ''; // reset city
  }
  Future<void> getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      imagePath.value = image.path;
    }
  }

  File getImageFile() => File(imagePath.value);

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print("🧾 Loaded User ID: $userId");
  }

  bool validateFields() {
    if (firstName.value.isEmpty ||
        lastName.value.isEmpty ||
        gender.value.isEmpty ||
        dateOfBirth.value.isEmpty ||
        email.value.isEmpty ||
        city.value.isEmpty ||
        pinCode.value.isEmpty ||
        state.value.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields');
      return false;
    }
    return true;
  }

  void clearFields() {
    firstName.value = '';
    lastName.value = '';
    gender.value = '';
    dateOfBirth.value = '';
    email.value = '';
    city.value = '';
    pinCode.value = '';
    state.value = '';
    referralCode.value = '';
    imagePath.value = '';
    dobController.clear();
  }

  Future<void> registerUser() async {
    if (!validateFields()) return;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/user/register'),
    );

    request.fields.addAll({
      'firstName': firstName.value,
      'lastName': lastName.value,
      'gender': gender.value,
      'dateOfBirth': dateOfBirth.value,
      'email': email.value,
      'city': city.value,
      'pinCode': pinCode.value,
      'state': state.value,
      'referralCode': referralCode.value,
    });

    if (imagePath.value.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('userImg', imagePath.value));
    }

    try {
      request.headers.addAll({'Accept': 'application/json'});

      http.StreamedResponse response = await request.send();
      final resBody = await response.stream.bytesToString();

      print('🔄 Server Response: $resBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedResponse = json.decode(resBody);

        Map<String, dynamic>? userData;
        if (decodedResponse.containsKey('data')) {
          userData = decodedResponse['data'];
        } else if (decodedResponse.containsKey('user')) {
          userData = decodedResponse['user'];
        } else if (decodedResponse.containsKey('_id')) {
          userData = decodedResponse;
        }

        if (userData != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userData['_id'] ?? '');
          await prefs.setString('firstName', userData['firstName'] ?? '');
          await prefs.setString('lastName', userData['lastName'] ?? '');
          await prefs.setString('dob', userData['dateOfBirth'] ?? '');
          await prefs.setString('email', userData['email'] ?? '');
          await prefs.setString('gender', userData['gender'] ?? '');
          await prefs.setString('userImg', userData['userImg'] ?? '');

          Get.delete<AccountController>();
          Get.put(AccountController());
          Get.delete<EditProfileController>();
          Get.put(EditProfileController());
        } else {
          print("❗ Missing data in response");
        }

        Get.snackbar('Success', 'Registration Successful');
        clearFields();
        Get.to(() => LocationView());
      } else {
        print('❌ Server Error (${response.statusCode}): $resBody');
        Get.snackbar('', 'Server returned ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception: $e');
      Get.snackbar('', 'Could not register. Check your internet or server.');
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserId();
  }

  @override
  void onClose() {
    dobController.dispose();
    super.onClose();
  }
}
