import 'package:get/get.dart';

import '../controllers/confirm_payment_recived_controller.dart';

class ConfirmPaymentRecivedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfirmPaymentRecivedController>(
      () => ConfirmPaymentRecivedController(),
    );
  }
}
