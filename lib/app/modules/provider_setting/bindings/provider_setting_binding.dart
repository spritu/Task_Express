import 'package:get/get.dart';

import '../controllers/provider_setting_controller.dart';

class ProviderSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderSettingController>(
      () => ProviderSettingController(),
    );
  }
}
