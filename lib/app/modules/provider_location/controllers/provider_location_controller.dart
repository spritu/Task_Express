import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProviderLocationController extends GetxController {
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
     // Get.snackbar('Location Error', 'Please enable location services');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
       // Get.snackbar('Location Error', 'Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      //Get.snackbar('Location Error', 'Location permissions are permanently denied');
      return false;
    }

    try {
      currentPosition.value = await Geolocator.getCurrentPosition();
      await getAddressFromLatLng();
      print("Current Address: ${currentAddress.value}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.reload();
      String? userId = prefs.getString('userId');

      if (userId != null && currentPosition.value != null) {
        await updateCoordinatesApi(userId);
      }
      // Call API to update coordinates

      return true;
    } catch (e) {
     // Get.snackbar('Error', 'Failed to get location');
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
      //  Get.snackbar('Error', 'Failed to get address');
      }
    }
  }
  Future<void> updateCoordinatesApi(String userId) async {
    var headers = {'Content-Type': 'application/json'};

    var body = json.encode({
      "userId": userId,
      "latitude": currentPosition.value?.latitude,
      "longitude": currentPosition.value?.longitude,
    });

    var response = await http.post(
      Uri.parse('https://jdapi.youthadda.co/user/updateusercoordinates'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print("✅ Coordinates updated: ${response.body}");

      final data = json.decode(response.body);
      final coordinates = data['user']?['location']?['coordinates'];

      if (coordinates != null && coordinates.length >= 2) {
        final double longitude = coordinates[0];
        final double latitude = coordinates[1];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isUser2Saved = prefs.containsKey('lat2') && prefs.containsKey('lng2');
        if (!isUser2Saved) {
          await prefs.setDouble('lat2', latitude);
          await prefs.setDouble('lng2', longitude);
          print("📍 Saved User2 Coordinates: lat2=$latitude, lng2=$longitude");
        }
        print("📍 Saved to SharedPreferences: lat=$latitude, lng=$longitude");
      } else {
        print("⚠️ Coordinates not found in API response.");
      }
    } else {
      print("❌ Failed to update coordinates: ${response.statusCode} - ${response.reasonPhrase}");
    }
  }


// Future<void> updateCoordinatesToAPI() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userId = prefs.getString('userId'); // Make sure 'userId' is stored here
  //
  //   if (userId == null || currentPosition.value == null) {
  //     Get.snackbar('Error', 'User ID or coordinates are missing');
  //     return;
  //   }
  //
  //   var headers = {'Content-Type': 'application/json'};
  //   var body = json.encode({
  //     "userId": userId,
  //     "latitude": currentPosition.value!.latitude,
  //     "longitude": currentPosition.value!.longitude
  //   });
  //
  //   var request = http.Request(
  //     'POST',
  //     Uri.parse('https://jdapi.youthadda.co/user/updateusercoordinates'),
  //   );
  //   request.body = body;
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     String responseBody = await response.stream.bytesToString();
  //     print("✅ Location updated: $responseBody");
  //
  //     // Save API response to SharedPreferences
  //     Map<String, dynamic> responseData = json.decode(responseBody);
  //     await prefs.setString('locationUpdateResponse', responseBody);
  //
  //     // Optional: Save specific data if needed
  //     if (responseData['data'] != null && responseData['data']['updatedLocation'] != null) {
  //       await prefs.setDouble('savedLatitude', responseData['data']['updatedLocation']['latitude']);
  //       await prefs.setDouble('savedLongitude', responseData['data']['updatedLocation']['longitude']);
  //     }
  //
  //     Get.snackbar('Success', 'Location updated successfully');
  //   } else {
  //     print("❌ Error: ${response.statusCode} - ${response.reasonPhrase}");
  //     Get.snackbar('Error', 'Failed to update location');
  //   }
  // }
}
