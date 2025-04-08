import 'package:get/get.dart';

class HomeController extends GetxController {
  // TODO: Implement WorknestController
  var expandedServiceType = ''.obs;
  final count = 0.obs;
  RxBool showAllCategories = false.obs;
  var selectedCategory = ''.obs;
  var selectedIndex = 0.obs;
  void toggleServiceExpansion(String title) {
    if (expandedServiceType.value == title) {
      expandedServiceType.value = ''; // Collapse if same is tapped
    } else {
      expandedServiceType.value = title; // Expand new one
    }
  }
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

  // final List<Map<String, String>> categories = [
  //   {'label': 'Electrition', 'icon': '⚡'},
  //   {'label': 'Plumber', 'icon': '🔧'},
  //   {'label': 'Carpenter', 'icon': '🪚'},
  //   {'label': 'Painter', 'icon': '🎨'},
  //   {'label': 'AC/Fridge Repair', 'icon': '❄️'},
  //   {'label': 'Pest Control', 'icon': '🪳'},
  //   {'label': 'House Cleaning', 'icon': '🏠'},
  //   {'label': 'More', 'icon': '➕'},
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


  List<Map<String, String>> categories = [
    {'icon': '🛠️', 'label': 'Repair'},
    {'icon': '💡', 'label': 'Electrician'},
    {'icon': '🚿', 'label': 'Plumber'},
    {'icon': '🧹', 'label': 'Cleaning'},
    {'icon': '📦', 'label': 'Moving'},
    {'icon': '🧼', 'label': 'Laundry'},
    {'icon': '🖌️', 'label': 'Painting'},
    {'icon': '🪑', 'label': 'Furniture'},
    {'icon': '🛏️', 'label': 'Carpentry'},
    {'icon': '🧯', 'label': 'Fire Safety'},
    {'icon': '🛠️', 'label': 'Repair'},
    {'icon': '💡', 'label': 'Electrician'},
    {'icon': '🚿', 'label': 'Plumber'},
    {'icon': '🧹', 'label': 'Cleaning'},
    {'icon': '🚿', 'label': 'Plumber'},
    {'icon': '🧹', 'label': 'Cleaning'},
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

  void toggleCategoryView() {
    showAllCategories.value = !showAllCategories.value;
  }
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