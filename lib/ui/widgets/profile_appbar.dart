import 'package:flutter/material.dart';
import 'package:taskmanager/ui/controllers/auth_controller.dart';
import 'package:taskmanager/ui/screens/auth/signin_screen.dart';
import 'package:taskmanager/ui/screens/update_profile_screen.dart';
import 'package:taskmanager/ui/utility/app_colors.dart';

AppBar ProfileAppbar(context) {
  return AppBar(
    backgroundColor: AppColors.themeColor,
    leading: GestureDetector(
      onTap: () {
        _onTapProfile(context);
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          child: Icon(Icons.person),
          backgroundColor: AppColors.white,
        ),
      ),
    ),
    title: GestureDetector(
      onTap: () {
        _onTapProfile(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              AuthController.userData?.fullName ?? '',
              style: const TextStyle(fontSize: 16, color: AppColors.white)),
          Text(
            AuthController.userData?.email ?? '',
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.white,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        onPressed: () async {
          await AuthController.clearAllData();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false,
          );
        },
        icon: const Icon(Icons.logout),
      )
    ],
  );
}

void _onTapProfile(context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const UpdateProfileScreen(),
    ),
  );
}
