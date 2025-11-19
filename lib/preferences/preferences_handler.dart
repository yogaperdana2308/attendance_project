import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";
  static const String tokenKey = "token";

  static const String usernameKey = "username";
  static const String emailKey = "email";

  static const String trainingKey = "training";
  static const String batchKey = "batch";

  // ========================
  // LOGIN STATUS
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

  // ========================
  // TOKEN
  // ========================
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

  // ========================
  // USERNAME
  // ========================
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

  // ========================
  // EMAIL
  // ========================
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

  // ========================
  // TRAINING
  // ========================
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

  // ========================
  // BATCH
  // ========================
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

  // di PreferenceHandler (file preferences_handler.dart)
  static const String checkInStatusKey = "checkin_status";
  static const String checkInTimeKey = "checkin_time";

  // SIMPAN STATUS CHECK-IN (contoh value: "checked" / "unchecked")
  static saveCheckInStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(checkInStatusKey, status);
  }

  // GET STATUS CHECK-IN
  static Future<String?> getCheckInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(checkInStatusKey);
  }

  // REMOVE STATUS (logout / reset)
  static removeCheckInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(checkInStatusKey);
  }

  // (opsional) simpan waktu check-in
  static saveCheckInTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(checkInTimeKey, time);
  }

  static Future<String?> getCheckInTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(checkInTimeKey);
  }

  static removeCheckInTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(checkInTimeKey);
  }
}
