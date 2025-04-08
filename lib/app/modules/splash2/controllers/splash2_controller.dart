import 'package:get/get.dart';

import '../../splash3/views/splash3_view.dart';

class Splash2Controller extends GetxController {
  //TODO: Implement Splash2Controller

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 3), () {
      Get.off(Splash3View()); // Navigate using GetX without back option
    });
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
