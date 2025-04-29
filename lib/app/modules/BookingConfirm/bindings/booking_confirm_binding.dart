import 'package:get/get.dart';

import '../controllers/booking_confirm_controller.dart';

class BookingConfirmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingConfirmController>(
      () => BookingConfirmController(),
    );
  }
}
