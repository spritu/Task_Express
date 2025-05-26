import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CancelBookingController extends GetxController {
  //TODO: Implement CancelBookingController


  final count = 0.obs;
  final RxString selectedReason = ''.obs;

  final List<String> reasons = [
    "Changed my mind",
    "Booked by mistake",
    "Worker asked to cancel",
    "Need to reschedule",
    "Found another service provider",
    "Worker not responding",
    "Other (please specify)",
  ];

  final TextEditingController otherReasonController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}