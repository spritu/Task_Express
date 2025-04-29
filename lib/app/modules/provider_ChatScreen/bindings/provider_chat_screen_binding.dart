import 'package:get/get.dart';

import '../controllers/provider_chat_screen_controller.dart';

class ProviderChatScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderChatScreenController>(
      () => ProviderChatScreenController(),
    );
  }
}
