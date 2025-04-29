import 'package:get/get.dart';

import '../controllers/provider_otp_controller.dart';

class ProviderOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderOtpController>(
      () => ProviderOtpController(),
    );
  }
}
