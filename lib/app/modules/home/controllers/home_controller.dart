import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void toggleServiceExpansion(String title) {
    if (expandedServiceType.value == title) {
      expandedServiceType.value = '';
    } else {
      expandedServiceType.value = title;
    }
    showAllCategories.value = false;
  }

  void toggleCategoryView() {
    showAllCategories.value = !showAllCategories.value;
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



  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  var searchController = TextEditingController();
  // Dummy data for each service type
  List<Map<String, String>> visitingCategories = [
    {'label': 'Construction', 'icon': 'assets/images/image.png'},
    {'label': 'Plumber', 'icon': 'assets/images/image.png'},
    {'label': 'Painter', 'icon': 'assets/images/image.png'},
    {'label': 'Electrician', 'icon': 'assets/images/image.png'},
    {'label': 'Carpenter', 'icon': 'assets/images/image.png'},
    {'label': 'Welder', 'icon': 'assets/images/image.png'},
    {'label': 'Gardener', 'icon': 'assets/images/image.png'},
    {'label': 'Cleaner', 'icon': 'assets/images/image.png'},
  ];

  List<Map<String, String>> fixedChargeCategories = [
    {'label': 'AC Service', 'icon': '❄️'},
    {'label': 'Washing Machine', 'icon': '🧺'},
    {'label': 'Fridge Repair', 'icon': '🧊'},
    {'label': 'TV Repair', 'icon': '📺'},
    {'label': 'Fan Repair', 'icon': '🌀'},
    {'label': 'Geyser', 'icon': '🔥'},
    {'label': 'Microwave', 'icon': '🍲'},
    {'label': 'More', 'icon': '➕'},
  ];
// for UI binding




  var searchResults = [].obs; // for storing fetched data

  /// Fetch service providers from API
  Future<void> fetchServiceProviders(String searchController) async {

    try {
      var request = http.Request(
        'GET',
        Uri.parse('https://jdapi.youthadda.co/user/searchServiceProviders?name=$searchController'),
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

  /// Called when search text changes
  void onSearchChanged(String value) {
    if (value.trim().isNotEmpty) {
      fetchServiceProviders(value.trim());
    } else {
      searchResults.clear(); // Clear results if input is empty
    }
  }
 // RxList<Map<String, String>> categories = <Map<String, String>>[].obs;

  // void toggleServiceExpansion(String selectedTitle) {
  //   if (expandedServiceType.value == selectedTitle) {
  //     expandedServiceType.value = '';
  //     categories.clear();
  //   } else {
  //     expandedServiceType.value = selectedTitle;
  //     showAllCategories.value = false;
  //
  //     // Update categories based on selection
  //     if (selectedTitle == 'Visiting Professionals') {
  //       categories.value = visitingCategories;
  //     } else if (selectedTitle == 'Fixed charge Helpers') {
  //       categories.value = fixedChargeCategories;
  //     }
  //   }
  // }
  //
  // void toggleCategoryView() {
  //   showAllCategories.value = !showAllCategories.value;
  // }
//  var expandedServiceType = ''.obs;
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
  // final List<Map<String, String>> serviceTypes = [
  //   {'title': 'Visiting Professionals', 'icon': '👷'},
  //   {'title': 'Fixed charge Helpres', 'icon': '🤖'},
  // ];



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

  final List<String> imagePaths = [
    'assets/images/plumber.png',
    'assets/images/plumber.png',
    'assets/images/plumber.png',
    'assets/images/plumber.png',
    'assets/images/plumber.png',
    'assets/images/plumber.png',
    'assets/images/plumber.png',
    'assets/images/plumber.png',
  ];



  final services = [
    {
      'image': 'assets/images/plumber.png',
      'rating': '4.7',
      'reviews': '1.2k',
      'oldPrice': '1299',
      'price':'600'
    },
    {
      'image': 'assets/images/plumber.png',
      'rating': '4.8',
      'reviews': '7.1k',
      'oldPrice': '1299', 'price':'600'
    },
    {
      'image': 'assets/images/plumber.png',
      'rating': '4.2',
      'reviews': '2.4k',
      'oldPrice': '1299', 'price':'600'
    }, {
      'image': 'assets/images/plumber.png',
      'rating': '4.2',
      'reviews': '2.4k', 'price':'600'
    }, {
      'image': 'assets/images/plumber.png',
      'rating': '4.2',
      'reviews': '2.4k',
      'oldPrice': '1299', 'price':'600'
    }, {
      'image': 'assets/images/plumber.png',
      'rating': '4.2',
      'reviews': '2.4k',
      'oldPrice': '1299', 'price':'600'
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

  CategoryModel({
    required this.label,
    required this.icon,
    required this.spType,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    String rawIcon = json['categoryImg'] ?? '';
    String iconUrl = rawIcon.startsWith('http')
        ? rawIcon
        : 'https://jdapi.youthadda.co/${rawIcon.replaceFirst(RegExp(r'^/'), '')}';

    return CategoryModel(
      label: json['name'] ?? '',
      icon: iconUrl,
      spType: json['spType']?.toString() ?? '',
    );
  }

}



