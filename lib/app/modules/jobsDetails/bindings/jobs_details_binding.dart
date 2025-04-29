import 'package:get/get.dart';

import '../controllers/jobs_details_controller.dart';

class JobsDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobsDetailsController>(
      () => JobsDetailsController(),
    );
  }
}
