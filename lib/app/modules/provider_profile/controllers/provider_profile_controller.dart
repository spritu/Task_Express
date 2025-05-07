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
  var subCategories = <SubCategory>[].obs;
  final selectedCategoryId = ''.obs;
  final selectedCategoryIds = <String>[].obs;

  var filteredSubCategories = <SubCategory>[].obs;
  var selectedSubCategoryId = ''.obs;
  final isCategoryLoading = false.obs;

 // final selectedSubCategoryId = ''.obs;
  final selectedCategoryName = ''.obs;
  //final subCategories = <SubcategoryModel>[].obs;
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
      final url = Uri.parse('https://jdapi.youthadda.co/category/getsubcategorybyid');

      var headers = {
        'Content-Type': 'application/json',
      };

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
        Get.snackbar("", response.reasonPhrase ?? "Failed to load subcategories");
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
  
  // void filterSubCategories() {
  //   final selectedIds = selectedCategoryIds; // your selected category id list
  //   filteredSubCategories.value = subCategories.where((sub) => selectedIds.contains(sub.categoryId)).toList();
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
  final isProfessionValid = true.obs;
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

        state.value.isEmpty ||
        selectedProfession.value.isEmpty ||
     selectedCategoryId.value.isEmpty ||
        selectedSubCategoryId.value.isEmpty) {
      Get.snackbar('', 'Please fill in all required fields including Profession, Category, and Subcategory');
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
      Get.snackbar('', 'No user ID found, please login again.');
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
      'categoryId': selectedCategoryId.value,
      'subcategoryId': selectedSubCategoryId.value, // Replace with dynamic ID
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
        print('❌  ${streamed.statusCode}: $body');
        Get.snackbar('', 'Server returned ${streamed.statusCode}');
      }
    } catch (e) {
      print('❗ Exception: $e');
      Get.snackbar('', 'Could not register. Check your internet.');
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
//    fetchSubCategories();

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


class SubCategory {
  final String id;
  final String name;

  SubCategory({required this.id, required this.name});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
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
      name: json['name'],
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