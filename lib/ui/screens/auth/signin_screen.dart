import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/login_model.dart';
import 'package:taskmanager/data/models/network_response.dart';
import 'package:taskmanager/data/network_caller/network_caller.dart';
import 'package:taskmanager/data/utilities/urls.dart';
import 'package:taskmanager/ui/controllers/auth_controller.dart';
import 'package:taskmanager/ui/screens/auth/email_verification_screen.dart';
import 'package:taskmanager/ui/screens/auth/sign_up_screen.dart';
import 'package:taskmanager/ui/screens/main_bottom_navbar.dart';
import 'package:taskmanager/ui/utility/app_colors.dart';
import 'package:taskmanager/ui/utility/app_constants.dart';
import 'package:taskmanager/ui/widgets/background_widget.dart';
import 'package:taskmanager/ui/widgets/snack_bar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEcontroller = TextEditingController();
  final TextEditingController _passwordTEcontroller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _signInInProgress = false;
  @override
  void dispose() {
    super.dispose();
    _emailTEcontroller.dispose();
    _passwordTEcontroller.dispose();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      'Get Started With',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: _emailTEcontroller,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (String? value) {
                        if (value!.trim().isEmpty) {
                          return 'Enter your email address';
                        }
                        if (AppConstants.emailRegExp.hasMatch(value) == false) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _passwordTEcontroller,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _signInInProgress == false,
                      replacement: const Center(child: CircularProgressIndicator(),),
                      child: ElevatedButton(
                          onPressed: _onTapSignInButton,
                          child: const Icon(Icons.arrow_forward_ios)),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Center(
                      child: Column(children: [
                        TextButton(
                            onPressed: _onTapForgotpasswordButton,
                            child: Text(
                              'Forgot password?',
                              style: Theme.of(context).textTheme.titleSmall,
                            )),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                                text: "Don't have an account? ",
                                children: [
                              TextSpan(
                                text: 'Sign up',
                                style: const TextStyle(
                                    color: AppColors.themeColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _onTapSignUpButton();
                                  },
                              )
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

  void _onTapSignUpButton() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  Future<void> _signIn() async {
    _signInInProgress = true;
    if (mounted) setState(() {});
    Map<String, dynamic> requestData = {
      'email': _emailTEcontroller.text.trim(),
      'password': _passwordTEcontroller.text
    };

    final NetworkResponse response =
        await NetworkCaller.postRequest(Urls.login, requestData);

    

    _signInInProgress = false;
    if(mounted) setState(() {});

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.response!);
      await AuthController.saveUserAccessToken(loginModel.token.toString());
      await AuthController.saveUserData(loginModel.userModel!);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainBottomNavBar(),
          ),
        );
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, response.errorMsg?.toString() ?? 'Invalid Information');
      }
    }


  }

  void _onTapForgotpasswordButton() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EmailVerificationScreen()));
  }

  void _onTapSignInButton() {
    if (_formkey.currentState!.validate()) {
      _signIn();
    }
  }
}
