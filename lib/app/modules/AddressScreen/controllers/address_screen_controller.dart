import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../bottom/views/bottom_view.dart';

class AddressScreenController extends GetxController {
  Completer<GoogleMapController> mapControllerCompleter = Completer();

  final LatLng plumberLatLng = const LatLng(22.7220, 75.8605);
  LatLng? currentLatLng;
  var houseNo = ''.obs;
  var landMark = ''.obs;
  RxDouble distanceInKm = 0.0.obs;
  RxString selectedAddressType = 'Home'.obs;
  var address = ''.obs; // Observable address

  final addressType = Rx<String>('');
  final contactNo = Rx<String>('');
  TextEditingController phoneController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();

 // String phoneNumber = "+91 9836747398";
  void _loadSavedAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    houseNo.value = prefs.getString('savedHouseNo') ?? '';
    landMark.value = prefs.getString('savedLandMark') ?? '';
  }
  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
    fetchAddress();
    _loadSavedAddress();
   // phoneController.text = phoneNumber;
  }

  @override
  void dispose() {
    phoneController.dispose();
    houseController.dispose();
    landmarkController.dispose();
    super.dispose();
  }

  void selectAddressType(String type) {
    selectedAddressType.value = type;
  }
  Future<void> fetchAddress() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');  // Retrieve the userId from SharedPreferences

      if (userId == null) {
        print("User ID not found");
        return;
      }

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://jdapi.youthadda.co/user/getmyaddress'));
      request.body = json.encode({
        "userId": userId,  // Use the dynamic userId
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        print("Raw Response: $responseString");

        var jsonResponse = json.decode(responseString);

        if (jsonResponse['data'] != null && jsonResponse['data'].isNotEmpty) {
          var addressesList = jsonResponse['data'];  // List of addresses

          // Clear any previous address data
          houseNo.value = '';
          landMark.value = '';
          addressType.value = '';
          contactNo.value = '';

          // Select the last address from the list
          var lastAddress = addressesList.last;  // Using the last address in the list

          // Storing the fetched address fields (using the last one here)
          houseNo.value = lastAddress['houseNo'] ?? '';
          landMark.value = lastAddress['landMark'] ?? '';
          addressType.value = lastAddress['addressType'] ?? '';
          contactNo.value = lastAddress['contactNo'] ?? '';
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('savedHouseNo', houseNo.value);
          prefs.setString('savedLandMark', landMark.value);

          // Update the reactive variables
          houseNo.value = houseNo.value;
          landMark.value = landMark.value;
          print("Fetched houseNo: ${houseNo.value}");
          print("Fetched landMark: ${landMark.value}");
          print("Fetched addressType: ${addressType.value}");
          print("Fetched contactNo: ${contactNo.value}");
        } else {
          print("Data empty or not found in response");
        }
      } else {
        print("Request failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }





  void showEditDialog(dynamic context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Phone Number"),
          content: TextField(
            controller: phoneController,
            decoration: InputDecoration(hintText: "Enter new phone number"),
            keyboardType: TextInputType.phone,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
              phoneController.text;
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentLatLng = LatLng(position.latitude, position.longitude);
    _calculateDistance();
    update();

    final controller = await mapControllerCompleter.future;
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        currentLatLng!.latitude < plumberLatLng.latitude ? currentLatLng!.latitude : plumberLatLng.latitude,
        currentLatLng!.longitude < plumberLatLng.longitude ? currentLatLng!.longitude : plumberLatLng.longitude,
      ),
      northeast: LatLng(
        currentLatLng!.latitude > plumberLatLng.latitude ? currentLatLng!.latitude : plumberLatLng.latitude,
        currentLatLng!.longitude > plumberLatLng.longitude ? currentLatLng!.longitude : plumberLatLng.longitude,
      ),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  void _calculateDistance() {
    if (currentLatLng != null) {
      double distance = Geolocator.distanceBetween(
        currentLatLng!.latitude,
        currentLatLng!.longitude,
        plumberLatLng.latitude,
        plumberLatLng.longitude,
      );
      distanceInKm.value = distance / 1000;
    }
  }

  Future<void> saveAddress() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        print("User ID not found");
        return;
      }

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://jdapi.youthadda.co/user/addeditaddress'));
      request.body = json.encode({
        "userId": userId,
        "houseNo": houseController.text,
        "landMark": landmarkController.text,
        "addressType": selectedAddressType.value.toLowerCase(),
        "contactNo": phoneController.text,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final result = await response.stream.bytesToString();
        print('Success: $result');
       // Get.snackbar("Success", "Address saved successfully");

        clear();
        await fetchAddress();

        /// ✅ Navigate to BottomView (Home)
        Get.offAll(() => BottomView(), arguments: {'refreshHome': true});
      }
      else {
        print('Error: ${response.reasonPhrase}');
     //   Get.snackbar("Error", "Failed to save address");
      }
    } catch (e) {
      print('Exception: $e');
//Get.snackbar("Error", "Something went wrong");
    }
  }

  clear(){
  houseController.clear();
  landmarkController.clear();
  phoneController.clear();
}
}
