import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _currentPosition;
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  Marker? _marker;
  Timer? _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _determinePosition().then((position) {
      _animateToUser(position);
      _startLocationUpdates();
    });
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _animateToUser(Position position) {
    final LatLng newPosition = LatLng(position.latitude, position.longitude);
    setState(() {
      _currentPosition = newPosition;
      _marker = Marker(
        markerId: const MarkerId('currentLocation'),
        position: newPosition,
        infoWindow: InfoWindow(
          title: 'My Current Location',
          snippet: 'Lat: ${newPosition.latitude}, Lng: ${newPosition.longitude}',
        ),
      );
    });
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 16));
  }

  void _startLocationUpdates() {
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      Position position = await Geolocator.getCurrentPosition();
      LatLng newLatLng = LatLng(position.latitude, position.longitude);

      setState(() {
        if (_currentPosition != null) {
          _polylineCoordinates.add(_currentPosition!);
          _polylineCoordinates.add(newLatLng);
          _polylines.add(Polyline(
            polylineId: const PolylineId("route"),
            points: _polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ));
        }

        _currentPosition = newLatLng;
        _marker = Marker(
          markerId: const MarkerId('currentLocation'),
          position: newLatLng,
          infoWindow: InfoWindow(
            title: 'My Current Location',
            snippet: 'Lat: ${newLatLng.latitude}, Lng: ${newLatLng.longitude}',
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Location Tracker'),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 16,
        ),
        markers: _marker != null ? {_marker!} : {},
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
