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
  RxList<UserModel> usersByCategory = <UserModel>[].obs;
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> visitingProfessionals = <CategoryModel>[].obs;
  RxList<CategoryModel> fixedChargeHelpers = <CategoryModel>[].obs;
  var users = <UserModel>[].obs;
  final houseNo = Rx<String>('');var isLoading = false.obs;
  final landMark = Rx<String>('');
  final addressType = Rx<String>('');
  final contactNo = Rx<String>('');
  RxList<dynamic> searchResults = RxList([]);
  var expandedServiceType = ''.obs;
  RxBool showAllCategories = false.obs;
  final TextEditingController searchTextController = TextEditingController();
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



  void showSignupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Container(
            decoration: BoxDecoration(
            color:Color(0xffD9E4FC),
              boxShadow: [BoxShadow(blurRadius: 4, color: Color(0xFFD9E4FC))],


              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
               // horizontal: 16.0,
                vertical: 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("  "),SizedBox(width: 30,),
                        Row(
                          children: [
                            Text(
                              "Sign Up Required ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                            ),  Icon(Icons.arrow_downward),
                          ],
                        ),


                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Image.asset(
                      "assets/images/Signupbro.png",
                      height: 293,
                      width: 393,
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Please verify your mobile number to continue \nusing TaskExpress.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      height: 36.93,
                      width: 170,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF114BCA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: "poppins",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'This helps us personalize your experience and keep your data secure.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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


  /// Fetch service providers from API
  Future<void> fetchServiceProviders(String keyword) async {
    try {
      // Constructing the URL with the search keyword
      var url = Uri.parse('https://jdapi.youthadda.co/user/searchServiceProviders?name=$keyword');
      var request = http.Request('GET', url);

      // Sending the HTTP request
      http.StreamedResponse response = await request.send();

      // Checking if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Converting the response body to a string
        String responseBody = await response.stream.bytesToString();

        // Decoding the response body (JSON)
        var jsonData = jsonDecode(responseBody);

        // Checking if 'data' is a list and updating the searchResults
        if (jsonData['data'] is List) {
          searchResults.value = jsonData['data'];  // Update the observable list with data
        } else {
          searchResults.clear();  // Clear results if data is not in the expected format
        }
      } else {
        print("❌ Failed: ${response.reasonPhrase}");  // Log failure if status code isn't 200
      }
    } catch (e) {
      print("❗ Error: $e");  // Catch and log any errors
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


// user_model.dart
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



