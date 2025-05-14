import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  var currentAddress = ''.obs;
  var currentPosition = Rxn<Position>();

  @override
  void onInit() {
    super.onInit();
    determinePosition();
  }

  Future<bool> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Error', 'Please enable location services');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Location Error', 'Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Location Error', 'Location permissions are permanently denied');
      return false;
    }

    try {
      currentPosition.value = await Geolocator.getCurrentPosition();
      await getAddressFromLatLng();
      print("Current Address: ${currentAddress.value}");
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location');
      return false;
    }
  }


  Future<void> getAddressFromLatLng() async {
    if (currentPosition.value != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.value!.latitude,
          currentPosition.value!.longitude,
        );

        Placemark place = placemarks[0];

        // Use locality (e.g. city/town) and subLocality (e.g. area)
        currentAddress.value = [
          if (place.subLocality != null && place.subLocality!.isNotEmpty)
            place.subLocality,
          if (place.locality != null && place.locality!.isNotEmpty)
            place.locality,
        ].join(', ');

        print("Short Address: ${currentAddress.value}");
      } catch (e) {
        print(e);
        Get.snackbar('Error', 'Failed to get address');
      }
    }
  }

}
