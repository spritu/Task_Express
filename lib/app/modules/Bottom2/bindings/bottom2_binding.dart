import 'package:get/get.dart';

import '../controllers/bottom2_controller.dart';

class Bottom2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Bottom2Controller>(
      () => Bottom2Controller(),
    );
  }
}
