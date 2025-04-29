import 'package:get/get.dart';

import '../controllers/privacydata_view_controller.dart';

class PrivacydataViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacydataViewController>(
      () => PrivacydataViewController(),
    );
  }
}
