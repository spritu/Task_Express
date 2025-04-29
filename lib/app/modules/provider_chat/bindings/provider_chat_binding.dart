import 'package:get/get.dart';

import '../controllers/provider_chat_controller.dart';

class ProviderChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderChatController>(
      () => ProviderChatController(),
    );
  }
}
