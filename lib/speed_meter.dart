import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(SpeedMeterApp());

class SpeedMeterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPS Speed Meter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SpeedometerScreen(),
    );
  }
}

class SpeedometerScreen extends StatefulWidget {
  @override
  _SpeedometerScreenState createState() => _SpeedometerScreenState();
}

class _SpeedometerScreenState extends State<SpeedometerScreen> {
  double _currentSpeed = 0.0;
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(23.753975054289747, 90.37981606293368);

  @override
  void initState() {
    super.initState();
    _getSpeedAndLocation();
  }

  Future<void> _getSpeedAndLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentSpeed =
            (position.speed * 3.6).clamp(0, double.infinity); // Convert to km/h
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Speed Meter'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 14.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: _currentPosition,
                ),
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Current Speed',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_currentSpeed.toStringAsFixed(1)} km/h',
                    style: const TextStyle(fontSize: 48, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildLineChart(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: [
              FlSpot(0, _currentSpeed), // Example point
              // Additional spots can be added dynamically
            ],
            color: Colors.blue,
            dotData: const FlDotData(show: false),
          ),
        ],
        // titlesData: FlTitlesData(
        //   leftTitles: SideTitles(showTitles: false),
        //   bottomTitles: SideTitles(showTitles: false),
        // ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}






