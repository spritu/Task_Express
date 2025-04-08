import 'package:get/get.dart';

import '../controllers/worknest_controller.dart';

class WorknestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorknestController>(
      () => WorknestController(),
    );
  }
}
