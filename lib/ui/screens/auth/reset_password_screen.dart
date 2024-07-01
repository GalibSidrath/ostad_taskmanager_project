import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/network_response.dart';
import 'package:taskmanager/data/network_caller/network_caller.dart';
import 'package:taskmanager/data/utilities/urls.dart';
// import 'package:taskmanager/ui/screens/auth/email_verification_screen.dart';
// import 'package:taskmanager/ui/screens/auth/sign_up_screen.dart';
import 'package:taskmanager/ui/screens/auth/signin_screen.dart';
import 'package:taskmanager/ui/utility/app_colors.dart';
import 'package:taskmanager/ui/widgets/background_widget.dart';
import 'package:taskmanager/ui/widgets/circuler_process_indicator.dart';
import 'package:taskmanager/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.userEmail, required this.OTP});
  final String userEmail;
  final String OTP;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEcontroller = TextEditingController();
  final TextEditingController _confirmNewPasswordTEcontroller =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _confirmNewPasswordInProcess = false;
  @override
  void dispose() {
    super.dispose();
    _newPasswordTEcontroller.dispose();
    _confirmNewPasswordTEcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      'Set A New Password',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Minimum length of 8 character with the combination of number and letters',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: _newPasswordTEcontroller,
                      decoration: const InputDecoration(
                        hintText: 'New Password',
                      ),
                      validator: (String? value){
                        if(value!.isEmpty){
                          return 'Enter a new password';
                        }
                      },
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _confirmNewPasswordTEcontroller,
                      decoration: const InputDecoration(
                        hintText: 'Confirm New Password',
                      ),
                      validator: (String? value){
                        if(value!.isEmpty){
                          return 'Please Enter Confirm New Password';
                        }
                        if(value! != _newPasswordTEcontroller.text){
                          return 'Password did not matched!';
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _confirmNewPasswordInProcess == false,
                      replacement: const CircleLoader(),
                      child: ElevatedButton(
                          onPressed: (){
                            if(_formkey.currentState!.validate()){
                              _onTapConfirmButton();
                              debugPrint('Reset Password Sucecessfull');
                            }
                          }, child: const Text('Confirm'),),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Center(
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
                                  style: const TextStyle(
                                      color: AppColors.themeColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _onTapSignInButton();
                                    })
                            ]))
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false);
  }

  Future<void> _onTapConfirmButton() async {
    _confirmNewPasswordInProcess = true;
    if (mounted) setState(() {});
    Map<String, dynamic> requestData = {
      "email": widget.userEmail,
      "OTP": widget.OTP,
      "password": _confirmNewPasswordTEcontroller.text
    };
    NetworkResponse response = await NetworkCaller.postRequest(
        Urls.recoverResetPass, requestData);
    if (response.isSuccess) {
      if (mounted) {
        showSnackBarMessage(context, 'Password reset successful');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false);
      }
    } else {
      if (response.isSuccess) {
        if (mounted) {
          showSnackBarMessage(
              context, response.errorMsg ?? 'Failed! Try again');
        }
      }
    }
    _confirmNewPasswordInProcess = false;
    if (mounted) setState(() {});
  }
}
