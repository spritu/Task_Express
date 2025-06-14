
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../auth_controller.dart';

class AccountController extends GetxController {
  //TODO: Implement AccountController
  final RxString mobileNumber = ''.obs;
  var count = 0.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var gender = ''.obs;  var state = ''.obs;var referralCode = ''.obs;
  var dob = ''.obs; var city = ''.obs;var pinCode = ''.obs;
 // var imagePath = ''.obs;
  var userType = 0.obs;


  final RxString imagePath = ''.obs;



  @override
  void onInit() {
    super.onInit();
    loadMobileNumber(); update();
    //loadProfileImage();
    _loadUserData();loadUserInfo();
  }


  // Future<void> loadProfileImage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? storedImage = prefs.getString('userImg'); // 👈 use same key
  //   if (storedImage != null && storedImage.isNotEmpty) {
  //     imagePath.value = storedImage;
  //   }
  // }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userType.value = prefs.getInt('userType') ?? 0;
    firstName.value = prefs.getString('firstName') ?? '';
    lastName.value = prefs.getString('lastName') ?? '';
    mobileNumber.value = prefs.getString('mobileNumber') ?? '';
    gender.value = prefs.getString('gender') ?? '';
    dob.value = prefs.getString('dob') ?? '';
    email.value = prefs.getString('email') ?? '';
    city.value = prefs.getString('city') ?? '';
    state.value = prefs.getString('state') ?? '';
    referralCode.value = prefs.getString('referralCode') ?? '';
    pinCode.value = prefs.getString('pinCode') ?? '';

    // ✅ Debug prints — copy this block as-is:
    print('🔑 Loaded userType: ${userType.value}');
    print('👤 Loaded firstName: ${firstName.value}');
    print('👤 Loaded lastName: ${lastName.value}');
    print('📱 Loaded mobileNumber: ${mobileNumber.value}');
    print('⚧️ Loaded gender: ${gender.value}');
    print('🎂 Loaded dob: ${dob.value}');
    print('📧 Loaded email: ${email.value}');
    print('🏙️ Loaded city: ${city.value}');
    print('🏞️ Loaded state: ${state.value}');
    print('📌 Loaded pinCode: ${pinCode.value}');
    print('🏷️ Loaded referralCode: ${referralCode.value}');
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
    Get.offAllNamed('/join');
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
    imagePath.value = prefs.getString('userImg') ?? '';  // ✅ Load saved image URL
   // selectedImagePath.value = ''; // Reset local image
    print("👤 Loaded user: $firstName $lastName, Image: ${imagePath.value}");
  }


  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;// auto referesh
}