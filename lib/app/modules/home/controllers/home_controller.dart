import 'package:get/get.dart';

class HomeController extends GetxController {
  // TODO: Implement WorknestController
  RxString expandedServiceType = ''.obs;
  RxBool showAllCategories = false.obs;

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

  RxList<Map<String, String>> categories = <Map<String, String>>[].obs;

  void toggleServiceExpansion(String selectedTitle) {
    if (expandedServiceType.value == selectedTitle) {
      expandedServiceType.value = '';
      categories.clear();
    } else {
      expandedServiceType.value = selectedTitle;
      showAllCategories.value = false;

      // Update categories based on selection
      if (selectedTitle == 'Visiting Professionals') {
        categories.value = visitingCategories;
      } else if (selectedTitle == 'Fixed charge Helpers') {
        categories.value = fixedChargeCategories;
      }
    }
  }

  void toggleCategoryView() {
    showAllCategories.value = !showAllCategories.value;
  }
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
  final List<Map<String, String>> serviceTypes = [
    {'title': 'Visiting Professionals', 'icon': '👷'},
    {'title': 'Fixed charge Helpres', 'icon': '🤖'},
  ];



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

  // void toggleCategoryView() {
  //   showAllCategories.value = !showAllCategories.value;
  // }
  @override
  void onInit() {
    super.onInit();
  }

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