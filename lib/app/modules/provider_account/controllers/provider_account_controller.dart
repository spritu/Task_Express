import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../auth_controller.dart';
import 'package:http/http.dart' as http;

class ProviderAccountController extends GetxController with WidgetsBindingObserver {
  //TODO: Implement ProviderAccountController
  var imagePath = ''.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var mobileNumber = ''.obs;
  RxString userId = ''.obs;
  var skillList = <Map<String, dynamic>>[].obs;
  var selectedProfessionName = ''.obs;
  var spType = ''.obs;


  var selectedCategoryName = ''.obs;
  var selectedSubCategoryName = ''.obs;
  var charge = ''.obs;

  var email = ''.obs;
  var serviceCards = <ServiceModel>[].obs;
  var isEditingCharge = false.obs;
  RxList<CategoryModel> filteredCategories = <CategoryModel>[].obs;

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profileImage = prefs.getString('profileImage');
    if (profileImage != null && !profileImage.startsWith('http')) {
      profileImage = 'https://jdapi.youthadda.co/$profileImage';
    }

    imagePath.value = profileImage ?? '';
    firstName.value = prefs.getString('firstName') ?? '';
    lastName.value = prefs.getString('lastName') ?? '';
    mobileNumber.value = prefs.getString('mobile') ?? '';
  }
  void addServiceCard() {
    serviceCards.add(ServiceModel(profession: '', category: '', charge: '', subcategory: '', categoryId: '', subCategoryId: '')); // adds an empty service card
  }
  final RxString selectedProfession = ''.obs;
  RxBool showServiceCard = false.obs;
  RxList<CategoryModel> visitingProfessionals = <CategoryModel>[].obs;
  RxList<CategoryModel> fixedChargeHelpers = <CategoryModel>[].obs;
  bool isEditable = false;
  RxString selectCategory = "".obs;
 // var addedServices = <ServiceModel>[].obs; // List to hold added services
  var addedServices = <Service>[].obs;

  // Add a service
  void addService() {
    // Add a new service object to the list
    addedServices.add(Service(
      profession: "Plumbing",
      category: "Repair",
      subCategory: "Pipe Repair",
      charge: "₹500",
    ));
  }
  Future<void> loadCompleteUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstName.value = prefs.getString('firstName') ?? '';
    lastName.value = prefs.getString('lastName') ?? '';
    mobileNumber.value = prefs.getString('mobile') ?? '';
    email.value = prefs.getString('email') ?? '';
    selectedProfessionName.value = prefs.getString('profession') ?? '';
    selectedCategoryName.value = prefs.getString('category') ?? '';
    selectedSubCategoryName.value = prefs.getString('subcategory') ?? '';
    charge.value = prefs.getString('charge') ?? '';
    userId.value = prefs.getString('userId') ?? '';

    String? image = prefs.getString('image');
    if (image != null && !image.startsWith('http')) {
      image = 'https://jdapi.youthadda.co/$image';
    }

    imagePath.value = image ?? '';
    await prefs.setString('image', imagePath.value);

    String? base64Image = prefs.getString('userImgBase64');
    if (base64Image != null && base64Image.isNotEmpty) {
      final bytes = base64Decode(base64Image);
      final tempFile = await File('${Directory.systemTemp.path}/profile.jpg').writeAsBytes(bytes);
      imagePath.value = tempFile.path;
    }

    print("✅ Loaded full user data: ${firstName.value} ${lastName.value}, 📱: ${mobileNumber.value}");
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedImage = prefs.getString('image') ?? '';
    String? image = prefs.getString('image');

// If it's just the file name and needs to be combined with base URL
    if (image != null && !image.startsWith('http')) {
      image = 'https://jdapi.youthadda.co/$image';
    }

    imagePath.value = image ?? '';
    await prefs.setString('image', imagePath.value); // ✅ Safe fallback
    String? userId = prefs.getString('userId');
    String? token = prefs.getString('token');
    String? email = prefs.getString('email');
    firstName.value = prefs.getString('firstName') ?? '';
    lastName.value = prefs.getString('lastName') ?? '';
    String? mobile = prefs.getString('mobile');
    imagePath.value = prefs.getString('image') ?? '';
    print("🖼️ Loaded image path: ${imagePath.value}");

    print("👤 Loaded: $firstName $lastName, 📸 Image: ${imagePath.value}");
    print("📦 Stored Data:");
    print("🔑 userId: $userId");
    print("🔑 token: $token");
    print("📧 email: $email");
    print("👤 firstName: $firstName");
    print("👤 lastName: $lastName");
    print("📱 mobile: $mobile");
  }
  TextEditingController chargeController = TextEditingController();
  RxString selectSubCategory = "".obs;

  RxString selectCharge = "₹ ".obs;RxString selectCharge1 = "₹ ".obs;

  final count = 0.obs;
  var selectedCategoryId = ''.obs;


  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;

  // List<CategoryModel> get filteredCategories {
  //   if (selectedProfession.value == 'Visiting Professional') {
  //     return visitingProfessionals;
  //   } else if (selectedProfession.value == 'Fixed Charge Helper') {
  //     return fixedChargeHelpers;
  //   }
  //   return [];
  // }
  void toggleServiceCard1() {
    showServiceCard.value = !showServiceCard.value;
  }

  // Future<void> loadUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   firstName.value = prefs.getString('firstName') ?? '';
  //   lastName.value = prefs.getString('lastName') ?? '';
  //   mobileNumber.value = prefs.getString('mobile') ?? '';
  //   email.value = prefs.getString('email') ?? '';
  //
  //   print("✅ Loaded User Data:");
  //   print("👤 First Name: ${firstName.value}");
  //   print("👤 Last Name: ${lastName.value}");
  //   print("📧 Email: ${email.value}");
  //   print("📱 Mobile: ${mobileNumber.value}");
  // }
  Future<void> logout() async {
    // Clear SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Clear GetStorage
    final box = GetStorage();
    await box.erase();

    // Set login status to false in AuthController
    final authController = Get.find<AuthController>();
    authController.isLoggedIn2.value = false;

    // Navigate to login screen
    Get.offAllNamed('/join');
  }

  var categoryOptions = <CategoryModel>[].obs;
  var subCategoryOptions = <SubcategoryModel>[].obs;


  var isLoading = true.obs;
  String get spTypeLabel {
    switch (spType.value) {
      case '1':
        return 'Visiting Professional';
      case '2':
        return 'Fixed Charge Helper';
      default:
        return 'Unknown';
    }
  }
  Future<void> loadUserInfo1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    spType.value = prefs.getString('spType') ?? '';
    print("📥 Loaded spType: ${spType.value}");

    if (spType == "1") {
      print("🧑 Visiting Professional");
    } else if (spType == "2") {
      print("🛠️ Fixed Charge Helper");
    } else {
      print("❌ spType not found or invalid");
    }
    selectedProfessionName.value = prefs.getString('profession') ?? '';
    print("🧾 selectedProfessionName: ${selectedProfessionName.value}");
    userId.value = prefs.getString('userId') ?? '';
    selectedProfessionName.value = prefs.getString('profession') ?? '';
    selectedCategoryName.value = prefs.getString('category') ?? '';
    selectedSubCategoryName.value = prefs.getString('subCategory') ?? ''; // <- fixed key
    charge.value = prefs.getString('charge') ?? '';
    isLoading.value = false;

    print("🔄 Loaded User Info:");
    print("🧑‍💼 Profession: ${selectedProfessionName.value}");
    print("📂 Category: ${selectedCategoryName.value}");
    print("📁 Subcategory: ${selectedSubCategoryName.value}");
    print("💰 Charge: ${charge.value}");
  }



  void toggleEditState() {
    isEditable = !isEditable;
    if (!isEditable) {
      charge.value = chargeController.text; // Save the new value when editing is done
    }
    update(); // Update the UI
  }

  void toggleServiceCard() {
    showServiceCard.value = !showServiceCard.value;
  }
var charge1 = "250".obs;
  void setCharge(String charge) {
    selectCharge.value = charge;
  }
  void saveCharge1(String charge1) {
    selectCharge1.value = charge1;
  }
  void setProfession(String profession) {
    selectedProfession.value = profession;
  }
  void setSubCategory(String SubCategory) {
    selectSubCategory.value = SubCategory;
  }
  void setCategory(String category) {
    selectedCategoryId.value = category;
  }

  Future<void> loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final number = prefs.getString('mobileNumber') ?? '';
    mobileNumber.value = number;
    print("📱 Loaded mobile number: $number");
  }
  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    firstName.value = prefs.getString('firstName') ?? '';
    lastName.value = prefs.getString('lastName') ?? '';
    mobileNumber.value = prefs.getString('mobile') ?? '';
    String? image = prefs.getString('image');

// If it's just the file name and needs to be combined with base URL
    if (image != null && !image.startsWith('http')) {
      image = 'https://jdapi.youthadda.co/$image';
    }

    imagePath.value = image ?? '';
    await prefs.setString('image', imagePath.value); // ✅ Safe fallback

    String? base64Image = prefs.getString('userImgBase64');

    if (base64Image != null && base64Image.isNotEmpty) {
      final bytes = base64Decode(base64Image);
      final tempDir = Directory.systemTemp;
      final file = await File('${tempDir.path}/profile.jpg').writeAsBytes(bytes);
      imagePath.value = file.path;
    }

    print("✅ Reloaded: ${firstName.value}, ${mobileNumber.value}");
  }

  void fetchCategories() async {
    try {
      var request = http.Request('GET', Uri.parse('https://jdapi.youthadda.co/category/getCategory'));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonData = jsonDecode(responseBody);

        if (jsonData['data'] != null) {
          var dataList = jsonData['data'] as List;
          allCategories.value = dataList.map((item) {
            final category = CategoryModel.fromJson(item);
            print('🖼️ Image URL: ${category.icon}'); // 🔍 Print here
            return category;
          }).toList();

          visitingProfessionals.value = allCategories.where((c) => c.spType == '1').toList();
          fixedChargeHelpers.value = allCategories.where((c) => c.spType == '2').toList();

          print("✅ Categories loaded");
        }
      } else {
        print('❌ Failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('❗ Error: $e');
    }
  }

  Future<void> updateSkill({
    required String userId,
    required String categoryId,
    required String subcategoryId,
    required String charge,
  }) async {
    final url = Uri.parse('https://jdapi.youthadda.co/user/updateskills');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "userId": userId,
      "categoryId": categoryId,
      "sucategoryId": subcategoryId,
      "charge": charge,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("✅ Skill updated successfully: ${response.body}");
      } else {
        print("❌ Failed to update skill: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ Exception while updating skill: $e");
    }
  }



  Future<void> deleteUserSkill(String categoryId, String subCategoryId, int index) async {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Service"),
        content: const Text("Are you sure you want to delete this service?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Cancel
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Close the dialog
              try {
                var headers = {'Content-Type': 'application/json'};
                var request = http.Request(
                  'POST',
                  Uri.parse('https://jdapi.youthadda.co/user/deleteuserskill'),
                );

                // Get the userId from SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                final userId = prefs.getString('userId') ?? '';
                print("User ID: $userId"); // Debugging

                // Prepare the request body
                request.body = json.encode({
                  "userId": userId,
                  "categoryId": categoryId,
                  "subcategoryId": subCategoryId, // Ensure correct key
                });

                // Add headers to the request
                request.headers.addAll(headers);

                // Send the request
                http.StreamedResponse response = await request.send();

                // Log the response for debugging
                print("Response status: ${response.statusCode}");
                print("Response body: ${await response.stream.bytesToString()}");

                if (response.statusCode == 200) {
                  // If the API call is successful, remove the item from the list
                  serviceCards.removeAt(index); // Remove the card at the given index
              serviceCards.refresh(); // Refresh the list to update UI

                  // Show success message
                 // Get.snackbar("Deleted", "Service deleted successfully");
                } else {
                  // Do not remove the card if the API fails
               //   Get.snackbar("Error", "Failed to delete: ${response.reasonPhrase}");
                }
              } catch (e) {
                // Handle any exceptions and print to debug
                print("Error: $e");
             //   Get.snackbar("Error", "Something went wrong");
              }
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }






  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadUserInfo(); // Reload when back from another screen
    }
  }
  @override
  void onInit()  {
    super.onInit();loadUserData();
    fetchCategories(); _loadUserData();
    chargeController.text = charge.value;
    loadUserInfo1();
    WidgetsBinding.instance.addObserver(this);
    loadMobileNumber();
     loadUserInfo();
  }
  void updateFilteredCategories(String profession) {
    if (profession == "Visiting Professional") {
      filteredCategories.value = visitingProfessionals;
    } else if (profession == "Fixed Charge Helper") {
      filteredCategories.value = fixedChargeHelpers;
    } else {
      filteredCategories.clear();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void increment() => count.value++;
}
// class CategoryModel {
//   final String id;
//   final String label;
//   final String icon;
//   final String spType;
//   final List<SubcategoryModel> subcategories; // Add a list of subcategories
//
//   CategoryModel({ required this.id,
//     required this.label,
//     required this.icon,
//     required this.spType,
//     required this.subcategories, // Initialize subcategories
//   });
//
//   factory CategoryModel.fromJson(Map<String, dynamic> json) {
//     String rawIcon = json['categoryImg'] ?? '';
//     String iconUrl = rawIcon.startsWith('http')
//         ? rawIcon
//         : 'https://jdapi.youthadda.co/${rawIcon.replaceFirst(RegExp(r'^/'), '')}';
//
//     var subcategoriesList = (json['subcategories'] as List)
//         .map((subItem) => SubcategoryModel.fromJson(subItem))
//         .toList();
//
//     return CategoryModel(id:json['_id'] ?? '',
//       label: json['name'] ?? '',
//       icon: iconUrl,
//       spType: json['spType']?.toString() ?? '',
//       subcategories: subcategoriesList, // Initialize subcategories
//     );
//   }
// }
class CategoryModel {
  final String id;
  final String label;
  final String icon;
  final String spType;
  final List<SubcategoryModel> subcategories; // Add a list of subcategories

  CategoryModel({ required this.id,
    required this.label,
    required this.icon,
    required this.spType,
    required this.subcategories, // Initialize subcategories
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    String rawIcon = json['categoryImg'] ?? '';
    String iconUrl = rawIcon.startsWith('http')
        ? rawIcon
        : 'https://jdapi.youthadda.co/${rawIcon.replaceFirst(RegExp(r'^/'), '')}';

    var subcategoriesList = (json['subcategories'] as List)
        .map((subItem) => SubcategoryModel.fromJson(subItem))
        .toList();

    return CategoryModel(id:json['_id'] ?? '',
      label: json['name'] ?? '',
      icon: iconUrl,
      spType: json['spType']?.toString() ?? '',
      subcategories: subcategoriesList, // Initialize subcategories
    );
  }
}
class SubcategoryModel {
  final String subId;
  final String name;
  final String description;

  SubcategoryModel({
    required this.subId,
    required this.name,
    required this.description,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      subId: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // Optional: If you want to access `subId` as `id`
  String get id => subId;
}

  // Optional: If you want to access `subId` as `id`




class Service {
  String profession;
  String category;
  String subCategory;
  String charge;

  Service({
    required this.profession,
    required this.category,
    required this.subCategory,
    required this.charge,
  });
}
class ServiceModel {
  String profession;
  String category;
  String subcategory;
  String charge;
  String categoryId;
  String subCategoryId;

  ServiceModel({
    required this.profession,
    required this.category,
    required this.subcategory,
    required this.charge,
    required this.categoryId,
    required this.subCategoryId,
  });
}




class UserSkillModel {
  final String userId;
  final String categoryId;
  final String subCategoryId;
  final String profession;
  final String category;
  final String subCategory;
  final String charge;

  UserSkillModel({
    required this.userId,
    required this.categoryId,
    required this.subCategoryId,
    required this.profession,
    required this.category,
    required this.subCategory,
    required this.charge,
  });
}
