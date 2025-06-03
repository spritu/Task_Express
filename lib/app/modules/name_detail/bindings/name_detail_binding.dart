import 'package:get/get.dart';

import '../controllers/name_detail_controller.dart';

class NameDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NameDetailController>(
      () => NameDetailController(),
    );
  }
}
