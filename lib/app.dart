import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controller_binder.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/screens/cancelled_task_screen.dart';
import 'package:task_manager/ui/screens/forgot_password_email_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:task_manager/ui/screens/new_task_screen.dart';
import 'package:task_manager/ui/screens/profile_screen.dart';
import 'package:task_manager/ui/screens/progress_task_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
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
    return GetMaterialApp(
      navigatorKey: TaskManager.NavigatorKey,
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        inputDecorationTheme: _buildInputDecorationTheme(),
        elevatedButtonTheme: _buildElevatedButtonThemeData()
      ),
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBinder(),
      initialRoute: '/',
      routes: {
        Splashscreen.name : (context) => const Splashscreen(),
        MainBottomNavBarScreen.name : (context) => const MainBottomNavBarScreen(),
        NewTaskScreen.name : (context) => const NewTaskScreen(),
        // CompletedTaskScreen.name : (context) => const CompletedTaskScreen(),
        CancelledTaskScreen.name : (context) => const CancelledTaskScreen(),
        ProgressTaskScreen.name : (context) => const ProgressTaskScreen(),
        AddNewTaskScreen.name : (context) => const AddNewTaskScreen(),
        SignUpScreen.name : (context) => const SignUpScreen(),
        SignInScreen.name : (context) => const SignInScreen(),
        ForgotPasswordEmailScreen.name : (context) => const ForgotPasswordEmailScreen(),
        ProfileScreen.name : (context) => const ProfileScreen(),
        // NewTaskScreen.name : (context) => const SignInScreen(),
      },
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
