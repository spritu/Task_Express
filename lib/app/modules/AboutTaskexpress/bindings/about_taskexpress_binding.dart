import 'package:get/get.dart';

import '../controllers/about_taskexpress_controller.dart';

class AboutTaskexpressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutTaskexpressController>(
      () => AboutTaskexpressController(),
    );
  }
}
