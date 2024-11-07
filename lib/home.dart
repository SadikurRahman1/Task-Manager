import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? position;
  Position? _previousPosition;
  double _totalDistance = 0.0;

  @override
  void initState() {
    super.initState();
    listenCurrentLocation();
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // পৃথিবীর ব্যাসার্ধ (কিমি)
    double lat1Rad = lat1 * pi / 180;
    double lat2Rad = lat2 * pi / 180;
    double deltaLat = (lat2 - lat1) * pi / 180;
    double deltaLon = (lon2 - lon1) * pi / 180;

    double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c; // কিমি-তে দূরত্ব
    return distance;
  }



  Future<void> listenCurrentLocation() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnabled = await checkGPSServiceEnable();
      if (isServiceEnabled) {
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            timeLimit: Duration(seconds: 2),
            accuracy: LocationAccuracy.bestForNavigation,
          ),
        ).listen((Position currentPosition) {

          if (_previousPosition != null) {
            double distance = _calculateDistance(
              _previousPosition!.latitude,
              _previousPosition!.longitude,
              currentPosition.latitude,
              currentPosition.longitude,
            );
            setState(() {
              _totalDistance += distance; // মোট দূরত্ব যোগ করা হচ্ছে
            });
            print("Distance between points: ${distance.toStringAsFixed(5)} km");
          }
          _previousPosition = currentPosition; // পূর্বের অবস্থান আপডেট
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
        Position p = await Geolocator.getCurrentPosition();
        position = p;
        setState(() {});
        print(p);
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

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('My current location: $position'),
            const Text(
              'Total Distance Traveled:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${_totalDistance.toStringAsFixed(2)} km',
              style: const TextStyle(fontSize: 32, color: Colors.blue),
            ),
            ElevatedButton(
              onPressed: () {
                getCurrentLocation();
              },
              child: const Text('Get current location'),
            )
          ],
        ),
      ),
    );
  }
}

