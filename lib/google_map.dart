import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentLatLng;

  // Default location (if current location fails)
  final LatLng _defaultLatLng = LatLng(22.7196, 75.8577); // Indore

  // Hardcoded plumber location (example coordinates)
  final LatLng _plumberLatLng = LatLng(22.7220, 75.8605); // Customize plumber location here

  @override
  void initState() {
    super.initState();
    _getPermissionAndLocation();
  }

  Future<void> _getPermissionAndLocation() async {
    // Check location service
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    // Check permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }
    }

    // Get current position
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLatLng = LatLng(position.latitude, position.longitude);
      });

      _moveCameraToFitBoth();
    } catch (e) {
      print("❗ Error fetching location: $e");
      setState(() {
        _currentLatLng = _defaultLatLng;
      });
      _moveCameraToFitBoth();
    }
  }

  Future<void> _moveCameraToFitBoth() async {
    if (_currentLatLng == null || !_controller.isCompleted) return;

    final GoogleMapController controller = await _controller.future;

    // Calculate bounds to show both current location and plumber location
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        min(_currentLatLng!.latitude, _plumberLatLng.latitude),
        min(_currentLatLng!.longitude, _plumberLatLng.longitude),
      ),
      northeast: LatLng(
        max(_currentLatLng!.latitude, _plumberLatLng.latitude),
        max(_currentLatLng!.longitude, _plumberLatLng.longitude),
      ),
    );

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Current Location & Plumber")),
      body: _currentLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLatLng!,
          zoom: 14,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          Marker(
            markerId: const MarkerId("currentLocation"),
            position: _currentLatLng!,
            infoWindow: const InfoWindow(title: "You are here"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
          Marker(
            markerId: const MarkerId("plumberLocation"),
            position: _plumberLatLng,
            infoWindow: const InfoWindow(title: "Plumber"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        },
      ),
    );
  }
}
