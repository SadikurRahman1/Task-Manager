import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/forgot_password_otp_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controllers/auth_controller.dart';
import '../widgets/snack_bar_massage.dart';
import 'main_bottom_nav_bar_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.otp, required this.email});

  final String email;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _conformPasswordTEController =
      TextEditingController();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 82),
                Text('Set Password',
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(height: 8),
                Text('Minimum number of password should be 6 letters',
                    style: textTheme.titleSmall?.copyWith(
                      color: Colors.grey,
                    )),
                const SizedBox(height: 24),
                _buildResetPasswordForm(),
                const SizedBox(height: 48),
                Center(
                  child: _buildHaveAccountSection(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
              controller: _passwordTEController,
              // keyboardType: TextInputType.visiblePassword,
              // obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Password can\'t be empty';
                  // } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  //   return 'Password must contain at least one uppercase letter';
                  // } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                  //   return 'Password must contain at least one lowercase letter';
                  // } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                  //   return 'Password must contain at least one number';
                  // } else if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                  //   return 'Password must contain at least one special character (!@#\$&*~)';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              }),
          const SizedBox(height: 8),
          // TextFormField(
          //     controller: _conformPasswordTEController,
          //     decoration: const InputDecoration(
          //       hintText: 'Confirm Password',
          //     ),
          //     validator: (String? value) {
          //       if (value == null || value.isEmpty) {
          //         return 'Password can\'t be empty';
          //         // } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
          //         //   return 'Password must contain at least one uppercase letter';
          //         // } else if (!RegExp(r'[a-z]').hasMatch(value)) {
          //         //   return 'Password must contain at least one lowercase letter';
          //         // } else if (!RegExp(r'[0-9]').hasMatch(value)) {
          //         //   return 'Password must contain at least one number';
          //         // } else if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
          //         //   return 'Password must contain at least one special character (!@#\$&*~)';
          //       } else if (value.length < 6) {
          //         return 'Password must be at least 6 characters long';
          //       } else if (value != _passwordTEController.text) {
          //         return 'Password not match';
          //       }
          //       return null;
          //     }),
          const SizedBox(height: 24),
          Visibility(
            visible: !_inProgress,
            replacement: const CircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: _onTabNextButton,
              child: const Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHaveAccountSection() {
    return RichText(
      text: TextSpan(
        text: "Have account",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        children: [
          TextSpan(
            text: ' Sign In',
            style: const TextStyle(
              color: AppColors.themeColor,
            ),
            recognizer: TapGestureRecognizer()..onTap = _onTabSgnInForm,
          )
        ],
      ),
    );
  }

  void _onTabNextButton() {
    if (_formKey.currentState!.validate()) {
      _setNewPassword();
    }
  }

  Future<void> _setNewPassword() async {
    _inProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _passwordTEController.text,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.recoverResetPassword,
      body: requestBody,
    );
    _inProgress = false;
    setState(() {});

    if (response.isSuccess) {


      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
          (_) => false);
    } else {
      showSnackBarMassage(context, response.errorMassage, true);
    }
  }

  void _onTabSgnInForm() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
      (_) => false,
    );
  }
}
