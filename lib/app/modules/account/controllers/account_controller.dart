
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../auth_controller.dart';

class AccountController extends GetxController {
  //TODO: Implement AccountController
  final RxString mobileNumber = ''.obs;
  final count = 0.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;

  final RxString imagePath = ''.obs;


  @override
  void onInit() {
    super.onInit();
    loadMobileNumber();
    _loadUserData();
  }
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('userId');
    String? token = prefs.getString('token');
    String? email = prefs.getString('email');
    firstName.value = prefs.getString('firstName') ?? '';
    lastName.value = prefs.getString('lastName') ?? '';
    String? mobile = prefs.getString('mobile');

    print("📦 Stored Data:");
    print("🔑 userId: $userId");
    print("🔑 token: $token");
    print("📧 email: $email");
    print("👤 firstName: $firstName");
    print("👤 lastName: $lastName");
    print("📱 mobile: $mobile");
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