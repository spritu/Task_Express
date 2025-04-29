import 'package:get/get.dart';

import '../controllers/road_construction_helper_controller.dart';

class RoadConstructionHelperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoadConstructionHelperController>(
      () => RoadConstructionHelperController(),
    );
  }
}
