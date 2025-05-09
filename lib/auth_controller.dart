import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final box = GetStorage(); // ✅ Add this line
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
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

  void logout() {
    box.write('isLoggedIn', false);
    box.remove('mobile');
    isLoggedIn.value = false;
    print("Logged out");
  }
}
