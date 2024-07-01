import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/network_response.dart';
import 'package:taskmanager/data/network_caller/network_caller.dart';
import 'package:taskmanager/data/utilities/urls.dart';
import 'package:taskmanager/ui/utility/app_colors.dart';
import 'package:taskmanager/ui/utility/app_constants.dart';
import 'package:taskmanager/ui/widgets/background_widget.dart';
import 'package:taskmanager/ui/widgets/circuler_process_indicator.dart';
import 'package:taskmanager/ui/widgets/snack_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEcontroller = TextEditingController();
  final TextEditingController _firstnameTEcontroller = TextEditingController();
  final TextEditingController _lastnameTEcontroller = TextEditingController();
  final TextEditingController _mobileTEcontroller = TextEditingController();
  final TextEditingController _passwordTEcontroller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _regInProgress = false;
  @override
  void dispose() {
    super.dispose();
    _emailTEcontroller.dispose();
    _firstnameTEcontroller.dispose();
    _lastnameTEcontroller.dispose();
    _mobileTEcontroller.dispose();
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      'Join With Us',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: _emailTEcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (String? value){
                        if(value!.trim().isEmpty){
                          return 'Enter your email address';
                        }
                        if(AppConstants.emailRegExp.hasMatch(value) == false){
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      controller: _firstnameTEcontroller,
                      decoration: const InputDecoration(
                        hintText: 'First Name',
                      ),
                      validator: (value){
                        if(value!.trim().isEmpty){
                          return 'Enter your first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _lastnameTEcontroller,
                      decoration: const InputDecoration(
                        hintText: 'Last Name',
                      ),
                      validator: (value){
                        if(value!.trim().isEmpty){
                          return 'Enter your last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _mobileTEcontroller,
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: const InputDecoration(
                        hintText: 'Mobile',
                      ),
                      validator: (value){
                        if(value!.trim().isEmpty){
                          return 'Enter your mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      obscureText: _showPassword == false,
                      controller: _passwordTEcontroller,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: (){
                          _showPassword = !_showPassword;
                          setState(() {});
                        }, icon: Icon(
                            _showPassword ? Icons.visibility_off : Icons.visibility
                        )),
                        hintText: 'Password',
                      ),
                      validator: (value){
                        if(value!.trim().isEmpty){
                          return 'Enter password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _regInProgress == false,
                      replacement: const CircleLoader(),
                      child: ElevatedButton(
                          onPressed: () {
                            if(_formkey.currentState!.validate()){
                              _registerUser();
                            }
                          }, child: const Icon(Icons.arrow_forward_ios)),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    _buildBackToSignInSection()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToSignInSection() {
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
                                style: const TextStyle(
                                    color: AppColors.themeColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _onTapSignInButton();
                                  })
                          ]))
                    ]),
                  );
  }



  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  Future<void> _registerUser() async{
    _regInProgress = true;
    if(mounted) setState(() {});
    Map<String, dynamic> requestInput = {
      "email":_emailTEcontroller.text.trim(),
      "firstName":_firstnameTEcontroller.text.trim(),
      "lastName":_lastnameTEcontroller.text.trim(),
      "mobile":_mobileTEcontroller.text.trim(),
      "password":_passwordTEcontroller.text,
      "photo":""
    };
    NetworkResponse response = await NetworkCaller.postRequest(Urls.registration, requestInput);
    _regInProgress = false;
    if(mounted) setState(() {});
    if(response.isSuccess){
      _clearFields();
      if(mounted){
        showSnackBarMessage(context, 'Registration Successfull');
      }
    }else{
      showSnackBarMessage(context, response.errorMsg ?? 'Registration Failed! Try again');
    }
  }

  void _clearFields() {
    _emailTEcontroller.clear();
    _firstnameTEcontroller.clear();
    _lastnameTEcontroller.clear();
    _mobileTEcontroller.clear();
    _passwordTEcontroller.clear();
  }
}


