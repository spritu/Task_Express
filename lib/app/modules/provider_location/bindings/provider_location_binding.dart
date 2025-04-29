import 'package:get/get.dart';

import '../controllers/provider_location_controller.dart';

class ProviderLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderLocationController>(
      () => ProviderLocationController(),
    );
  }
}
