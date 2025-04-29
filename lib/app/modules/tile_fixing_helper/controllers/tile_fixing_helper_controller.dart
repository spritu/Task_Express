import 'package:get/get.dart';

class TileFixingHelperController extends GetxController {
  //TODO: Implement TileFixingHelperController
  var workers = <Map<String, dynamic>>[].obs;
  void fetchWorkers() {
    // workers.value = [
    //   {
    //     'name': 'Suraj sen',
    //     'image': 'assets/images/rajesh.png', // your local image asset
    //     'rating': 4.7,
    //     'reviews': 69,
    //     'available': true,
    //     'experience': 7,
    //     'distance': '3.5 km',
    //     'time': '20 mins',
    //     'charge': 250
    //   },
    //   {
    //     'name': 'Rajesh kumar',
    //     'image': 'assets/images/rajesh.png',
    //     'rating': 4.7,
    //     'reviews': 69,
    //     'available': true,
    //     'experience': 7,
    //     'distance': '3.5 km',
    //     'time': '20 mins',
    //     'charge': 250
    //   },  {
    //     'name': 'Suraj sen',
    //     'image': 'assets/images/rajesh.png', // your local image asset
    //     'rating': 4.7,
    //     'reviews': 69,
    //     'available': true,
    //     'experience': 7,
    //     'distance': '3.5 km',
    //     'time': '20 mins',
    //     'charge': 250
    //   },
    //   {
    //     'name': 'Rajesh kumar',
    //     'image': 'assets/images/rajesh.png',
    //     'rating': 4.7,
    //     'reviews': 69,
    //     'available': true,
    //     'experience': 7,
    //     'distance': '3.5 km',
    //     'time': '20 mins',
    //     'charge': 250
    //   },  {
    //     'name': 'Suraj sen',
    //     'image': 'assets/images/rajesh.png', // your local image asset
    //     'rating': 4.7,
    //     'reviews': 69,
    //     'available': true,
    //     'experience': 7,
    //     'distance': '3.5 km',
    //     'time': '20 mins',
    //     'charge': 250
    //   },
    //   {
    //     'name': 'Rajesh kumar',
    //     'image': 'assets/images/rajesh.png',
    //     'rating': 4.7,
    //     'reviews': 69,
    //     'available': true,
    //     'experience': 7,
    //     'distance': '3.5 km',
    //     'time': '20 mins',
    //     'charge': 250
    //   },
    //   // Add more if needed
    // ];
  }
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchWorkers();
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
