import 'package:get/get.dart';

class RoadConstructionHelperController extends GetxController {
  //TODO: Implement RoadConstructionHelperController
  final RxList<double> _ratings = List.generate(10, (index) => 3.0).obs;

  double getRating(int index) => _ratings[index];
  var workers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWorkers();
  }

  void fetchWorkers() {
    workers.value = [
      {
        'name': 'Suraj sen',
        'image': 'assets/images/rajesh.png', // your local image asset
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },
      {
        'name': 'Rajesh kumar',
        'image': 'assets/images/rajesh.png',
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },  {
        'name': 'Suraj sen',
        'image': 'assets/images/rajesh.png', // your local image asset
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },
      {
        'name': 'Rajesh kumar',
        'image': 'assets/images/rajesh.png',
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },  {
        'name': 'Suraj sen',
        'image': 'assets/images/rajesh.png', // your local image asset
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },
      {
        'name': 'Rajesh kumar',
        'image': 'assets/images/rajesh.png',
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },
      // Add more if needed
    ];
  }
  void setRating(int index, double rating) {
    _ratings[index] = rating;
  }
  final count = 0.obs;



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
