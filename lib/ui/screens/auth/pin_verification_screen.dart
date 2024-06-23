import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:taskmanager/ui/screens/auth/reset_password_screen.dart';
import 'package:taskmanager/ui/screens/auth/signin_screen.dart';
import 'package:taskmanager/ui/utility/app_colors.dart';
import 'package:taskmanager/ui/widgets/background_widget.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  TextEditingController _pinTEcontroller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _pinTEcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Pin Verifiactiom',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Enter 6 digit pin',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildPinField(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: _onTapVerifyButton, child: const Text('Verify')),
                  const SizedBox(
                    height: 36,
                  ),
                  _buildSigninSection()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinField() {
    return PinCodeTextField(
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
        selectedFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedColor: AppColors.themeColor,
      ),
      keyboardType: const TextInputType.numberWithOptions(),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: _pinTEcontroller,
      onCompleted: (v) {},
      appContext: context,
    );
  }

  Widget _buildSigninSection() {
    return Center(
      child: Column(children: [
        RichText(
            text: TextSpan(
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
                text: "Have an account? ",
                children: [
              TextSpan(
                  text: 'Sign in',
                  style: const TextStyle(color: AppColors.themeColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _onTapSignInButton();
                    })
            ]))
      ]),
    );
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false);
  }

  void _onTapVerifyButton() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()));
  }
}
