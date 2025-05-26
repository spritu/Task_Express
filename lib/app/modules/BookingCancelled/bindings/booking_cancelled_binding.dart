import 'package:get/get.dart';

import '../controllers/booking_cancelled_controller.dart';

class BookingCancelledBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingCancelledController>(
      () => BookingCancelledController(),
    );
  }
}
