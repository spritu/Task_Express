import 'package:get/get.dart';

import '../controllers/completejob_controller.dart';

class CompletejobBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompletejobController>(
      () => CompletejobController(),
    );
  }
}
