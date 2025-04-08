import 'package:get/get.dart';

import '../controllers/splash3_controller.dart';

class Splash3Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Splash3Controller>(
      () => Splash3Controller(),
    );
  }
}
