import 'package:get/get.dart';

import '../controllers/bottom_controller.dart';

class BottomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomController>(
      () => BottomController(),
    );
  }
}
