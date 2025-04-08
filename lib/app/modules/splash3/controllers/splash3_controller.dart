import 'package:get/get.dart';

import '../../login/views/login_view.dart';

class Splash3Controller extends GetxController {
  //TODO: Implement Splash3Controller

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 3), () {
      Get.off(LoginView()); // Navigate using GetX without back option
    });
  }



  void increment() => count.value++;
}
