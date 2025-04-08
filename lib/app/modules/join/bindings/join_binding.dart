import 'package:get/get.dart';

import '../controllers/join_controller.dart';

class JoinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JoinController>(
      () => JoinController(),
    );
  }
}
