import 'package:get/get.dart';

import '../controllers/your_earning_controller.dart';

class YourEarningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YourEarningController>(
      () => YourEarningController(),
    );
  }
}
