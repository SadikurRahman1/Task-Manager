import 'package:flutter/material.dart';
import 'package:task_manager/home.dart';
import 'package:task_manager/project.dart';
import 'package:task_manager/speed_meter.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: HomeScreen(),
      // home: SpeedometerScreen(),
      home: ProjectScreen(),
    );
  }
}
