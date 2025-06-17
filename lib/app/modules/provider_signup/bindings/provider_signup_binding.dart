import 'package:get/get.dart';

import '../controllers/provider_signup_controller.dart';

class ProviderSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderSignupController>(
      () => ProviderSignupController(),
    );
  }
}
