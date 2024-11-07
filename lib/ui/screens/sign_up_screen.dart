import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_massage.dart';

import 'main_bottom_nav_bar_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
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
                Text('Join With Us',
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(height: 24),
                _buildSignInForm(),
                const SizedBox(height: 24),
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

  Widget _buildSignInForm() {
    return Form(
      key: _fromKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(hintText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email can\'n be empty';
              } else if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _firstNameEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(hintText: 'First Name'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter First Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _lastNameTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(hintText: 'Last Name'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter Last Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _mobileTEController,
            keyboardType: TextInputType.phone,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(hintText: 'Mobile'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter Mobile Number';
              // } else if (value?.length != 11) {
              //   return 'Please enter the correct number';
              }
              return null;
            },

          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(hintText: 'Password'),
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
            }


          ),
          const SizedBox(height: 24),
          Visibility(
            visible: !_inProgress,
            replacement: const CenterCircularProgressIndicator(),
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
    if (_fromKey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    _inProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
      "photo": ""
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.registration,
      body: requestBody,
    );
    _inProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _clearTextFields();
      showSnackBarMassage(context, 'New User add');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MainBottomNavBarScreen()));
    } else {
      showSnackBarMassage(context, response.errorMassage, true);
    }
  }

  void _clearTextFields() {
    _emailTEController.clear();
    _firstNameEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  void _onTabSgnInForm() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
