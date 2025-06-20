import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worknest/app/modules/servicepro/views/servicepro_view.dart';
import '../../../../auth_controller.dart';
import '../../BricklayingHelper/views/bricklaying_helper_view.dart';
import '../../CementHelper/views/cement_helper_view.dart';
import '../../Scaffolding_helper/views/scaffolding_helper_view.dart';
import '../../booking/controllers/booking_controller.dart';
import '../../login/views/login_view.dart';
import '../../plastering_helper/views/plastering_helper_view.dart';
import '../../professional_plumber/controllers/professional_plumber_controller.dart';
import '../../professional_plumber/views/professional_plumber_view.dart';
import '../../professional_profile/views/professional_profile_view.dart';
import '../../road_construction_helper/views/road_construction_helper_view.dart';
import '../../tile_fixing_helper/views/tile_fixing_helper_view.dart';

class HomeController extends GetxController {
  // TODO: Implement WorknestController
  bool isUserProfile = true; // default value
  final TextEditingController plumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  RxList<UserModel> usersByCategory = <UserModel>[].obs;
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> visitingProfessionals = <CategoryModel>[].obs;
  RxList<CategoryModel> fixedChargeHelpers = <CategoryModel>[].obs;

  var users = <UserModel>[].obs;
  final houseNo = Rx<String>('');
  var isLoading = false.obs;
  final landMark = Rx<String>('');
  var skills = ''.obs;
  var charge = ''.obs;

  final addressType = Rx<String>('');
  final contactNo = Rx<String>('');
  RxBool canToggleAvailability = true.obs;
  var isAvailable = false.obs;
  var firstName = ''.obs;
  final RxList<dynamic> searchResults = <dynamic>[].obs;
  RxBool isFirstFocused = false.obs;
  FocusNode plumberFocusNode = FocusNode();
  var userType = 0.obs;

  FocusNode nameFocusNode = FocusNode();
  bool isFirstActive = true;
  //RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final TextEditingController searchPlumberController = TextEditingController();
  final TextEditingController searchNameController = TextEditingController();

  RxList<dynamic> results = RxList([]);
  var expandedServiceType = ''.obs;
  RxBool showAllCategories = false.obs;
  final TextEditingController searchTextController = TextEditingController();
  var serviceTypes =
      [
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

  RxList<dynamic> usersList = <dynamic>[].obs;
  Future<List<Map<String, dynamic>>> getSkillsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final skillsJsonString = prefs.getString('user_skills');
    if (skillsJsonString != null) {
      final skillsList = jsonDecode(skillsJsonString);
      return List<Map<String, dynamic>>.from(skillsList);
    }
    return [];
  }

  void fetchUsersListBySubcategory(String subcategoryId) async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(
          'https://jdapi.youthadda.co/user/getusersbycatsubcat?id=$subcategoryId',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        usersList.assignAll(data); // Make sure `usersList` is an RxList
        Get.to(
          () => SubcategoryUserListScreen(subcategoryName: subcategoryId),
        ); // Navigate to screen
      } else {
        //  Get.snackbar("", "Failed to load users");
      }
    } catch (e) {
      // Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, String> categoryNameMap = {};
  // Future<void> fetchUsersListByCategory(String catId, {String? categoryName}) async {
  //   print("📦 catId received: $catId");
  //   results.clear();
  //   isLoading.value = true;
  //
  //   try {
  //     fetchCategories();
  //
  //     // ✅ Call distance-fetching API directly
  //     await ProfessionalPlumberController(catId);
  //
  //     if (users.isNotEmpty) {
  //       print("✅ Going to ProfessionalPlumberView with catId: $catId");
  //
  //       Get.to(() => ProfessionalPlumberView(), arguments: {
  //         'users': users,
  //         'catId': catId,
  //         'title': categoryName ?? 'Professionals',
  //       });
  //     } else {
  //       print("➡ Navigating to ServiceproView with catId: $catId");
  //
  //       Get.to(() => ServiceproView(), arguments: {
  //         'users': users,
  //         'catId': catId,
  //         'title': categoryName ?? 'Professionals',
  //       });
  //     }
  //   } catch (e) {
  //     print("❗ Exception during fetchUsersListByCategory: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> fetchUsersListByCategory(
    String catId, {
    String? subCatId, // ⬅️ Add this
    String? categoryName,
  }) async {
    print("📦 catId received: $catId");
    if (subCatId != null) {
      print("📦 subCatId received: $subCatId");
    }

    results.clear();
    isLoading.value = true;

    try {
      // ✅ Save catId and subCatId to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedCatId', catId);
      print("💾 Saved catId to SharedPreferences: $catId");

      if (subCatId != null && subCatId.isNotEmpty) {
        await prefs.setString('selectedSubCatId', subCatId);
        print("💾 Saved subCatId to SharedPreferences: $subCatId");
      }

      // Optional category fetch
      fetchCategories();

      // 🔗 API call with both catId & subCatId
      final url = Uri.parse(
        'https://jdapi.youthadda.co/user/getusersbycatsubcat?id=$catId&subcat_id=${subCatId ?? ''}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> users = jsonData['data'];

        results.assignAll(users);
        print('uuuu:$results');

        if (results.isNotEmpty) {
          print("✅ Going to ProfessionalPlumberView with catId: $catId");

          Get.to(
            () => ProfessionalPlumberView(),
            arguments: {
              'users': results,
              'catId': catId,
              'subCatId': subCatId,
              'title': categoryName ?? 'Professionals',
            },
          );
        } else {
          print("➡ Navigating to ServiceproView with catId: $catId");

          Get.to(
            () => PlasteringHelperView(),
            arguments: {
              'users': results,
              'catId': catId,
              'subCatId': subCatId,
              'title': categoryName ?? 'Professionals',
            },
          );
        }
      } else {
        print(
          "❌ Failed to fetch users: ${response.statusCode} - ${response.reasonPhrase}",
        );
      }
    } catch (e) {
      print("❗ Exception during fetchUsersListByCategory: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void fetchUsersByName() async {
    String name = nameController.text.trim();
    if (name.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      final url = Uri.parse('https://jdapi.youthadda.co/user/getsp?name=$name');
      print("📤 Sending request to: $url");

      var request = http.Request('GET', url);
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print("📥 Raw response: $responseBody");

      final jsonData = jsonDecode(responseBody);

      // ✅ Check for `msg` field which contains the list
      if (jsonData is Map<String, dynamic> && jsonData['msg'] is List) {
        final List<dynamic> userList = jsonData['msg'];

        searchResults.value =
            userList.map((item) {
              final fullName =
                  "${item['firstName']?.trim() ?? ''} ${item['lastName']?.trim() ?? ''}";
              return {
                '_id': item['_id'],
                'name': fullName.trim(),
                'matchedIn': 'name',
                'data': item,
                'parentId': item['categoryId'] ?? '',
              };
            }).toList();

        print("📊 Parsed users count: ${searchResults.length}");
        print("✅ Fetched ${searchResults.length} results");
      } else {
        print("❌ Unexpected JSON structure: $jsonData");
        searchResults.clear();
      }
    } catch (e) {
      print("❌ Error in fetchUsersByName: $e");
      searchResults.clear();
    }
  }

  Future<void> fetchAddress() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString(
        'userId',
      ); // Retrieve the userId from SharedPreferences

      if (userId == null) {
        print("User ID not found");
        return;
      }

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/user/getmyaddress'),
      );
      request.body = json.encode({
        "userId": userId, // Use the dynamic userId
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
          var addressesList = jsonResponse['data']; // List of addresses

          // Clear any previous address data
          houseNo.value = '';
          landMark.value = '';
          addressType.value = '';
          contactNo.value = '';

          // Select the last address from the list
          var lastAddress =
              addressesList.last; // Using the last address in the list

          // Storing the fetched address fields (using the last one here)
          houseNo.value = lastAddress['houseNo'] ?? '';
          landMark.value = lastAddress['landMark'] ?? '';
          addressType.value = lastAddress['addressType'] ?? '';
          contactNo.value = lastAddress['contactNo'] ?? '';
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
      var request = http.Request(
        'GET',
        Uri.parse('https://jdapi.youthadda.co/category/getCategory'),
      );
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonData = jsonDecode(responseBody);

        if (jsonData['data'] != null) {
          var dataList = jsonData['data'] as List;
          allCategories.value =
              dataList.map((item) {
                final category = CategoryModel.fromJson(item);
                print('🖼️ Image URL: ${category.icon}'); // 🔍 Print here
                return category;
              }).toList();

          visitingProfessionals.value =
              allCategories.where((c) => c.spType == '1').toList();
          fixedChargeHelpers.value =
              allCategories.where((c) => c.spType == '2').toList();

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
        'https://jdapi.youthadda.co/user/getusersbycatsubcat?id=$categoryId',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null) {
          final dataList = jsonData['data'] as List;

          // Save skills from the first user in the list
          if (dataList.isNotEmpty) {
            final userMap = dataList.first as Map<String, dynamic>;
            final skills = userMap['skills'] ?? [];
            await saveSkillsToSharedPrefs(skills);
          }

          // Populate users
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

  Future<void> saveSkillsToSharedPrefs(List<dynamic> skills) async {
    final prefs = await SharedPreferences.getInstance();
    final skillsJsonString = jsonEncode(skills);
    await prefs.setString('user_skills', skillsJsonString);
    print("✅ Skills saved to SharedPreferences");
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
              color: Color(0xffD9E4FC),
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
                      children: [
                        Text("  "),
                        SizedBox(width: 30),
                        Row(
                          children: [
                            Text(
                              "Sign Up Required ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Icon(Icons.arrow_downward),
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
                    SizedBox(
                      height: 36.93,
                      width: 170,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF114BCA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Get.to(LoginView());
                        },
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

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    // Basic details
    userType.value = prefs.getInt('userType') ?? 0;
    firstName.value = prefs.getString('firstName') ?? '';

    // Raw skill & charge values
    final skillJson = prefs.getString('skills');
    charge.value = prefs.getString('charge') ?? '';

    if (skillJson != null && skillJson.isNotEmpty) {
      try {
        final skillMap = jsonDecode(skillJson);

        final categoryName = skillMap['categoryId']?['name'] ?? '';
        final subCategoryName = skillMap['sucategoryId']?['name'] ?? '';
        final parsedCharge = skillMap['charge']?.toString() ?? '';

        skills.value = "$categoryName - $subCategoryName";
        charge.value = parsedCharge;
      } catch (e) {
        print("❌ Error decoding skills JSON: $e");
      }
    }

    // Debug print to confirm what is loaded
    print("✅ Loaded from SharedPreferencesss:");
    print("userType: ${userType.value}");
    print("firstName: ${firstName.value}");
    print("skills raw json: ${prefs.getString('skills')}");
    print("skills parsed: ${skills.value}");
    print("charge: ₹${charge.value}");
  }

  @override
  void onInit() {
    fetchCategories();
    loadUserInfo();
    if (Get.arguments?['refreshHome'] == true) {
      fetchAddress();
    }
    if (serviceTypes.isNotEmpty) {
      expandedServiceType.value = serviceTypes.first['title']!;
      fetchAddress();
    }

    update();
    //  fetchUsersListByCategory("catId");
    plumberFocusNode.addListener(() {
      if (plumberFocusNode.hasFocus) {
        isFirstFocused.value = true;
      }
    });
    //fetchUsersByName();
    nameFocusNode.addListener(() {
      if (nameFocusNode.hasFocus) {
        isFirstFocused.value = false;
      }
    });

    super.onInit();
  }

  var searchController = TextEditingController();

  /// Fetch service providers from API
  Future<void> fetchServiceProviders(String keyword) async {
    try {
      var url = Uri.parse(
        'https://jdapi.youthadda.co/user/searchServiceProviders?name=$keyword',
      );
      var request = http.Request('GET', url);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var jsonData = jsonDecode(responseBody);

        if (jsonData['data'] is List) {
          searchResults.value = jsonData['data'];
        } else {
          searchResults.clear();
        }
      } else {
        searchResults.clear();
        print("❌ Failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      searchResults.clear();
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
    Future.delayed(Duration.zero, () {
      if (!authController.isLoggedIn.value) {
        if (onNeedContext != null) {
          onNeedContext!(showSignupSheet);
        }
      }
    });
  }

  void Function(Function(BuildContext))? onNeedContext;
  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

class CategoryModel {
  final String catid;
  final String label;
  final String icon;
  final String spType;
  final List<SubcategoryModel> subcategories; // Add a list of subcategories

  CategoryModel({
    required this.catid,
    required this.label,
    required this.icon,
    required this.spType,
    required this.subcategories, // Initialize subcategories
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    String rawIcon = json['categoryImg'] ?? '';
    String iconUrl =
        rawIcon.startsWith('http')
            ? rawIcon
            : 'https://jdapi.youthadda.co/${rawIcon.replaceFirst(RegExp(r'^/'), '')}';

    var subcategoriesList =
        (json['subcategories'] as List)
            .map((subItem) => SubcategoryModel.fromJson(subItem))
            .toList();

    return CategoryModel(
      catid: json['_id'] ?? '',
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

class UserModel {
  final String id;
  final String name;
  final List<dynamic> skills;

  UserModel({required this.id, required this.name, required this.skills});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['firstName'] ?? 'Unknown',
      skills: json['skills'] ?? [],
    );
  }
}

class SubcategoryUserListScreen extends StatelessWidget {
  final String subcategoryName;
  const SubcategoryUserListScreen({super.key, required this.subcategoryName});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(title: Text(subcategoryName)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.usersList.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        return ListView.builder(
          itemCount: controller.usersList.length,
          itemBuilder: (context, index) {
            final user = controller.usersList[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(user['name'] ?? 'No Name'),
                subtitle: Text(user['phone'] ?? 'No Phone'),
              ),
            );
          },
        );
      }),
    );
  }
}
