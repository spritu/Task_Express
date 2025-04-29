import 'package:get/get.dart';

import '../controllers/service_completed_controller.dart';

class ServiceCompletedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceCompletedController>(
      () => ServiceCompletedController(),
    );
  }
}
