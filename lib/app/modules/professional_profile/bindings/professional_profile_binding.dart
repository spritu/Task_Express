import 'package:get/get.dart';

import '../controllers/professional_profile_controller.dart';

class ProfessionalProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfessionalProfileController>(
      () => ProfessionalProfileController(),
    );
  }
}
