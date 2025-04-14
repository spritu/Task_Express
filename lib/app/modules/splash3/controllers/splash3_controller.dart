import 'package:get/get.dart';

import '../../login/views/login_view.dart';
import '../../signUp/views/sign_up_view.dart';

class Splash3Controller extends GetxController {
  //TODO: Implement Splash3Controller

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 3), () {
      Get.off(SignUpView()); // Navigate using GetX without back option
    });
  }



  void increment() => count.value++;
}
