import 'dart:async';

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class ActivejobScreenController extends GetxController {
  //TODO: Implement ActiveJobScreenController

  Completer<GoogleMapController> mapControllerCompleter = Completer();
  LatLng? currentLatLng;
  final LatLng defaultLatLng = LatLng(22.7196, 75.8577); // Indore
  StreamSubscription<Position>? _positionStreamSubscription;

  var selectedAddressType = 'Home'.obs;

  void selectAddressType(String type) {
    selectedAddressType.value = type;
  }

  Future<void> _getPermissionAndLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      currentLatLng = LatLng(position.latitude, position.longitude);
      update();

      final controller = await mapControllerCompleter.future;
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng!, 16),
      );
    } catch (e) {
      print("Error fetching location: $e");
      currentLatLng = defaultLatLng;
      update();
    }

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) async {
      currentLatLng = LatLng(position.latitude, position.longitude);
      update();

      final controller = await mapControllerCompleter.future;
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng!, 16),
      );
    });
  }

  @override
  void onInit() {
    super.onInit();
    _getPermissionAndLocation();
  }

  @override
  void onClose() {
    _positionStreamSubscription?.cancel();
    super.onClose();
  }

  final count = 0.obs;
  var isAvailable2 = true.obs;
  var isServiceProfile = false.obs;

  final List<Map<String, String>> jobs = List.generate(
    3,
        (index) => {
      "title": "Plumbing job",
      "subtitle": "Pipe Repair",
      "amount": "₹8450",
      "date": "10 Apr 2025",
    },
  );


  @override
  void onReady() {
    super.onReady();
  }



  void increment() => count.value++;
}