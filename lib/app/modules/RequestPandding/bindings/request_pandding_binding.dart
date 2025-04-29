import 'package:get/get.dart';

import '../controllers/request_pandding_controller.dart';

class RequestPanddingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestPanddingController>(
      () => RequestPanddingController(),
    );
  }
}
