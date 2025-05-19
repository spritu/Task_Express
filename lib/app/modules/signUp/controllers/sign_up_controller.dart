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

  var userId = ''.obs;

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId2 = prefs.getString('userId2');
    String? token = prefs.getString('token');
    String? email = prefs.getString('email');

    // Use the loaded data as needed
    print("🔑 Loaded userId2: $userId2");
    print("🔑 Loaded token: $token");
    print("🔑 Loaded email: $email");

    // You can also update the UI or variables as needed here
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
    final prefs = await SharedPreferences.getInstance();

    // ✅ Get userId2 from OTP verification step
    String? userId2 = prefs.getString('userId');

    if (userId2 == null || userId2.isEmpty) {
      Get.snackbar('Error', 'User ID not found. Please verify OTP again.');
      return;
    }

    // ✅ Validate required fields (optional check)
    if (firstName.value.isEmpty || lastName.value.isEmpty || gender.value.isEmpty || dateOfBirth.value.isEmpty || email.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all the fields');
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/user/register'),
    );

    // ✅ Add form fields
    request.fields.addAll({
      '_id': userId2,
      'firstName': firstName.value,
      'lastName': lastName.value,
      'gender': gender.value,
      'dateOfBirth': dateOfBirth.value, // Use format yyyy-mm-dd
      'email': email.value,
      'city': city.value,
      'pinCode': pinCode.value,
      'state': state.value,
      'referralCode': referralCode.value,
    });

    // ✅ Optional: Add image if exists
    if (imagePath.value.isNotEmpty && await File(imagePath.value).exists()) {
      request.files.add(await http.MultipartFile.fromPath('userImg', imagePath.value));
    } else {
      print('⚠️ Skipping image upload: No image selected or file not found.');
    }

    try {
      request.headers.addAll({
        'Accept': 'application/json',
      });

      print('📤 Sending request with fields: ${request.fields}');
      http.StreamedResponse response = await request.send();
      final resBody = await response.stream.bytesToString();

      print('🔄 Server Response: $resBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedResponse = json.decode(resBody);
        print('🔍 Decoded Response: $decodedResponse');

        final userData = decodedResponse['data'] ?? decodedResponse['user'] ?? decodedResponse;

        if (userData != null) {
          await prefs.setString('userId', userData['_id'] ?? '');
          await prefs.setString('firstName', userData['firstName'] ?? '');
          await prefs.setString('lastName', userData['lastName'] ?? '');
          await prefs.setString('dob', userData['dateOfBirth'] ?? '');
          await prefs.setString('email', userData['email'] ?? '');
          await prefs.setString('gender', userData['gender'] ?? '');

          if (userData['userImg'] != null) {
            await prefs.setString('userImg', userData['userImg']);
          }

          // Optional: Reset controllers
          Get.delete<AccountController>();
          Get.put(AccountController());
          Get.delete<EditProfileController>();
          Get.put(EditProfileController());

          Get.snackbar('Success', 'Registration Successful');
          clearFields();
          Get.to(() => LocationView());
        } else {
          print("❗ Missing 'data' in response");
          Get.snackbar('Error', 'Invalid response from server.');
        }
      } else {
        print('❌ Server Error (${response.statusCode}): $resBody');
        Get.snackbar('Error', 'Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception: $e');
      Get.snackbar('Error', 'Something went wrong. Try again later.');
    }
  }


  //682189e078ab2a5c1939a503
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }


  @override
  void onClose() {
    dobController.dispose();
    super.onClose();
  }
}