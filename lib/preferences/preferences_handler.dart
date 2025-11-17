import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";
  static const String tokenKey = "token";

  // SAVE LOGIN STATUS
  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  // GET LOGIN STATUS
  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin) ?? false;
  }

  // REMOVE LOGIN STATUS
  static removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLogin);
  }

  // SAVE TOKEN
  static saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, token);
  }

  // GET TOKEN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // REMOVE TOKEN
  static removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(tokenKey);
  }
}
