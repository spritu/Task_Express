import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../BricklayingHelper/views/bricklaying_helper_view.dart';
import '../../CementHelper/views/cement_helper_view.dart';
import '../../Scaffolding_helper/views/scaffolding_helper_view.dart';
import '../../plastering_helper/views/plastering_helper_view.dart';
import '../../road_construction_helper/views/road_construction_helper_view.dart';
import '../../tile_fixing_helper/views/tile_fixing_helper_view.dart';

class HomeController extends GetxController {
  // TODO: Implement WorknestController
  final houseNo = Rx<String>('');
  final landMark = Rx<String>('');
  final addressType = Rx<String>('');
  final contactNo = Rx<String>('');
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> visitingProfessionals = <CategoryModel>[].obs;
  RxList<CategoryModel> fixedChargeHelpers = <CategoryModel>[].obs;

  var expandedServiceType = ''.obs;
  RxBool showAllCategories = false.obs;

  var serviceTypes = [
    {'title': 'Visiting Professionals'},
    {'title': 'Fixed charge Helpers'},
  ].obs;
  List<CategoryModel> get categories {
    if (expandedServiceType.value == 'Visiting Professionals') {
      return visitingProfessionals;
    } else if (expandedServiceType.value == 'Fixed charge Helpers') {
      return fixedChargeHelpers;
    }
    return [];
  }

  Future<void> fetchAddress() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');  // Retrieve the userId from SharedPreferences

      if (userId == null) {
        print("User ID not found");
        return;
      }

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://jdapi.youthadda.co/user/getmyaddress'));
      request.body = json.encode({
        "userId": userId,  // Use the dynamic userId
      });
      request.headers.addAll(headers);

      print("Sending request...");

      http.StreamedResponse response = await request.send();

      print("Response received, status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        print("Raw Response: $responseString");

        var jsonResponse = json.decode(responseString);

        if (jsonResponse['data'] != null && jsonResponse['data'].isNotEmpty) {
          var addressesList = jsonResponse['data'];  // List of addresses

          // Clear any previous address data
          houseNo.value = '';
          landMark.value = '';
          addressType.value = '';
          contactNo.value = '';

          // Select the last address from the list
          var lastAddress = addressesList.last;  // Using the last address in the list

          // Storing the fetched address fields (using the last one here)
          houseNo.value = lastAddress['houseNo'] ?? '';
          landMark.value = lastAddress['landMark'] ?? '';
          addressType.value = lastAddress['addressType'] ?? '';
          contactNo.value = lastAddress['contactNo'] ?? '';

          print("Fetched houseNo: ${houseNo.value}");
          print("Fetched landMark: ${landMark.value}");
          print("Fetched addressType: ${addressType.value}");
          print("Fetched contactNo: ${contactNo.value}");
        } else {
          print("Data empty or not found in response");
        }
      } else {
        print("Request failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
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
  void toggleServiceExpansion(String title) {
    if (expandedServiceType.value == title) {
      expandedServiceType.value = ''; // Collapse if already selected
    } else {
      expandedServiceType.value = title; // Expand the clicked one
    }
  }





  @override
  void onInit() {
    fetchCategories();
    if (serviceTypes.isNotEmpty) {
      expandedServiceType.value = serviceTypes.first['title']!;
      fetchAddress();
    }
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
      'Name': 'Plumber',
      'reviews': '1.2k',
      'oldPrice': '1299',
      'price': '600',
    },
    {
      'image': 'assets/images/plumber.png',
      'Name': 'Electretion',
      'reviews': '7.1k',
      'oldPrice': '1299',
      'price': '600',
    },
    {
      'image': 'assets/images/plumber.png',
      'Name': 'House Cleaning',
      'reviews': '2.4k',
      'oldPrice': '1299',
      'price': '600',
    },
    {
      'image': 'assets/images/plumber.png',
      'Name': 'Laundry',
      'reviews': '2.4k',
      'price': '600',
    },
    {
      'image': 'assets/images/plumber.png',
      'Name': 'Carpenter',
      'reviews': '2.4k',
      'oldPrice': '1299',
      'price': '600',
    },
    {
      'image': 'assets/images/plumber.png',
      'Name': 'Pest Control',
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



