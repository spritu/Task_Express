import 'package:get/get.dart';

import '../controllers/servicepro_controller.dart';

class ServiceproBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceproController>(
      () => ServiceproController(),
    );
  }
}
