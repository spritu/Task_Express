import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
     // Get.snackbar('Error', 'Please fill in all required fields');
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

    String? userId2 = prefs.getString('userId');
    if (userId2 == null || userId2.isEmpty) return;

    if (firstName.value.isEmpty || lastName.value.isEmpty || gender.value.isEmpty || dateOfBirth.value.isEmpty || email.value.isEmpty) return;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/user/register'),
    );

    request.fields.addAll({
      '_id': userId2,
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

    if (imagePath.value.isNotEmpty && await File(imagePath.value).exists()) {
      request.files.add(await http.MultipartFile.fromPath('userImg', imagePath.value));
    } else {
      print('⚠️ Skipping image upload: No image selected or file not found.');
    }

    try {
      request.headers.addAll({'Accept': 'application/json'});

      print('📤 Sending request with fields: ${request.fields}');
      http.StreamedResponse response = await request.send();
      final resBody = await response.stream.bytesToString();

      print('🔄 Server Response: $resBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedResponse = json.decode(resBody);
        final box = GetStorage();
        box.write('isLoggedIn', true);

        final userData = decodedResponse['data'] ?? {};
        final rawImg = userData['userImg'] ?? '';
        final token = decodedResponse['token'] ?? ''; // ✅ FIXED LINE
        final userType = decodedResponse['userType'] ?? 0;

        String finalImage = '';
        if (rawImg != null && rawImg.toString().isNotEmpty) {
          finalImage = rawImg.toString().startsWith('http')
              ? rawImg
              : 'https://jdapi.youthadda.co/$rawImg';
        }
        await prefs.setInt('userType', userType);

        await prefs.setString('image', finalImage);
        await prefs.setString('token', token); // ✅ SAVE TOKEN HERE
        await prefs.setString('userId', userData['_id'] ?? '');
        await prefs.setString('firstName', userData['firstName'] ?? '');
        await prefs.setString('lastName', userData['lastName'] ?? '');
        await prefs.setString('dob', userData['dateOfBirth'] ?? '');
        await prefs.setString('email', userData['email'] ?? '');
        await prefs.setString('city', userData['city'] ?? '');
        await prefs.setString('gender', userData['gender'] ?? '');
        await prefs.setString('userImg', rawImg.toString());
        print("✅ userType: $userType");
        print("✅ Token saved: $token");
        print("✅ Image saved: $finalImage");

        clearFields();
        Get.to(() => LocationView());
      } else {
        print('❌ Server Error (${response.statusCode}): $resBody');
      }
    } catch (e) {
      print('❌ Exception: $e');
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