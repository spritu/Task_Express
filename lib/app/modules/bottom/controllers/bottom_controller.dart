import 'package:get/get.dart';

class BottomController extends GetxController {
  //TODO: Implement BottomController

  final count = 0.obs;
  var selectedIndex = 0.obs;
  var bookingData = {}.obs;  var showRequestPending = false.obs;
  var helperName = ''.obs;
  var selected = 0.obs;
  void cancelRequest() {
    showRequestPending.value = false;
    helperName.value = '';
    // Optional: reset other related values if needed
  }
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
