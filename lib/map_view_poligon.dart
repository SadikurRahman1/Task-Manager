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
  final Set<Polygon> _polygons = {
  };
  List<LatLng> _polygonCoordinates = [];
  Timer? _locationUpdateTimer;
  late LatLng _ontapPosition = const LatLng(0, 0);

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

  Future<void> getCurrentLocation() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnabled = await checkGPSServiceEnable();
      if (isServiceEnabled) {
        Position position = await Geolocator.getCurrentPosition();

      } else {
        Geolocator.openLocationSettings();
      }
    } else {
      final result = await requestLocationPermission();
      if (result) {
        getCurrentLocation();
      } else {
        Geolocator.openAppSettings();
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Geolocator.openAppSettings();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // throw Exception('Location permissions are permanently denied.');
      Geolocator.openAppSettings();
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<bool> isLocationPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkGPSServiceEnable() async {
    return await Geolocator.isLocationServiceEnabled();
  }


  void _animateToUser(Position position) {
    final LatLng newPosition = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = newPosition;
      _polygonCoordinates.add(newPosition);
    });
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 16));
  }

  void _startLocationUpdates() {
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      Position position = await Geolocator.getCurrentPosition();
      LatLng newLatLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _polygonCoordinates.add(newLatLng);
        _polygons.clear();
        _polygons.add(Polygon(
          polygonId: const PolygonId("userPolygon"),
          points: _polygonCoordinates,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 3,
        ));
        _currentPosition = newLatLng;
      });
    });
  }

  void _showSnackbar(LatLng position) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lat: ${position.latitude}, Lng: ${position.longitude}'),
        duration: const Duration(seconds: 2),
      ),
    );
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
        markers: <Marker>{
          Marker(
            markerId: const MarkerId('initial-position'),
            position: _currentPosition!,
            infoWindow: InfoWindow(
              title: 'My Position',
                snippet: ('Lat: ${_currentPosition?.latitude.toString()}, Lon: ${_currentPosition?.longitude.toString()} ')
            ),
          ),
          Marker(
              markerId: const MarkerId('home'),
              position: _ontapPosition,
              infoWindow:  InfoWindow(
                  title: 'My current location',
                  snippet: ('Lat: ${_ontapPosition.latitude.toString()}, Lon: ${_ontapPosition.longitude.toString()} ')

              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
              draggable: true,
          )
        },
        polygons: _polygons,
        onTap: (LatLng position) {
          _ontapPosition = position;
          setState(() {});
          _showSnackbar(position);
        },
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
