import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
