import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      // 🚀 Call API after getting location
      await sendAddressToApi(userId: '', contactNo: '');

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

  // 🔽 API CALL FUNCTION
  Future<void> sendAddressToApi({
    required String userId,
    required String contactNo,
    String houseNo = '',
    String addressType = 'home',
  }) async {
    var headers = {'Content-Type': 'application/json'};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    String? userId2 = prefs.getString('userId2');
    var body = json.encode({
      "userId": userId2,
      "houseNo": houseNo,
      "landMark": currentAddress.value,
      "addressType": addressType,
      "contactNo": contactNo
    });

    var response = await http.post(
      Uri.parse('https://jdapi.youthadda.co/user/addeditaddress'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print("Address posted successfully: ${response.body}");
      Get.snackbar('Success', 'Address submitted successfully');
    } else {
      print("Failed to post address: ${response.reasonPhrase}");
      Get.snackbar('Error', 'Failed to submit address');
    }
  }

}
