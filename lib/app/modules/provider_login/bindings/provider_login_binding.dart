import 'package:get/get.dart';

import '../controllers/provider_login_controller.dart';

class ProviderLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderLoginController>(
      () => ProviderLoginController(),
    );
  }
}
