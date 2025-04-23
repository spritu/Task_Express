import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../BricklayingHelper/views/bricklaying_helper_view.dart';
import '../../CementHelper/views/cement_helper_view.dart';
import '../../Scaffolding_helper/views/scaffolding_helper_view.dart';
import '../../plastering_helper/views/plastering_helper_view.dart';
import '../../road_construction_helper/views/road_construction_helper_view.dart';
import '../../tile_fixing_helper/views/tile_fixing_helper_view.dart';

class HomeController extends GetxController {
  // TODO: Implement WorknestController

  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> visitingProfessionals = <CategoryModel>[].obs;
  RxList<CategoryModel> fixedChargeHelpers = <CategoryModel>[].obs;

  RxString expandedServiceType = ''.obs;
  RxBool showAllCategories = false.obs;

  List<Map<String, String>> serviceTypes = [
    {'title': 'Visiting Professionals', 'icon': '👷'},
    {'title': 'Fixed charge Helpers', 'icon': '🤖'},
  ];

  List<CategoryModel> get categories {
    if (expandedServiceType.value == 'Visiting Professionals') {
      return visitingProfessionals;
    } else if (expandedServiceType.value == 'Fixed charge Helpers') {
      return fixedChargeHelpers;
    }
    return [];
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




  // To toggle category view between expanded and collapsed
  void toggleCategoryView() {
    showAllCategories.value = !showAllCategories.value;
  }

  // To expand or collapse specific service type category
  void toggleServiceExpansion(String serviceType) {
    expandedServiceType.value = serviceType;
  }





  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  var searchController = TextEditingController();

  var searchResults = [].obs; // for storing fetched data

  /// Fetch service providers from API
  Future<void> fetchServiceProviders(String searchController) async {
    try {
      var request = http.Request(
        'GET',
        Uri.parse(
          'https://jdapi.youthadda.co/user/searchServiceProviders?name=$searchController',
        ),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var jsonData = jsonDecode(responseBody);

        // Safely check if 'data' is a list
        if (jsonData['data'] is List) {
          searchResults.value = jsonData['data'];
          print("✅ Success: ${jsonData['data']}");
        } else {
          searchResults.clear();
          print("⚠️ No data found in response.");
        }
      } else {
        print("❌ Failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❗ Error: $e");
    }
  }
  void navigateToSubcategoryScreen(String name) {
    //Get.back(); // Close bottom sheet

    Future.delayed(const Duration(milliseconds: 300), () {
      switch (name.toLowerCase()) {
        case 'bricklaying helper':
          Get.to(() => BricklayingHelperView());
          break;
        case 'cement mixing helper':
          Get.to(() => CementHelperView());
          break;
        case 'scaffolding helper':
          Get.to(() => ScaffoldingHelperView());
          break;
        case 'Plastering Helper':
          Get.to(() => PlasteringHelperView());
          break;
        case 'Tile Fixing Helper':
          Get.to(() => TileFixingHelperView());
          break;
        case 'Road Construction Helper':
          Get.to(() => RoadConstructionHelperView());
          break;
        case 'Electrician Helper':
          Get.to(() => RoadConstructionHelperView());
          break;
        default:
          Get.snackbar("Coming Soon", "This service is not available yet");
      }
    });
  }

  /// Called when search text changes
  void onSearchChanged(String value) {
    if (value.trim().isNotEmpty) {
      fetchServiceProviders(value.trim());
    } else {
      searchResults.clear(); // Clear results if input is empty
    }
  }

  final count = 0.obs;

  // RxBool showAllCategories = false.obs;
  var selectedCategory = ''.obs;
  var selectedIndex = 0.obs;

  void selectItem(int index) {
    selectedIndex.value = index;
  }

  var selectedServiceType = 'Visiting Professionals'.obs;

  void selectService(String type) {
    selectedServiceType.value = type;
  }

  void selectCategory(String label) {
    selectedCategory.value = label;
  }

  final List<String> titles1 = [
    'Visiting Professionals',
    'Fixed charge Helpres',
  ];

  final List<String> imagePath2 = [
    'assets/images/visiting.png',
    'assets/images/electretion.png',
  ];

  final List<String> titles = [
    'Electretion',
    'Plumber',
    'Gardner',
    'Home cook',
    'House worker',
    'AC Repair',
    'Pest control',
    'More',
  ];



  final services = [
    {
      'image': 'assets/images/plumber.png',
      'rating': '4.7',
      'reviews': '1.2k',
      'oldPrice': '1299',
      'price': '600',
    },
    {
      'image': 'assets/images/plumber.png',
      'rating': '4.8',
      'reviews': '7.1k',
      'oldPrice': '1299',
      'price': '600',
    },
    {
      'image': 'assets/images/plumber.png',
      'rating': '4.2',
      'reviews': '2.4k',
      'oldPrice': '1299',
      'price': '600',
    },
    {
      'image': 'assets/images/plumber.png',
      'rating': '4.2',
      'reviews': '2.4k',
      'price': '600',
    },
    {
      'image': 'assets/images/plumber.png',
      'rating': '4.2',
      'reviews': '2.4k',
      'oldPrice': '1299',
      'price': '600',
    },
    {
      'image': 'assets/images/plumber.png',
      'rating': '4.2',
      'reviews': '2.4k',
      'oldPrice': '1299',
      'price': '600',
    },
  ];

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

class CategoryModel {
  final String label;
  final String icon;
  final String spType;
  final List<SubcategoryModel> subcategories; // Add a list of subcategories

  CategoryModel({
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

    return CategoryModel(
      label: json['name'] ?? '',
      icon: iconUrl,
      spType: json['spType']?.toString() ?? '',
      subcategories: subcategoriesList, // Initialize subcategories
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



