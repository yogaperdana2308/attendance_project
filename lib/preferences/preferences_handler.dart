import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";
  static const String tokenKey = "token";

  static const String usernameKey = "username";
  static const String emailKey = "email";

  static const String trainingKey = "training";
  static const String batchKey = "batch";

  // ========================
  // CHECK-IN STATUS
  // ========================
  static const String checkInStatusKey = "checkin_status";
  static const String checkInTimeKey = "checkin_time";

  static saveCheckInStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(checkInStatusKey, status);
  }

  static Future<String?> getCheckInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(checkInStatusKey);
  }

  static saveCheckInTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(checkInTimeKey, time);
  }

  static Future<String?> getCheckInTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(checkInTimeKey);
  }

  static removeCheckInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(checkInStatusKey);
  }

  static removeCheckInTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(checkInTimeKey);
  }

  // ========================
  // CHECK-OUT STATUS (BARU)
  // ========================
  static const String checkOutStatusKey = "checkout_status";
  static const String checkOutTimeKey = "checkout_time";

  static saveCheckOutStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(checkOutStatusKey, status);
  }

  static Future<String?> getCheckOutStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(checkOutStatusKey);
  }

  static saveCheckOutTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(checkOutTimeKey, time);
  }

  static Future<String?> getCheckOutTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(checkOutTimeKey);
  }

  static removeCheckOutStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(checkOutStatusKey);
  }

  static removeCheckOutTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(checkOutTimeKey);
  }

  // ========================
  // UTILITY LAINNYA
  // ========================
  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin) ?? false;
  }

  static removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLogin);
  }

  static saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(tokenKey);
  }

  static saveUsername(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(usernameKey, name);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }

  static removeUsername() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(usernameKey);
  }

  static saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(emailKey, email);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  static removeEmail() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(emailKey);
  }

  static saveTraining(String training) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(trainingKey, training);
  }

  static Future<String?> getTraining() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(trainingKey);
  }

  static removeTraining() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(trainingKey);
  }

  static saveBatch(String batch) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(batchKey, batch);
  }

  static Future<String?> getBatch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(batchKey);
  }

  static removeBatch() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(batchKey);
  }

  static removeAllAttendanceStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(checkInStatusKey);
    prefs.remove(checkInTimeKey);
    prefs.remove(checkOutStatusKey);
    prefs.remove(checkOutTimeKey);
  }
}
