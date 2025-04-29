import 'package:get/get.dart';

import '../controllers/bricklaying_helper_controller.dart';

class BricklayingHelperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BricklayingHelperController>(
      () => BricklayingHelperController(),
    );
  }
}
