import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  late GoogleMapController googleMapController;
  Position? position;
  List<LatLng> _polygonCoordinates = [];
  LatLng? _currentPosition;
  final Set<Polygon> _polygons = {};



  @override
  void initState() {
    super.initState();
    listenCurrentLocation();
  }

  Future<void> listenCurrentLocation() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnabled = await checkGPSServiceEnable();
      if (isServiceEnabled) {
        Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              timeLimit: Duration(seconds: 3),
                // distanceFilter: 10,
                accuracy: LocationAccuracy.bestForNavigation
            )
        ).listen((pos) {
          print('==============');
          print(pos);
        });
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

  Future<void> getCurrentLocation() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnabled = await checkGPSServiceEnable();
      if (isServiceEnabled) {
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
        title: const Text('Map Screen'),
      ),
      body: GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition:  CameraPosition(
          zoom: 16,
          target: _currentPosition!
        ),
        onTap: (LatLng position) {
          _showSnackbar(position);
        },
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        // trafficEnabled: true,
        polylines: <Polyline>{
          const Polyline(
            polylineId: PolylineId('random'),
            color: Colors.amber,
            width: 4,
            jointType: JointType.round,
            points: <LatLng>[
              LatLng(23.79409502479623, 90.3570295125246),
              LatLng(23.788140632707165, 90.36082182079554),
              LatLng(23.780215029962257, 90.36286599934101)
            ],
          ),
        },

      ),
    );
  }
}
