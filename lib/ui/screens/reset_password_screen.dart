import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/forgot_password_otp_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            hintText: 'Password',
          ),
        ),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Confirm Password',
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _onTabNextButton,
          child: const Icon(Icons.arrow_circle_right_outlined),
        ),
      ],
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
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (_) => false);
  }

  void _onTabSgnInForm() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (_) => false);
  }
}
