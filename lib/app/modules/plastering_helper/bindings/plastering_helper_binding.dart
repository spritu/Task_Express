import 'package:get/get.dart';

import '../controllers/plastering_helper_controller.dart';

class PlasteringHelperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlasteringHelperController>(
      () => PlasteringHelperController(),
    );
  }
}
