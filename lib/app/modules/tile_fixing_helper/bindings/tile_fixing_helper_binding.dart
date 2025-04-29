import 'package:get/get.dart';

import '../controllers/tile_fixing_helper_controller.dart';

class TileFixingHelperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TileFixingHelperController>(
      () => TileFixingHelperController(),
    );
  }
}
