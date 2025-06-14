import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationController extends GetxController {
  var currentAddress = ''.obs;
  var currentPosition = Rxn<Position>();
  var imagePath = ''.obs;
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    imagePath.value = args['imagePath'] ?? '';

    print('✅ Loaded image path in next screen: ${imagePath.value}');
    determinePosition();
    _loadUserData();
  }
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    String? userId2 = prefs.getString('userId');
    String? token = prefs.getString('token');
    String? email = prefs.getString('email');

    // Use the loaded data as needed
    print("🔑 Loaded userId: $userId2");
    print("🔑 Loaded token: $token");
    print("🔑 Loaded email: $email");

    // You can also update the UI or variables as needed here
  }
  Future<bool> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;

    try {
      currentPosition.value = await Geolocator.getCurrentPosition();
      await getAddressFromLatLng();

      print("📍 Latitude: ${currentPosition.value?.latitude}");
      print("📍 Longitude: ${currentPosition.value?.longitude}");

      // ✅ Get userId from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.reload();
      String? userId2 = prefs.getString('userId');

      if (userId2 != null && currentPosition.value != null) {
        await updateCoordinatesApi(userId2);
      }

      return true;
    } catch (e) {
      print("❌ Location Error: $e");
      return false;
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
        bool isUser1Saved = prefs.containsKey('lat1') && prefs.containsKey('lng1');
        if (!isUser1Saved) {
          await prefs.setDouble('lat1', latitude);
          await prefs.setDouble('lng1', longitude);
          print("📍 Saved User1 Coordinates: lat1=$latitude, lng1=$longitude");
        }

        print("📍 Saved to SharedPreferences: lat=$latitude, lng=$longitude");
      } else {
        print("⚠️ Coordinates not found in API response.");
      }
    } else {
      print("❌ Failed to update coordinates: ${response.statusCode} - ${response.reasonPhrase}");
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
     //   Get.snackbar('Error', 'Failed to get address');
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
    String? userId2 = prefs.getString('userId');
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
     // Get.snackbar('Success', 'Address submitted successfully');
    } else {
      print("Failed to post address: ${response.reasonPhrase}");
     // Get.snackbar('Error', 'Failed to submit address');
    }
  }

}
