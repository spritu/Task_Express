import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class AuthController extends GetxController {
//   final box = GetStorage(); // ✅ Add this line
//   var isLoggedIn = false.obs;
//   var isLoggedIn2 = false.obs;
//   var userId = ''.obs;
//   var token = ''.obs;
//   var email = ''.obs;
//   @override
//   void onInit() {
//     super.onInit();
//     _loadUserData();_loadLoginStatus();
//     // ✅ Load login state from storage
//     isLoggedIn.value = box.read('isLoggedIn') ?? false;
//     isLoggedIn.value = box.read('isLoggedIn2') ?? false;
//     print("Login status onInit: ${isLoggedIn.value}");
//     print("Login status onInit: ${isLoggedIn2.value}");
//   }
//   void login(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', true);
//     await prefs.setString('token', token);
//     isLoggedIn.value = true;
//   }
//
//   // void login(String mobile) {
//   //   box.write('isLoggedIn', true);
//   //   box.write('mobile', mobile);
//   //   isLoggedIn.value = true;
//   //   print("Logged in: $mobile");
//   // }
//   void login2(String mobile) {
//     box.write('isLoggedIn', true);
//     box.write('mobile', mobile);
//     isLoggedIn2.value = true;
//     print("Logged in: $mobile");
//   }
//   void _loadLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final loggedIn = prefs.getBool('isLoggedIn') ?? false;
//     isLoggedIn.value = loggedIn;
//   }
//   Future<void> _loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Load the user data from SharedPreferences
//     String? userId2 = prefs.getString('userId2');
//     String? tokenData = prefs.getString('token');
//     String? emailData = prefs.getString('email');
//
//     if (userId2 != null && userId2.isNotEmpty) {
//       userId.value = userId2; // Set the observable to the loaded value
//     }
//
//     if (tokenData != null && tokenData.isNotEmpty) {
//       token.value = tokenData;
//     }
//
//     if (emailData != null && emailData.isNotEmpty) {
//       email.value = emailData;
//     }
//
//     // Debug log
//     print(
//       "🔑 Loaded userId: $userId.value, token: $token.value, email: $email.value",
//     );
//   }
//   void logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     isLoggedIn.value = false;
//   }
//
//   // void logout() {
//   //   box.write('isLoggedIn', false);
//   //   box.remove('mobile');
//   //   isLoggedIn.value = false;
//   //   print("Logged out");
//   // }
//   void logout2() {
//     box.write('isLoggedIn2', false);
//     box.remove('mobile');
//     isLoggedIn2.value = false;
//     print("Logged out");
//   }
// }
class AuthController extends GetxController {
  final box = GetStorage();
  var isLoggedIn = false.obs;
  var isLoggedIn2 = false.obs;
  var userId = ''.obs;
  var token = ''.obs;
  var email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    isLoggedIn.value = box.read('isLoggedIn') ?? false;
    isLoggedIn2.value = box.read('isLoggedIn2') ?? false;

    print("Login status isLoggedIn: ${isLoggedIn.value}");
    print("Login status isLoggedIn2: ${isLoggedIn2.value}");
  }

  void login({required String tokenValue, required String userIdValue, required String emailValue}) {
    box.write('isLoggedIn', true);
    box.write('token', tokenValue);
    box.write('userId2', userIdValue);
    box.write('email', emailValue);

    token.value = tokenValue;
    userId.value = userIdValue;
    email.value = emailValue;
    isLoggedIn.value = true;
  }

  void login2({required String mobile}) {
    box.write('isLoggedIn2', true);
    box.write('mobile', mobile);
    isLoggedIn2.value = true;
  }

  void logout() {
    box.erase();
    isLoggedIn.value = false;
    isLoggedIn2.value = false;
    userId.value = '';
    token.value = '';
    email.value = '';
    print("User logged out");
  }

  Future<void> _loadUserData() async {
    userId.value = box.read('userId2') ?? '';
    token.value = box.read('token') ?? '';
    email.value = box.read('email') ?? '';
    print("🔑 Loaded userId: ${userId.value}, token: ${token.value}, email: ${email.value}");
  }
}
