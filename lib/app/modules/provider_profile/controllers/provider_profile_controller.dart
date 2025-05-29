// import 'dart:convert';
// import 'dart:io';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../provider_account/controllers/provider_account_controller.dart';
// import '../../provider_location/views/provider_location_view.dart';
// import 'package:http_parser/http_parser.dart';
//
// class ProviderProfileController extends GetxController {
//   //TODO: Implement ProviderProfileController
//   var subCategories = <SubCategory>[].obs;
//   final selectedCategoryId = ''.obs;
//   final selectedCategoryIds = <String>[].obs;
//   final TextEditingController chargesController = TextEditingController();
//
//   var filteredSubCategories = <SubCategory>[].obs;
//   var selectedSubCategoryId = ''.obs;
//   final isCategoryLoading = false.obs;
//   var userId = ''.obs;
//   // final selectedSubCategoryId = ''.obs;
//   final selectedCategoryName = ''.obs;
//   final selectedSubCategoryName = ''.obs;
//   //final subCategories = <SubcategoryModel>[].obs;
//   final isSubCategoryVisible = false.obs;
//
//   void setSelectedCategoryById(String id) {
//     selectedCategoryId.value = id;
//     // also store the name so you can display or submit it later
//     final cat = categories.firstWhere((c) => c.id == id);
//     selectedCategoryName.value = cat?.name ?? '';
//   }
//
//   void setSelectedProfession(String prof) {
//     selectedProfession.value = prof;
//     selectedCategoryId.value = '';
//     selectedCategoryName.value = '';
//   }
//
//   final visitingProfessionals = <CategoryModel>[].obs;
//   final fixedChargeHelpers = <CategoryModel>[].obs;
//   var selectedSubCategory = Rxn<SubCategory>();
//   final selectedProfession = ''.obs;
//   final selectedCategory = ''.obs;
//
//   List<CategoryModel> get categories {
//     if (selectedProfession.value == 'Visiting Professionals') {
//       return visitingProfessionals;
//     } else if (selectedProfession.value == 'Fixed charge Helpers') {
//       return fixedChargeHelpers;
//     }
//     return [];
//   }
//
//   var isLoading = false.obs;
//   RxList<UserModel> usersByCategory = <UserModel>[].obs;
//
//   void fetchSubCategories(String categoryId) async {
//     try {
//       final url = Uri.parse(
//         'https://jdapi.youthadda.co/category/getsubcategorybyid',
//       );
//
//       var headers = {'Content-Type': 'application/json'};
//
//       var request = http.Request('POST', url);
//       request.body = json.encode({
//         "categoryIds": [categoryId],
//       });
//       request.headers.addAll(headers);
//
//       http.StreamedResponse response = await request.send();
//
//       if (response.statusCode == 200) {
//         final responseBody = await response.stream.bytesToString();
//         print("🔁 Raw response: $responseBody"); // 👈 Print raw response
//
//         final data = jsonDecode(responseBody);
//
//         if (data['data'] != null) {
//           subCategories.value = List<SubCategory>.from(
//             data['data'].map((item) => SubCategory.fromJson(item)),
//           );
//           //filterSubCategories(); // Optional if you're filtering
//           print("✅ Subcategories loaded: ${subCategories.length}");
//         } else {
//          // Get.snackbar("", "No subcategories found for this category");
//         }
//       } else {
//         // Get.snackbar(
//         //   "",
//         //   response.reasonPhrase ?? "Failed to load subcategories",
//         // );
//       }
//     } catch (e) {
//    //   Get.snackbar("", e.toString());
//     }
//   }
//
//   void toggleCategorySelection(String catId) {
//     if (selectedCategoryIds.contains(catId)) {
//       selectedCategoryIds.remove(catId);
//     } else {
//       selectedCategoryIds.add(catId);
//     }
//     //filterSubCategories(); // update on selection change
//   }
//
//   void setSelectedSubCategory(SubCategory? value) {
//     selectedSubCategory.value = value;
//   }
//
//   // final isCategoryLoading = false.obs;
//   // RxList<CategoryModel> visitingProfessionals = <CategoryModel>[].obs;
//   // RxList<CategoryModel> fixedChargeHelpers    = <CategoryModel>[].obs;
//   //
//   // final selectedProfession = ''.obs;
//   // final selectedCategory   = ''.obs;
//   //
//   // List<CategoryModel> get categories {
//   //   if (selectedProfession.value == 'Visiting Professionals') {
//   //     return visitingProfessionals;
//   //   } else if (selectedProfession.value == 'Fixed charge Helpers') {
//   //     return fixedChargeHelpers;
//   //   }
//   //   return [];
//   // }
//
//   void fetchCategories() async {
//     isCategoryLoading.value = true;
//     try {
//       var req = http.Request(
//         'GET',
//         Uri.parse('https://jdapi.youthadda.co/category/getCategory'),
//       );
//       var res = await req.send();
//       if (res.statusCode == 200) {
//         var body = await res.stream.bytesToString();
//         var list =
//         (jsonDecode(body)['data'] as List)
//             .map((m) => CategoryModel.fromJson(m))
//             .toList();
//         visitingProfessionals.value =
//             list.where((c) => c.spType == '1').toList();
//         fixedChargeHelpers.value = list.where((c) => c.spType == '2').toList();
//       } else {
//         print('❌ ${res.reasonPhrase}');
//       }
//     } catch (e) {
//       print('❗ $e');
//     } finally {
//       isCategoryLoading.value = false;
//     }
//   }
//
//   // void setSelectedProfession(String prof) {
//   //   selectedProfession.value = prof;
//   //   selectedCategory.value   = '';
//   // }
//
//   // void filterSubCategories() {
//   //   final selectedIds = selectedCategoryIds; // your selected category id list
//   //   filteredSubCategories.value = subCategories.where((sub) => selectedIds.contains(sub.categoryId)).toList();
//   // }
//
//   void setSelectedCategory(String cat) {
//     selectedCategory.value = cat;
//   }
//
//   final serviceTypes =
//       [
//         {'title': 'Visiting Professionals'},
//         {'title': 'Fixed charge Helpers'},
//       ].obs;
//   RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
//
//   var expandedServiceType = ''.obs;
//   final categoryList = <String>[].obs;
//   final isProfessionValid = true.obs;
//   final TextEditingController aadharNo = TextEditingController();
//   final firstName = ''.obs;
//   final formKey = GlobalKey<FormState>();
//   TextEditingController categoryTextController = TextEditingController();
//   final lastName = ''.obs;
//   final gender = ''.obs;
//   final dateOfBirth = ''.obs;
//   final email = ''.obs;
//   final city = ''.obs;
//
//   final pinCode = ''.obs;
//   final state = ''.obs;
//   final referralCode = ''.obs;
//   var selectedWorkExperience = "".obs;
//   final RxString imagePath = ''.obs;
//   final ImagePicker _picker = ImagePicker();
//   RxString selectedCity = ''.obs;
//
//   void setSelectedWorkExperience(String value) {
//     selectedWorkExperience.value = value;
//   }
//
//   RxString selectedServiceType = ''.obs;
//
//   final Map<String, List<String>> stateCityMap = {
//     'MP': ['Bhopal', 'Indore', 'Rewa'],
//     'UP': ['Lucknow', 'Kanpur', 'Varanasi'],
//     'MH': ['Mumbai', 'Pune', 'Nagpur'],
//   };
//
//   List<String> get citiesForSelectedState {
//     return stateCityMap[state.value] ?? [];
//   }
//
//   // Reset city when state changes
//   void onStateChanged(String newState) {
//     state.value = newState;
//     city.value = ''; // reset city
//   }
//
//   var workExperienceList =
//       <String>[
//         "1 year",
//         "2 years",
//         "3 years",
//         "4 years","5 years","6 years","7 years","8 years","9 years","10 years","11 years","12 years","13 years","14 years","15 years",
//       ].obs;
//   RxString selectState = ''.obs;
//   RxList<String> states =
//       <String>[
//         'Maharashtra',
//         'Karnataka',
//         'Tamil Nadu',
//         'Telangana',
//         'Delhi',
//       ].obs;
//
//   void submitForm() {
//     if (aadharNo.text.isEmpty) {
//       // Get.snackbar("Error", "Aadhar number is required");
//       return;
//     }
//     if (selectedCity.isEmpty || selectState.isEmpty) {
//       // Get.snackbar("Error", "Please select city and state");
//       return;
//     }
//
//     // You can add API call here
//     print('Form Submitted');
//     print('Aadhar No: ${aadharNo.text}');
//     print('City: ${selectedCity.value}');
//     print('State: ${selectState.value}');
//   }
//
//   final TextEditingController dobController = TextEditingController();
//
//   Future<void> getImage(ImageSource source) async {
//     final XFile? image = await _picker.pickImage(source: source);
//     if (image != null) {
//       imagePath.value = image.path;
//     }
//   }
//
//   File getImageFile() => File(imagePath.value);
//
//   Future<void> loadUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? userId = prefs.getString('userId');
//
//     print("🔄 Loaded userId from SharedPreferences: $userId");
//   }
//
//   // Validation for the required fields
//   bool validateFields() {
//     if (firstName.value.isEmpty ||
//         lastName.value.isEmpty ||
//         gender.value.isEmpty ||
//         dateOfBirth.value.isEmpty ||
//         email.value.isEmpty ||
//         city.value.isEmpty ||
//         state.value.isEmpty ||
//         selectedProfession.value.isEmpty ||
//         selectedCategoryId.value.isEmpty) {
//       // Get.snackbar(
//       //   '',
//       //   'Please fill in all required fields including Profession, Category, and Subcategory',
//       // );
//       return false;
//     }
//     return true;
//   }
//
//   void clearFields() {
//     firstName.value = '';
//     lastName.value = '';
//     gender.value = '';
//     dateOfBirth.value = '';
//     email.value = '';
//     city.value = '';
//     pinCode.value = '';
//     state.value = '';
//     referralCode.value = '';
//   }
//   String? mobileNumber;
//
//   Future<void> registerServiceProvider() async {
//     if (!validateFields()) return;
//
//     final prefs = await SharedPreferences.getInstance();
//     String? userId = prefs.getString('userId');
//
//     if (userId == null || userId.isEmpty) {
//      // Get.snackbar('Error', 'User ID not found. Please verify OTP again.');
//       return;
//     }
//     mobileNumber = prefs.getString('mobileNumber');
//
//
//     final request = http.MultipartRequest(
//       'POST',
//       Uri.parse('https://jdapi.youthadda.co/user/serviceproviderregister'),
//     );
//
//     print('📤 Sending registration data:');
//     print('userId: $userId');
//     print('First Name: ${firstName.value}');
//     print('Last Name: ${lastName.value}');
//     print('Gender: ${gender.value}');
//     print('DOB: ${dateOfBirth.value}');
//     print('Email: ${email.value}');
//     print('Phone: ${mobileNumber}');
//     print('City: ${city.value}');
//     print('Pin Code: ${pinCode.value}');
//     print('State: ${state.value}');
//     print('Referral Code: ${referralCode.value}');
//     print('CategoryId: ${selectedCategoryId.value}');
//     print('SubcategoryId: ${selectedSubCategoryId.value}');
//     print('Charge: ${chargesController.text}');
//     print('Aadhar No: ${aadharNo.text}');
//
//     // ✅ Construct skills JSON
//     Map<String, dynamic> skillData = {
//       "categoryId": selectedCategoryId.value,
//       "charge": chargesController.text,
//     };
//
//     if (selectedSubCategoryId.value.isNotEmpty) {
//       skillData["sucategoryId"] = selectedSubCategoryId.value;
//     }
//
//     List<Map<String, dynamic>> skills = [skillData];
//     print('Skills JSON: $skills');
//
//     // 🔸 Add all required fields
//     request.fields.addAll({
//       '_id': userId,
//       'userType': '2',
//       'firstName': firstName.value,
//       'lastName': lastName.value,
//       'gender': gender.value,
//       'dateOfBirth': dateOfBirth.value,
//       'email': email.value,
//       'phone': mobileNumber.toString(),
//       'city': city.value,'experience': selectedWorkExperience.value,
//       'pinCode': pinCode.value,
//       'state': state.value,
//       'referralCode': referralCode.value,
//       'skills': jsonEncode(skills),
//       'aadharNo': aadharNo.text,
//     });
//
//     // ✅ Optional subcategory fields in SharedPreferences
//     if (selectedSubCategoryId.value.isNotEmpty) {
//       request.fields['subcategoryId'] = selectedSubCategoryId.value;
//       await prefs.setString('subcategoryId', selectedSubCategoryId.value);
//       await prefs.setString('subcategory', selectedSubCategoryName.value);
//       print("✅ Subcategory ID: ${selectedSubCategoryId.value}");
//       print("✅ Subcategory Name: ${selectedSubCategoryName.value}");
//     }
//     final box = GetStorage();
//     box.remove('isLoggedIn');
//     // 🔸 Add image if exists
//     if (imagePath.value.isNotEmpty) {
//       File imageFile = File(imagePath.value);
//
//       if (await imageFile.exists()) {
//         print('✅ Image file exists: ${imagePath.value}');
//         request.files.add(
//           await http.MultipartFile.fromPath(
//             'Img', // Make sure this field name is what your backend expects
//             imagePath.value,
//             contentType: MediaType('image', 'jpeg'), // or 'png' if needed
//           ),
//         );
//
//         final bytes = await imageFile.readAsBytes();
//         final base64Image = base64Encode(bytes);
//         await prefs.setString('userImgBase64', base64Image);
//         await prefs.setString('userImg', imagePath.value);
//       } else {
//         print('❗ File not found at path: ${imagePath.value}');
//       }
//     }
//
//
//     try {
//       final streamed = await request.send();
//       final body = await streamed.stream.bytesToString();
//
//       print('🔄 Raw Response Body: $body');
//
//       if (streamed.statusCode == 200 || streamed.statusCode == 201) {
//         final jsonRes = json.decode(body);
//         print('✅ JSON Response: $jsonRes');
//
//         box.write('isLoggedIn2', true);
//
//         // final message = jsonRes['msg'] ?? 'Service provider registered';
//        // Get.snackbar('Success', message);
//
//         // 🔸 Save required data to SharedPreferences
//         await prefs.setString('categoryId', selectedCategoryId.value);
//         await prefs.setString('category', selectedCategoryName.value);
//         await prefs.setString('firstName', firstName.value);
//         await prefs.setString('lastName', lastName.value);
//         await prefs.setString('profession', selectedProfession.value);
//         await prefs.setString('gender', gender.value);
//         await prefs.setString('dob', dateOfBirth.value);
//         await prefs.setString('email', email.value);
//         await prefs.setString('mobile', mobileNumber!);
//         await prefs.setString('city', city.value);
//         await prefs.setString('pinCode', pinCode.value);
//         await prefs.setString('state', state.value);
//         await prefs.setString('referralCode', referralCode.value);
//         await prefs.setString('aadharNo', aadharNo.text);
//         await prefs.setString('charge', chargesController.text);
//          // final box = GetStorage();
//          // box.write('isLoggedIn2', true);
//         //await prefs.reload();
//
//          // ❌ Remove old login flag if set
//
//
//         prefs.remove('userId2');
//         // final ProviderAccountController = Get.find<ProviderAccountController>();
//         // await accountController.loadUserInfo();
//         // await accountController.loadMobileNumber();
//
//         clearFields();
//         Get.to(() => ProviderLocationView());
//       } else {
//         print('❌ ${streamed.statusCode}: $body');
//         try {
//           final error = json.decode(body);
//        //   Get.snackbar('Error', error['msg'] ?? 'Something went wrong.');
//         } catch (_) {
//        //   Get.snackbar('Error', 'Server returned ${streamed.statusCode}');
//         }
//       }
//     } catch (e) {
//       print('❗ Exception: $e');
//     //  Get.snackbar('Error', 'Could not register. Check your internet connection.');
//     }
//   }
//
//
//
//
//   // helper to load your stored userId
//   Future<String> _getUserIdFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userId') ?? '';
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadUserId();
//
//     fetchCategories();
//
//   }
//
//   @override
//   void onClose() {
//     //  dobController.dispose();
//     // categoryTextController.dispose();
//
//     super.onClose();
//   }
// }
//
// class CategoryModel {
//   final String id;
//   final String name;
//   final String icon;
//   final String spType;
//
//   CategoryModel({
//     required this.id,
//     required this.name,
//     required this.icon,
//     required this.spType,
//   });
//
//   factory CategoryModel.fromJson(Map<String, dynamic> json) {
//     // API returns spType, not sp_type
//     return CategoryModel(
//       id: json['_id']?.toString() ?? '',
//       name: json['name'] ?? 'Unknown',
//       icon: json['categoryImg'] ?? '',
//       spType: json['spType']?.toString() ?? '',
//     );
//   }
// }
//
// class SubCategory {
//   final String id;
//   final String name;
//
//   SubCategory({required this.id, required this.name});
//
//   factory SubCategory.fromJson(Map<String, dynamic> json) {
//     return SubCategory(id: json['_id'] ?? '', name: json['name'] ?? '');
//   }
// }
//
// class UserModel {
//   final String? name;
//   final String? mobile;
//   final String? image;
//
//   UserModel({this.name, this.mobile, this.image});
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       name: json['name'],
//       mobile: json['mobile'],
//       image: json['image'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {'name': name, 'mobile': mobile, 'image': image};
//   }
// }

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
  final TextEditingController chargesController = TextEditingController();

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
  final firstName = ''.obs;
  final formKey = GlobalKey<FormState>();
  TextEditingController categoryTextController = TextEditingController();
  final lastName = ''.obs;
  final gender = ''.obs;
  final dateOfBirth = ''.obs;
  final email = ''.obs;
  final city = ''.obs;

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
    if (!validateFields()) return;

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

    print('📤 Sending registration data:');
    print('userId: $userId');
    print('First Name: ${firstName.value}');
    print('Last Name: ${lastName.value}');
    print('Gender: ${gender.value}');
    print('DOB: ${dateOfBirth.value}');
    print('Email: ${email.value}');
    print('Phone: ${mobileNumber}');
    print('City: ${city.value}');
    print('Pin Code: ${pinCode.value}');
    print('State: ${state.value}');
    print('Referral Code: ${referralCode.value}');
    print('CategoryId: ${selectedCategoryId.value}');
    print('SubcategoryId: ${selectedSubCategoryId.value}');
    print('Charge: ${chargesController.text}');
    print('Aadhar No: ${aadharNo.text}');

    // ✅ Construct skills JSON
    Map<String, dynamic> skillData = {
      "categoryId": selectedCategoryId.value,
      "charge": chargesController.text,
    };

    if (selectedSubCategoryId.value.isNotEmpty) {
      skillData["sucategoryId"] = selectedSubCategoryId.value;
    }

    List<Map<String, dynamic>> skills = [skillData];
    print('Skills JSON: $skills');

    // 🔸 Add all required fields
    request.fields.addAll({
      '_id': userId,
      'userType': '2',
      'firstName': firstName.value,
      'lastName': lastName.value,
      'gender': gender.value,
      'dateOfBirth': dateOfBirth.value,
      'email': email.value,
      'phone': mobileNumber.toString(),
      'city': city.value,
      'pinCode': pinCode.value,
      'state': state.value,
      'referralCode': referralCode.value,
      'skills': jsonEncode(skills),
      'aadharNo': aadharNo.text, 'experience': selectedWorkExperience.value,
    });

    // ✅ Optional subcategory fields in SharedPreferences
    if (selectedSubCategoryId.value.isNotEmpty) {
      request.fields['subcategoryId'] = selectedSubCategoryId.value;
      await prefs.setString('subcategoryId', selectedSubCategoryId.value);
      await prefs.setString('subcategory', selectedSubCategoryName.value);
      print("✅ Subcategory ID: ${selectedSubCategoryId.value}");
      print("✅ Subcategory Name: ${selectedSubCategoryName.value}");
    }

    // 🔸 Add image if exists
    if (imagePath.value.isNotEmpty) {
      File imageFile = File(imagePath.value);

      if (await imageFile.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath('Img', imagePath.value),
        );

        final bytes = await imageFile.readAsBytes();
        final base64Image = base64Encode(bytes);

        await prefs.setString('userImgBase64', base64Image);
        await prefs.setString('userImg', imagePath.value);
        print('✅ Image saved to SharedPreferences');
      } else {
        print('❗ Image file not found: ${imagePath.value}');
      }
    }

    try {
      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();

      print('🔄 Raw Response Body: $body');

      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        final jsonRes = json.decode(body);
        print('✅ JSON Response: $jsonRes');

        final message = jsonRes['msg'] ?? 'Service provider registered';
        Get.snackbar('Success', message);

        // 🔸 Save required data to SharedPreferences
        await prefs.setString('categoryId', selectedCategoryId.value);
        await prefs.setString('category', selectedCategoryName.value);
        await prefs.setString('firstName', firstName.value);
        await prefs.setString('lastName', lastName.value);
        await prefs.setString('profession', selectedProfession.value);
        await prefs.setString('gender', gender.value);
        await prefs.setString('dob', dateOfBirth.value);
        await prefs.setString('email', email.value);
        await prefs.setString('mobile', mobileNumber!);
        await prefs.setString('city', city.value);
        await prefs.setString('pinCode', pinCode.value);
        await prefs.setString('state', state.value);
        await prefs.setString('referralCode', referralCode.value);
        await prefs.setString('aadharNo', aadharNo.text);
        await prefs.setString('charge', chargesController.text);

        await prefs.reload();

        final accountController = Get.find<ProviderAccountController>();
        await accountController.loadUserInfo();
        await accountController.loadMobileNumber();

        clearFields();
        Get.to(() => ProviderLocationView());
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