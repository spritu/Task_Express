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
    if (!validateFields()) {
      return; // Stop if validation fails
    }
    final prefs = await SharedPreferences.getInstance();
    String userId2 = userId.value;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/user/register'),
    );

    request.fields.addAll({
      '_id':  userId2,
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
      request.headers.addAll({
        'Accept': 'application/json',
      });

      http.StreamedResponse response = await request.send();
      final resBody = await response.stream.bytesToString();

      print('🔄 Server Response: $resBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedResponse = json.decode(resBody);
        print('🔍 Decoded Response: $decodedResponse');

        String? userId;
        String? fName;
        String? lName;
        String? dob;  String? email;String? gender;String? userImg;
        // 🧠 Find user data in the response
        Map<String, dynamic>? userData;
        if (decodedResponse.containsKey('data')) {
          userData = decodedResponse['data'];
        } else if (decodedResponse.containsKey('user')) {
          userData = decodedResponse['user'];
        } else if (decodedResponse.containsKey('_id')) {
          userData = decodedResponse;
        }

        if (userData != null) {
          userId = userData['_id'];
          fName = userData['firstName'];
          lName = userData['lastName'];  dob = userData['dateOfBirth'];  email = userData['email'];
          gender = userData['gender']; userImg = userData['userImg'];
        }

        if (userId != null && fName != null && lName != null && dob != null && email != null && gender != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userId);
          await prefs.setString('firstName', fName);
          await prefs.setString('lastName', lName);  await prefs.setString('dob', dob);  await prefs.setString('email', email);
          await prefs.setString('gender', gender);

          if (userImg != null) {
            await prefs.setString('userImg', imagePath.value); // ✅ save image to SharedPreferences
          }
          // Optional: Refresh controller if already in memory
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
        print("✅ Stored User ID: $userId, Name: $fName $lName $dob $email, Image: $userImg");
      } else {
        print('❌ Server Error (${response.statusCode}): $resBody');
        Get.snackbar('Error', 'Server returned ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception: $e');
      Get.snackbar('Error', 'Could not register. Check your internet or server.');
    }
  }

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
