import 'package:get/get.dart';

import '../controllers/activejob_screen_controller.dart';

class ActivejobScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivejobScreenController>(
      () => ActivejobScreenController(),
    );
  }
}
