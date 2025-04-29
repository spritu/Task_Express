import 'package:get/get.dart';

import '../controllers/user_help_controller.dart';

class UserHelpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserHelpController>(
      () => UserHelpController(),
    );
  }
}
