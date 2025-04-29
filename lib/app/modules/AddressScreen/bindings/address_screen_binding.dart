import 'package:get/get.dart';

import '../controllers/address_screen_controller.dart';

class AddressScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressScreenController>(
      () => AddressScreenController(),
    );
  }
}
