import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanager/data/models/user_data_model.dart';

class AuthController {
  static const _accessTokenKey = 'access-key';
  static const _userDataKey = 'user-key';

  static String accessToken = '';
  static UserModel? userData;


  static Future<void> saveUserAccessToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_accessTokenKey, token);
    accessToken = token;
  }

  static Future<String?> getUserAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_accessTokenKey);
  }

  static Future<void> saveUserData(UserModel user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userDataKey, jsonEncode(user.toJson()));
    userData = user;
  }

  static Future<UserModel?> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? data = await sharedPreferences.getString(_userDataKey);

    if (data == null) return null;

    UserModel? userModel = UserModel.fromJson(jsonDecode(data));
    return userModel;
  }

  static Future<bool> checkAuthState() async {
    String? token = await getUserAccessToken();
    if (token == null) {
      return false;
    } else {
      accessToken = token;
      userData = await getUserData();
      return true;
    }
  }

  static Future<void> clearAllData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
