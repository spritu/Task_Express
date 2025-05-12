import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessionalPlumberController extends GetxController {
  //TODO: Implement ProfessionalPlumberController

  var workers = <Map<String, dynamic>>[].obs;
  void fetchWorkers() {
    workers.value = [
      {
        'name': 'Amit Sharma',
        'image': 'assets/images/professional_profile.png', // your local image asset
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },
      {
        'name': 'Amit Sharma',
        'image': 'assets/images/professional_profile.png',
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },  {
        'name': 'Amit Sharma',
        'image': 'assets/images/professional_profile.png', // your local image asset
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },
      {
        'name': 'Amit Sharma',
        'image': 'assets/images/professional_profile.png',
        'rating': 4.7,
        'reviews': 69,
        'available': true,
        'experience': 7,
        'distance': '3.5 km',
        'time': '20 mins',
        'charge': 250
      },  {
        'name': 'Suraj sen',
        'image': 'assets/images/professional_profile.png', // your local image asset
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
        'image': 'assets/images/professional_profile.png',
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

  void makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
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
