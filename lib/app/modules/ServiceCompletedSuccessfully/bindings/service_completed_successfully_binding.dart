import 'package:get/get.dart';

import '../controllers/service_completed_successfully_controller.dart';

class ServiceCompletedSuccessfullyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceCompletedSuccessfullyController>(
      () => ServiceCompletedSuccessfullyController(),
    );
  }
}
