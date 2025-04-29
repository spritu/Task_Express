import 'package:get/get.dart';

import '../controllers/professional_plumber_controller.dart';

class ProfessionalPlumberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfessionalPlumberController>(
      () => ProfessionalPlumberController(),
    );
  }
}
