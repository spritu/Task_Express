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
  final isCategoryLoading = false.obs;
  final selectedCategoryId = ''.obs;
  final selectedSubCategoryId = ''.obs;
  final selectedCategoryName = ''.obs;
  final subCategories = <SubcategoryModel>[].obs;
  final isSubCategoryVisible = false.obs;

  void setSelectedCategoryById(String id) {
    selectedCategoryId.value = id;
    // also store the name so you can display or submit it later
    final cat = categories.firstWhere((c) => c.id == id,);
    selectedCategoryName.value = cat?.name ?? '';
  }

  void setSelectedProfession(String prof) {
    selectedProfession.value = prof;
    selectedCategoryId.value = '';
    selectedCategoryName.value = '';
  }

  final visitingProfessionals = <CategoryModel>[].obs;
  final fixedChargeHelpers = <CategoryModel>[].obs;

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

  void fetchUsersByCategory(String categoryId) async {
    isLoading.value = true;
    try {
      final uri = Uri.parse(
          'https://jdapi.youthadda.co/user/getusersbycatsubcat?id=$categoryId');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null) {
          final dataList = jsonData['data'] as List;
          usersByCategory.value =
              dataList.map((e) => UserModel.fromJson(e)).toList();
          print("✅ Users fetched for category $categoryId");
        } else {
          usersByCategory.clear();
          print("⚠️ No data found for category");
        }
      } else {
        print('❌ API error: ${response.statusCode}');
      }
    } catch (e) {
      print('❗ Exception: $e');
    } finally {
      isLoading.value = false;
    }
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
      var req = http.Request('GET',
          Uri.parse('https://jdapi.youthadda.co/category/getCategory'));
      var res = await req.send();
      if (res.statusCode == 200) {
        var body = await res.stream.bytesToString();
        var list = (jsonDecode(body)['data'] as List)
            .map((m) => CategoryModel.fromJson(m))
            .toList();
        visitingProfessionals.value =
            list.where((c) => c.spType == '1').toList();
        fixedChargeHelpers.value =
            list.where((c) => c.spType == '2').toList();
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

  void setSelectedCategory(String cat) {
    selectedCategory.value = cat;
  }

  final serviceTypes = [
    {'title': 'Visiting Professionals'},
    {'title': 'Fixed charge Helpers'},
  ].obs;
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;

  var expandedServiceType = ''.obs;
  final categoryList = <String>[].obs;

  final TextEditingController aadharNo = TextEditingController();
  final firstName = ''.obs;
  final formKey = GlobalKey<FormState>();
  TextEditingController categoryTextController = TextEditingController();
  final lastName = ''.obs;
  final gender = ''.obs;
  final dateOfBirth = ''.obs;
  final email = ''.obs;
  final city = ''.obs;
  String userId = '';
  final pinCode = ''.obs;
  final state = ''.obs;
  final referralCode = ''.obs;
  var selectedWorkExperience = "".obs;
  final RxString imagePath = ''.obs;
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
    userId = prefs.getString('userId') ?? '';

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

  Future<void> registerServiceProvider() async {
    if (!validateFields()) return;

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';

    if (userId.isEmpty) {
      Get.snackbar('Error', 'No user ID found, please login again.');
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/user/serviceproviderregister'),
    );

    request.fields.addAll({
      '_id': userId,
      'userType': '2',
      'firstName': firstName.value,
      'lastName': lastName.value,
      'gender': gender.value,
      'dateOfBirth': dateOfBirth.value,
      'email': email.value,
      'city': city.value,
      'pinCode': pinCode.value,
      'state': state.value,
      'referralCode': referralCode.value,
      'categoryId': "67fcf1ee51de04c85e6a9ef3", // Replace with dynamic ID if needed
      'subcategoryId': "67fcf1ee51de04c85e6a9ef3", // Replace with dynamic ID
      'aadharNo': aadharNo.text,
    });

    // Attach profile image if available
    if (imagePath.value.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('userImg', imagePath.value));
    }

    try {
      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();

      print('🔄 Register Response: $body');

      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        final jsonRes = json.decode(body);
        Get.snackbar('Success', 'Service provider registered');
        clearFields();
        Get.to(() => ProviderLocationView()); // Proceed to next step
      } else {
        print('❌ Error ${streamed.statusCode}: $body');
        Get.snackbar('Error', 'Server returned ${streamed.statusCode}');
      }
    } catch (e) {
      print('❗ Exception: $e');
      Get.snackbar('Error', 'Could not register. Check your internet.');
    }
  }



// helper to load your stored userId
  Future<String> _getUserIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }





  @override
  void onInit() {
    super.onInit();
    loadUserId();
    fetchCategories();
  }

  @override
  void onClose() {
  //  dobController.dispose();
   // categoryTextController.dispose();


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
      name: json['name']     ?? 'Unknown',
      icon: json['categoryImg'] ?? '',
      spType: json['spType']?.toString() ?? '',
    );
  }
}



class SubcategoryModel {
  final String name;
  final String description;

  SubcategoryModel({
    required this.name,
    required this.description,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
class UserModel {
  final String? name;
  final String? mobile;
  final String? image;

  UserModel({this.name, this.mobile, this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['firstName'],
      mobile: json['mobile'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'image': image,
    };
  }
}