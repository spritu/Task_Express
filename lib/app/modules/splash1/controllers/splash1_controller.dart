import 'package:get/get.dart';
import '../../splash2/views/splash2_view.dart';

class Splash1Controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 1), () {
      Get.off(Splash2View()); // Navigate to second splash screen
    });
  }
}
