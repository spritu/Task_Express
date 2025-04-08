import 'package:get/get.dart';

class WorknestController extends GetxController {
  // TODO: Implement WorknestController

  final count = 0.obs;

  final List<String> titles = [
    'Electretion',
    'Plumber',
    'Gardner',
    'Home cook',
    'House worker',
    'AC Repair',
    'Pest control',
    'More'
  ];

  final List<String> imagePaths = [
    'assets/images/electretion.png',
    'assets/images/plumber.png',
    'assets/images/gardner.png',
    'assets/images/homecook.png',
    'assets/images/worker.png',
    'assets/images/ac.png',
    'assets/images/pestcontrol.png',
    'assets/images/plush.png',

  ];

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
