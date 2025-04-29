import 'package:get/get.dart';

import '../controllers/scaffolding_helper_controller.dart';

class ScaffoldingHelperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScaffoldingHelperController>(
      () => ScaffoldingHelperController(),
    );
  }
}
