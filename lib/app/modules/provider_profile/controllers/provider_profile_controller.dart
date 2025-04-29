import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider_account/controllers/provider_account_controller.dart';
import '../../provider_location/views/provider_location_view.dart';

class ProviderProfileController extends GetxController {
  //TODO: Implement ProviderProfileController
  final TextEditingController aadharNo = TextEditingController();
  final firstName = ''.obs;final formKey = GlobalKey<FormState>();

  TextEditingController categoryTextController = TextEditingController();
  final lastName = ''.obs;
  final gender = ''.obs;
  final dateOfBirth = ''.obs;
  final email = ''.obs;
  final city = ''.obs;var selectedProfession = "".obs;
  final pinCode = ''.obs;
  final state = ''.obs;  RxString selectedCategory = ''.obs;
  final referralCode = ''.obs;
  var selectedWorkExperience = "".obs;
  final RxString imagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();
  RxString selectedCity = ''.obs;
  RxList<String> categoryList = <String>[].obs;
  void setSelectedWorkExperience(String value) {
    selectedWorkExperience.value = value;
  }
  void setSelectedProfession(String value) {
    selectedProfession.value = value;
  }
  final Map<String, List<String>> stateCityMap = {
    'MP': ['Bhopal', 'Indore', 'Rewa'],
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
  var professionList = <String>[
    "Plumber",
    "Electrician",
    "Carpenter",
    "Painter",
    "Driver",
    // Jo professions chaho add kar lena
  ].obs;
  var workExperienceList = <String>[
    "Less than 1 year",
    "1-3 years",
    "3-5 years",
    "More than 5 years",
  ].obs;
  RxString selectState = ''.obs;
  RxList<String> states = <String>[
    'Maharashtra',
    'Karnataka',
    'Tamil Nadu',
    'Telangana',
    'Delhi'
  ].obs;
  Future<void> fetchCategories() async {
    try {
      var response = await http.get(Uri.parse('https://jdapi.youthadda.co/category/getCategory'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['data'] != null && data['data'] is List) {
          // Clear old data
          categoryList.clear();
          // Fill new data
          for (var item in data['data']) {
            categoryList.add(item['name']);

          }
        }
      } else {
        Get.snackbar("", response.reasonPhrase ?? "Failed to load categories");
      }
    } catch (e) {
      Get.snackbar("", "Something went wrong: $e");
    }
  }

  void setSelectedCategory(String value) {
    selectedCategory.value = value;
    categoryTextController.text = value;
  }
  void submitForm() {
    if (aadharNo.text.isEmpty) {
     // Get.snackbar("Error", "Aadhar number is required");
      return;
    }
    if (selectedCity.isEmpty || selectState.isEmpty) {
     // Get.snackbar("Error", "Please select city and state");
      return;
    }

    // You can add API call here
    print('Form Submitted');
    print('Aadhar No: ${aadharNo.text}');
    print('City: ${selectedCity.value}');
    print('State: ${selectState.value}');
  }
  final TextEditingController dobController = TextEditingController();
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
  // Validation for the required fields
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
          Get.delete<ProviderAccountController>();
          Get.put(ProviderAccountController());

        } else {
          print("❗ Missing data in response");
        }

        Get.snackbar('Success', 'Registration Successful');
        clearFields();
        Get.to(() => ProviderLocationView());
        print("✅ Stored User ID: $userId, Name: $fName $lName $dob $email, Image: $userImg");
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
    fetchCategories();
  }

  @override
  void onClose() {
  //  dobController.dispose();
   // categoryTextController.dispose();


    super.onClose();
  }
}
