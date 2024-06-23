import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskmanager/ui/controllers/auth_controller.dart';
import 'package:taskmanager/ui/screens/auth/signin_screen.dart';
import 'package:taskmanager/ui/screens/main_bottom_navbar.dart';
import 'package:taskmanager/ui/utility/assets_paths.dart';
import 'package:taskmanager/ui/widgets/background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _moveToNextScreen() async {
    bool logInCheck = await AuthController.checkAuthState();
    debugPrint(logInCheck.toString());
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return logInCheck ? const MainBottomNavBar() : const SignInScreen();
      }));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _moveToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BackgroundWidget(
            child: Center(
          child: SvgPicture.asset(AssetPaths.logoImage),
        )),
      ),
    );
  }
}
