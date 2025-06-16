import 'package:get/get.dart';

import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider_account/controllers/provider_account_controller.dart';
import '../../provider_location/views/provider_location_view.dart';

class ProviderSignupController extends GetxController {
  //TODO: Implement ProviderSignupController

  var subCategories = <SubCategory>[].obs;
  final selectedCategoryId = ''.obs;
  final firstName = ''.obs;
  // final firstName = ''.obs;
  final lastName = ''.obs;
  final email = ''.obs;
  final mobile = ''.obs;
  final userType = 0.obs;
  final imagePath = ''.obs;

  final gender = ''.obs;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  //final firstNameController = TextEditingController();
  final selectedCategoryIds = <String>[].obs;
  final TextEditingController chargesController = TextEditingController();
  // var imagePath = ''.obs;
  var filteredSubCategories = <SubCategory>[].obs;
  var selectedSubCategoryId = ''.obs;
  final isCategoryLoading = false.obs;
  var userId = ''.obs;
  // final selectedSubCategoryId = ''.obs;
  final selectedCategoryName = ''.obs;
  final selectedSubCategoryName = ''.obs;
  //final subCategories = <SubcategoryModel>[].obs;
  final isSubCategoryVisible = false.obs;

  void setSelectedCategoryById(String id) {
    selectedCategoryId.value = id;
    // also store the name so you can display or submit it later
    final cat = categories.firstWhere((c) => c.id == id);
    selectedCategoryName.value = cat?.name ?? '';
  }

  void setSelectedProfession(String prof) {
    selectedProfession.value = prof;
    selectedCategoryId.value = '';
    selectedCategoryName.value = '';
  }

  final visitingProfessionals = <CategoryModel>[].obs;
  final fixedChargeHelpers = <CategoryModel>[].obs;
  var selectedSubCategory = Rxn<SubCategory>();
  final selectedProfession = ''.obs;
  final selectedCategory = ''.obs;

  List<CategoryModel> get categories {
    if (selectedProfession.value == 'Visiting Professionals') {
      return visitingProfessionals;
    } else if (selectedProfession.value == 'Fixed charge Helpers') {
      return fixedChargeHelpers;
    }
    return [];
  }

  var isLoading = false.obs;
  RxList<UserModel> usersByCategory = <UserModel>[].obs;

  void fetchSubCategories(String categoryId) async {
    try {
      final url = Uri.parse(
        'https://jdapi.youthadda.co/category/getsubcategorybyid',
      );

      var headers = {'Content-Type': 'application/json'};

      var request = http.Request('POST', url);
      request.body = json.encode({
        "categoryIds": [categoryId],
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("🔁 Raw response: $responseBody"); // 👈 Print raw response

        final data = jsonDecode(responseBody);

        if (data['data'] != null) {
          subCategories.value = List<SubCategory>.from(
            data['data'].map((item) => SubCategory.fromJson(item)),
          );
          //filterSubCategories(); // Optional if you're filtering
          print("✅ Subcategories loaded: ${subCategories.length}");
        } else {
          Get.snackbar("", "No subcategories found for this category");
        }
      } else {
        Get.snackbar(
          "",
          response.reasonPhrase ?? "Failed to load subcategories",
        );
      }
    } catch (e) {
      Get.snackbar("", e.toString());
    }
  }

  void toggleCategorySelection(String catId) {
    if (selectedCategoryIds.contains(catId)) {
      selectedCategoryIds.remove(catId);
    } else {
      selectedCategoryIds.add(catId);
    }
    //filterSubCategories(); // update on selection change
  }

  void setSelectedSubCategory(SubCategory? value) {
    selectedSubCategory.value = value;
  }

  // final isCategoryLoading = false.obs;
  // RxList<CategoryModel> visitingProfessionals = <CategoryModel>[].obs;
  // RxList<CategoryModel> fixedChargeHelpers    = <CategoryModel>[].obs;
  //
  // final selectedProfession = ''.obs;
  // final selectedCategory   = ''.obs;
  //
  // List<CategoryModel> get categories {
  //   if (selectedProfession.value == 'Visiting Professionals') {
  //     return visitingProfessionals;
  //   } else if (selectedProfession.value == 'Fixed charge Helpers') {
  //     return fixedChargeHelpers;
  //   }
  //   return [];
  // }

  void fetchCategories() async {
    isCategoryLoading.value = true;
    try {
      var req = http.Request(
        'GET',
        Uri.parse('https://jdapi.youthadda.co/category/getCategory'),
      );
      var res = await req.send();
      if (res.statusCode == 200) {
        var body = await res.stream.bytesToString();
        var list =
        (jsonDecode(body)['data'] as List)
            .map((m) => CategoryModel.fromJson(m))
            .toList();
        visitingProfessionals.value =
            list.where((c) => c.spType == '1').toList();
        fixedChargeHelpers.value = list.where((c) => c.spType == '2').toList();
      } else {
        print('❌ ${res.reasonPhrase}');
      }
    } catch (e) {
      print('❗ $e');
    } finally {
      isCategoryLoading.value = false;
    }
  }

  // void setSelectedProfession(String prof) {
  //   selectedProfession.value = prof;
  //   selectedCategory.value   = '';
  // }

  // void filterSubCategories() {
  //   final selectedIds = selectedCategoryIds; // your selected category id list
  //   filteredSubCategories.value = subCategories.where((sub) => selectedIds.contains(sub.categoryId)).toList();
  // }

  final genderController = TextEditingController();
  void setSelectedCategory(String cat) {
    selectedCategory.value = cat;
  }

  final serviceTypes =
      [
        {'title': 'Visiting Professionals'},
        {'title': 'Fixed charge Helpers'},
      ].obs;
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;

  var expandedServiceType = ''.obs;
  final categoryList = <String>[].obs;
  final isProfessionValid = true.obs;
  final TextEditingController aadharNo = TextEditingController();

  final formKey = GlobalKey<FormState>();
  TextEditingController categoryTextController = TextEditingController();
  //final lastName = ''.obs;

  final dateOfBirth = ''.obs;
  //final email = ''.obs;
  final city = ''.obs;

  final pinCode = ''.obs;
  final state = ''.obs;
  final referralCode = ''.obs;
  var selectedWorkExperience = "".obs;
  // final RxString imagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();
  RxString selectedCity = ''.obs;

  void setSelectedWorkExperience(String value) {
    selectedWorkExperience.value = value;
  }

  RxString selectedServiceType = ''.obs;

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

  var workExperienceList =
      <String>[
        "1 year",
        "2 years",
        "3 years",
        "4 years","5 years","6 years","7 years","8 years","9 years","10 years","11 years","12 years","13 years","14 years","15 years",
      ].obs;
  RxString selectState = ''.obs;
  RxList<String> states =
      <String>[
        'Maharashtra',
        'Karnataka',
        'Tamil Nadu',
        'Telangana',
        'Delhi',
      ].obs;

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

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    print("🔄 Loaded userId from SharedPreferences: $userId");
  }

  // Validation for the required fields
  bool validateFields() {
    if (firstName.value.isEmpty ||
        lastName.value.isEmpty ||
        gender.value.isEmpty ||
        dateOfBirth.value.isEmpty ||
        email.value.isEmpty ||
        city.value.isEmpty ||
        state.value.isEmpty ||
        selectedProfession.value.isEmpty ||
        selectedCategoryId.value.isEmpty) {
      Get.snackbar(
        '',
        'Please fill in all required fields including Profession, Category, and Subcategory',
      );
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
  String? mobileNumber;

  Future<void> registerServiceProvider() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null || userId.isEmpty) {
      Get.snackbar('Error', 'User ID not found. Please verify OTP again.');
      return;
    }

    mobileNumber = prefs.getString('mobileNumber');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/user/serviceproviderregister'),
    );

    Map<String, dynamic> skillData = {
      "categoryId": selectedCategoryId.value,
      "charge": chargesController.text,
    };
    if (selectedSubCategoryId.value.isNotEmpty) {
      skillData["subcategoryId"] = selectedSubCategoryId.value;
    }

    List<Map<String, dynamic>> skills = [skillData];

    request.fields.addAll({
      '_id': userId,
      'userType': '2',
      'firstName': firstName.value,
      'lastName': lastName.value,
      'gender': gender.value,
      'dateOfBirth': dob.value, // ✅ ✅ ✅
      'email': email.value,
      'phone': mobileNumber.toString(),
      'city': city.value,
      'pinCode': pinCode.value,
      'state': state.value,
      'referralCode': referralCode.value,
      'skills': jsonEncode(skills),
      'aadharNo': aadharNo.text,
      'experience': selectedWorkExperience.value.replaceAll(RegExp(r'[^0-9]'), ''),
    });

    if (selectedSubCategoryId.value.isNotEmpty) {
      request.fields['subcategoryId'] = selectedSubCategoryId.value;
    }

    if (imagePath.value.isNotEmpty && await File(imagePath.value).exists()) {
      request.files.add(await http.MultipartFile.fromPath('userImg', imagePath.value));
    } else {
      print('⚠️ Skipping image upload: No image selected or file not found.');
    }

    try {
      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        final jsonRes = json.decode(body);
        print('✅ JSON Response: $jsonRes');

        final box = GetStorage();
        box.remove('isLoggedIn');
        box.write('isLoggedIn2', true);

        final message = jsonRes['msg'] ?? 'Service provider registered';
        Get.snackbar('Success', message);

        final userData = jsonRes['data'] ?? jsonRes['user'] ?? jsonRes;
        print("👀 userData: $userData");

        String rawImg = userData?['userImg'] ?? '';
        String finalImage = '';
        if (rawImg.isNotEmpty) {
          if (rawImg.startsWith('http') || rawImg.startsWith('/data')) {
            finalImage = rawImg;
          } else {
            finalImage = 'https://jdapi.youthadda.co/$rawImg';
          }
        } else {
          finalImage = imagePath.value;
        }

        String token = jsonRes['token'] ?? '';

        imagePath.value = finalImage;
        await prefs.setString('image', finalImage);

        if (token.isNotEmpty) {
          await prefs.setString('token', token);
        }

        await prefs.setString('dob', dob.value); // ✅ ✅ ✅
        // aur baaki bhi:
        await prefs.setString('gender', gender.value);
        await prefs.setString('firstName', firstName.value);
        await prefs.setString('lastName', lastName.value);
        await prefs.setString('profession', selectedProfession.value);
        await prefs.setString('email', email.value);
        await prefs.setString('mobile', mobileNumber!);
        await prefs.setString('city', city.value);
        await prefs.setString('pinCode', pinCode.value);
        await prefs.setString('state', state.value);
        await prefs.setString('referralCode', referralCode.value);
        await prefs.setString('aadharNo', aadharNo.text);
        await prefs.setString('charge', chargesController.text);

        await prefs.reload();
        box.remove('isLoggedIn');
        box.write('isLoggedIn2', true);

        clearFields();

        Get.to(() => ProviderLocationView(), arguments: {
          'imagePath': imagePath.value,
          'dob': dob.value, // ✅ ✅ ✅
        });
      } else {
        print('❌ ${streamed.statusCode}: $body');
        try {
          final error = json.decode(body);
          Get.snackbar('Error', error['msg'] ?? 'Something went wrong.');
        } catch (_) {
          Get.snackbar('Error', 'Server returned ${streamed.statusCode}');
        }
      }
    } catch (e) {
      print('❗ Exception: $e');
      Get.snackbar('Error', 'Could not register. Check your internet connection.');
    }
  }







  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    dob.value = prefs.getString('dob') ?? '';
    dobController.text = dob.value;
  }


  final dob = ''.obs; // ✅ reactive dob

  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final pinCodeController = TextEditingController();
  final referralCodeController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    loadUserId();
    fetchCategories();
    loadUserInfo();
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    firstName.value = args['firstName'] ?? '';
    lastName.value = args['lastName'] ?? '';
    email.value = args['email'] ?? '';
    gender.value = args['gender'] ?? '';
    dob.value = args['dob'] ?? '';
    state.value = args['state'] ?? '';
    city.value = args['city'] ?? '';
    pinCode.value = args['pinCode']?.toString() ?? '';
    referralCode.value = args['referralCode']?.toString() ?? '';
    mobile.value = args['mobile'] ?? '';
    userType.value = args['userType'] ?? 0;
    imagePath.value = args['imagePath'] ?? '';

    // Sync text controllers
    firstNameController.text = firstName.value;
    lastNameController.text = lastName.value;
    emailController.text = email.value;
    genderController.text = gender.value;
    dobController.text = dob.value;
    stateController.text = state.value;
    cityController.text = city.value;
    pinCodeController.text = pinCode.value;
    referralCodeController.text = referralCode.value;
    mobileController.text = mobile.value;

    print('✅ Loaded args: $args');
    print('✅ Image path: ${imagePath.value}');
  }


  @override
  void onClose() {
    //  dobController.dispose();
    // categoryTextController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.onClose();
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String spType;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.spType,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // API returns spType, not sp_type
    return CategoryModel(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      icon: json['categoryImg'] ?? '',
      spType: json['spType']?.toString() ?? '',
    );
  }
}

class SubCategory {
  final String id;
  final String name;

  SubCategory({required this.id, required this.name});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(id: json['_id'] ?? '', name: json['name'] ?? '');
  }
}

class UserModel {
  final String? name;
  final String? mobile;
  final String? image;

  UserModel({this.name, this.mobile, this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      mobile: json['mobile'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'mobile': mobile, 'image': image};
  }
}