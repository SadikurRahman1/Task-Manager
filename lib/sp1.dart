import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RealTimeSpeedTracker extends StatefulWidget {
  const RealTimeSpeedTracker({super.key});

  @override
  _RealTimeSpeedTrackerState createState() => _RealTimeSpeedTrackerState();
}

class _RealTimeSpeedTrackerState extends State<RealTimeSpeedTracker> {
  double _currentSpeed = 0.0;

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
            timeLimit: Duration(seconds: 2),
            accuracy: LocationAccuracy.bestForNavigation,
          ),
        ).listen((Position position) {
          setState(() {
            _currentSpeed =
                (position.speed * 3.6).clamp(0, double.infinity); // Convert to km/h
          });
        });
      } else {
        Geolocator.openLocationSettings();
      }
    } else {
      final result = await requestLocationPermission();
      if (result) {
        listenCurrentLocation();
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

  String overSpeed(){
    if(_currentSpeed > 10 ){
      return 'Overspeed ';
    }
    return '';
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed Tracker'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SfRadialGauge(
                animationDuration: 4500,
                enableLoadingAnimation: true,

                axes: <RadialAxis>[

                  RadialAxis(
                    minimum: 0,
                    maximum: 12,
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0, endValue: 4, color: Colors.green),
                      GaugeRange(
                          startValue: 4, endValue: 8, color: Colors.orange),
                      GaugeRange(
                          startValue: 8, endValue: 12, color: Colors.red)
                    ],
                    pointers: <GaugePointer>[NeedlePointer(value: _currentSpeed, enableAnimation: true,)],

                    // annotations: <GaugeAnnotation>[
                    //   GaugeAnnotation(
                    //       widget: Text(
                    //         _currentSpeed.toStringAsFixed(2),
                    //         style: const TextStyle(
                    //             fontSize: 25, fontWeight: FontWeight.bold),
                    //       ),
                    //       angle: 90,
                    //       positionFactor: 0.5),
                    // ],
                  ),
                ],
              ),
            ),
            Text(
              '${_currentSpeed.toStringAsFixed(2)} km/h',
              style: const TextStyle(fontSize: 48, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            Text(
              overSpeed(),
              style: const TextStyle(fontSize: 40, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            // const Icon(
            //   Icons.speed,
            //   size: 100,
            //   color: Colors.blue,
            // ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RealTimeSpeedTracker(),
  ));
}
