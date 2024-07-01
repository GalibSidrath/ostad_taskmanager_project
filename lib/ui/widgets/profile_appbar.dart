import 'dart:convert';
// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:taskmanager/ui/controllers/auth_controller.dart';
import 'package:taskmanager/ui/screens/auth/signin_screen.dart';
import 'package:taskmanager/ui/screens/update_profile_screen.dart';
import 'package:taskmanager/ui/utility/app_colors.dart';
// import 'package:taskmanager/ui/utility/app_constants.dart';

AppBar ProfileAppbar(context) {
  return AppBar(
    backgroundColor: AppColors.themeColor,
    leading: GestureDetector(
      onTap: () {
        _onTapProfile(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          // backgroundColor: AppColors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: profileImage(),
          ),
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
        icon: const Icon(Icons.logout, color: AppColors.white,),
      )
    ],
  );
}

 Widget profileImage() {
  if(AuthController.userData?.photo != null && AuthController.userData!.photo!.isNotEmpty) {
    return Image.memory (
      base64Decode(AuthController.userData?.photo ?? ''),
      fit: BoxFit.fill,
      height: 90,
      width: 90,
    );
  }else{
    return const Icon(Icons.person);
  }
}

void _onTapProfile(context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const UpdateProfileScreen(),
    ),
  );
}
