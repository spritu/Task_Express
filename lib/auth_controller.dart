import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final box = GetStorage(); // ✅ Add this line
  var isLoggedIn = false.obs;
  var userId = ''.obs;
  var token = ''.obs;
  var email = ''.obs;
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    // ✅ Load login state from storage
    isLoggedIn.value = box.read('isLoggedIn') ?? false;
    print("Login status onInit: ${isLoggedIn.value}");
  }

  void login(String mobile) {
    box.write('isLoggedIn', true);
    box.write('mobile', mobile);
    isLoggedIn.value = true;
    print("Logged in: $mobile");
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load the user data from SharedPreferences
    String? userId2 = prefs.getString('userId2');
    String? tokenData = prefs.getString('token');
    String? emailData = prefs.getString('email');

    if (userId2 != null && userId2.isNotEmpty) {
      userId.value = userId2;  // Set the observable to the loaded value
    }

    if (tokenData != null && tokenData.isNotEmpty) {
      token.value = tokenData;
    }

    if (emailData != null && emailData.isNotEmpty) {
      email.value = emailData;
    }

    // Debug log
    print("🔑 Loaded userId: $userId.value, token: $token.value, email: $email.value");
  }
  void logout() {
    box.write('isLoggedIn', false);
    box.remove('mobile');
    isLoggedIn.value = false;
    print("Logged out");
  }
}
