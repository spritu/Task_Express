import 'package:get/get.dart';

import '../controllers/provider_account_controller.dart';

class ProviderAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderAccountController>(
      () => ProviderAccountController(),
    );
  }
}
