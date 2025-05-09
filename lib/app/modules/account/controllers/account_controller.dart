// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../join/views/join_view.dart';
// import '../../login/views/login_view.dart';
//
// class AccountController extends GetxController {
//   //TODO: Implement AccountController
//   final RxString mobileNumber = ''.obs;
//   final count = 0.obs;
//   final RxString firstName = ''.obs;
//   final RxString lastName = ''.obs;
//   final RxString imagePath = ''.obs;
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadMobileNumber();
//     loadUserInfo();
//   }
//
//   Future<void> logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     Get.offAllNamed('/login'
//         '');
//     final box = GetStorage();
//     box.erase();
//
//    // Get.offAll(() => LoginView());
//   }
//
//   Future<void> loadMobileNumber() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final number = prefs.getString('mobileNumber') ?? '';
//     mobileNumber.value = number;
//     print("📱 Loaded mobile number: $number");
//   }
//
//   Future<void> loadUserInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     firstName.value = prefs.getString('firstName') ?? '';
//     lastName.value = prefs.getString('lastName') ?? '';
//   imagePath.value = prefs.getString('userImg') ?? '';// ✅ Load image URL
//     print("👤 Loaded: $firstName $lastName, 📸 Image: ${imagePath.value}");
//     print("👤Loaded from SharedPreferences: $firstName $lastName");
//
//   }
//   @override
//   void onReady() {
//     super.onReady();
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
//
//   void increment() => count.value++;
// }
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../auth_controller.dart';

class AccountController extends GetxController {
  //TODO: Implement AccountController
  final RxString mobileNumber = ''.obs;
  final count = 0.obs;
  final RxString firstName = ''.obs;
  final RxString lastName = ''.obs;
  final RxString imagePath = ''.obs;


  @override
  void onInit() {
    super.onInit();
    loadMobileNumber();
    loadUserInfo();
  }

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
    Get.offAllNamed('/login');
  }

  Future<void> loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final number = prefs.getString('mobileNumber') ?? '';
    mobileNumber.value = number;
    print("📱 Loaded mobile number: $number");
  }

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstName.value = prefs.getString('firstName') ?? '';
    lastName.value = prefs.getString('lastName') ?? '';
    imagePath.value = prefs.getString('userImg') ?? '';// ✅ Load image URL
    print("👤 Loaded: $firstName $lastName, 📸 Image: ${imagePath.value}");
    print("👤Loaded from SharedPreferences: $firstName $lastName");

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