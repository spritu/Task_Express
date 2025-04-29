import 'package:get/get.dart';

import '../controllers/provider_edit_profile_controller.dart';

class ProviderEditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderEditProfileController>(
      () => ProviderEditProfileController(),
    );
  }
}
