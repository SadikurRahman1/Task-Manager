import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  static GlobalKey<NavigatorState> NavigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManager.NavigatorKey,
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        inputDecorationTheme: _buildInputDecorationTheme(),
        elevatedButtonTheme: _buildElevatedButtonThemeData()
      ),
      debugShowCheckedModeBanner: false,
      home: const Splashscreen(),
    );
  }

  InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w300,
        ),
        border: _buildOutlineInputBorder(),
        errorBorder: _buildOutlineInputBorder(),
        focusedBorder: _buildOutlineInputBorder(),
        enabledBorder: _buildOutlineInputBorder(),
      );
  }

  OutlineInputBorder _buildOutlineInputBorder() {
    return OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8)
        );
  }

  ElevatedButtonThemeData _buildElevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.themeColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          fixedSize: const Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          )
      ),
    );
  }


}
