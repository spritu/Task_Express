import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PlasteringHelperController extends GetxController {
  //TODO: Implement PlasteringHelperController
  var workers = <Map<String, dynamic>>[].obs;
  // Future<String> getAddressFromCoordinates(double lat, double lng) async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
  //     if (placemarks.isNotEmpty) {
  //       final place = placemarks.first;
  //       return "${place.name}, ${place.subLocality}, ${place.locality}";
  //     } else {
  //       return "Address not found";
  //     }
  //   } catch (e) {
  //     return "Error: $e";
  //   }
  // }
  void makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {

      await launchUrl(callUri);
    } else {
      Get.snackbar('Error', 'Could not launch phone call');
    }
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
