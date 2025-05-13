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
  var serviceCards = <ServiceModel>[].obs;

  void addServiceCard() {
    serviceCards.add(ServiceModel()); // adds an empty service card
  }

  final RxString selectedProfession = ''.obs;
  final RxString selectedCategoryName = ''.obs;
  final RxString selectedSubCategoryName = ''.obs;
  final RxString selectedProfessionName = ''.obs;
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

  TextEditingController chargeController = TextEditingController();
  RxString selectSubCategory = "".obs;
  RxString selectCharge = "₹ ".obs;RxString selectCharge1 = "₹ ".obs;
  final RxString mobileNumber = ''.obs;
  final count = 0.obs;
  var selectedCategoryId = ''.obs;

  final RxString firstName = ''.obs;
  final RxString lastName = ''.obs;
  final RxString imagePath = ''.obs;
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;

  List<CategoryModel> get filteredCategories {
    if (selectedProfession.value == 'Visiting Professional') {
      return visitingProfessionals;
    } else if (selectedProfession.value == 'Fixed Charge Helper') {
      return fixedChargeHelpers;
    }
    return [];
  }
  void toggleServiceCard1() {
    showServiceCard.value = !showServiceCard.value;
  }

  // void addService(ServiceModel service) {
  //   addedServices.add(service); // Add a new service to the list
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
    authController.isLoggedIn.value = false;

    // Navigate to login screen
    Get.offAllNamed('/provider-login');
  }

  var categoryOptions = <CategoryModel>[].obs;
  var subCategoryOptions = <SubcategoryModel>[].obs;


  var isLoading = true.obs;

  Future<void> loadUserInfo1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedProfessionName.value = prefs.getString('profession') ?? '';
    selectedCategoryName.value = prefs.getString('category') ?? '';
    selectedSubCategoryName.value = prefs.getString('subcategory') ?? '';
    charge.value = prefs.getString('charge') ?? '';
    isLoading.value = false;
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
  var charge = "250".obs;var charge1 = "250".obs;
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
  Future<void> deleteUserSkill(String userId, String categoryId, String subCategoryId, int index) async {
    var headers = {
      'Content-Type': 'application/json',
    };

    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/user/deleteuserskill'),
    );

    request.body = json.encode({
      "userId": userId,
      "categoryId": categoryId,
      "sucategoryId": subCategoryId, // Typo in API? Should be "subcategoryId"
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      serviceCards.removeAt(index);
      Get.snackbar("Success", "Service deleted successfully");
    } else {
      print(await response.stream.bytesToString());
      Get.snackbar("Error", "Failed to delete service");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadUserInfo(); // Reload when back from another screen
    }
  }
  @override
  void onInit()  {
    super.onInit();
    fetchCategories();
    chargeController.text = charge.value;
    loadUserInfo1();
    WidgetsBinding.instance.addObserver(this);
    loadMobileNumber();
     loadUserInfo();
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
  String subCategory;
  String charge;
  String categoryId;
  String subCategoryId;

  ServiceModel({
    this.profession = '',
    this.category = '',
    this.subCategory = '',
    this.charge = '',
    this.categoryId = '',
    this.subCategoryId = '',
  });
}

