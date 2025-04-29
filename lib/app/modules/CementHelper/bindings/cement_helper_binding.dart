import 'package:get/get.dart';

import '../controllers/cement_helper_controller.dart';

class CementHelperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CementHelperController>(
      () => CementHelperController(),
    );
  }
}
