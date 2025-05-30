import 'package:get/get.dart';

import '../controllers/recomplete_job_pay_controller.dart';

class RecompleteJobPayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecompleteJobPayController>(
      () => RecompleteJobPayController(),
    );
  }
}
