import 'dart:async';
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
  final LatLng _defaultLatLng = LatLng(22.7196, 75.8577); // Indore
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _getPermissionAndLocation();
  }

  @override
  void dispose() {
    // Stop the location service when the screen is disposed
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _getPermissionAndLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    // Check for permission to access the location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }
    }

    // Get the current position
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLatLng = LatLng(position.latitude, position.longitude);
      });

      // Move camera to the current location
      final GoogleMapController mapController = await _controller.future;
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLatLng!, 16),
      );
    } catch (e) {
      print("Error fetching location: $e");
      setState(() {
        _currentLatLng = _defaultLatLng;
      });
    }

    // Stream location updates continuously (optional)
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) async {
      setState(() {
        _currentLatLng = LatLng(position.latitude, position.longitude);
      });

      final GoogleMapController mapController = await _controller.future;
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLatLng!, 16),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Map with Location")),
      body: _currentLatLng == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(22.7196, 75.8577), // Indore
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: MarkerId("currentLocation"),
            position: _currentLatLng ?? _defaultLatLng,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
