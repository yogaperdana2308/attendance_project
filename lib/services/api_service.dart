import 'dart:convert';
import 'dart:developer';

import 'package:attendance_project/models/attedance_history.dart';
import 'package:attendance_project/models/check_in.dart';
import 'package:attendance_project/models/stats_model.dart';
import 'package:attendance_project/preferences/preferences_handler.dart';
import 'package:http/http.dart' as http;

import '../constant/endpoint.dart';
import '../models/batch_model.dart';
import '../models/register_model.dart';
import '../models/training_model.dart';

class AuthAPI {
  // ================== REGISTER ==================
  static Future<RegisterModel> registerUser({
    required String email,
    String? name,
    required String password,
    String? jenisKelamin,
    int? batchId,
    int? trainingId,
    String profilePhoto = "",
  }) async {
    final url = Uri.parse(Endpoint.register);

    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {
        "name": name,
        "email": email,
        "password": password,
        "jenis_kelamin": jenisKelamin,
        "profile_photo": profilePhoto,
        "batch_id": batchId.toString(),
        "training_id": trainingId.toString(),
      },
    );

    log("REGISTER: ${response.statusCode}");
    log(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RegisterModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Terjadi kesalahan");
    }
  }

  // ================== LOGIN ==================
  static Future<RegisterModel> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Endpoint.login);

    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );

    log("LOGIN: ${response.statusCode}");
    log(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RegisterModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Email atau password salah");
    }
  }
}

class TrainingAPI {
  // ================== GET TRAINING LIST ==================
  static Future<List<TrainingModelData>> getTrainings() async {
    final url = Uri.parse(Endpoint.trainings);

    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    log("GET Trainings: ${response.statusCode}");
    log(response.body);

    if (response.statusCode == 200) {
      final data = trainingModelFromJson(response.body);
      return data.data ?? [];
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal memuat data training");
    }
  }

  // ================== GET BATCH LIST ==================
  static Future<List<BatchModelData>> getTrainingBatches() async {
    final url = Uri.parse(Endpoint.trainingBatches);

    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    log("GET Batches: ${response.statusCode}");
    log(response.body);

    if (response.statusCode == 200) {
      final data = batchModelFromJson(response.body);
      return data.data ?? [];
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal memuat batch");
    }
  }

  // ================== CHECK IN ==================
  static Future<AttendenceModel> checkIn({
    required String attendanceDate,
    required String CheckInTime,
    required double checkInLat,
    required double checkInLng,
    required String checkInAddress,
    required String status,
  }) async {
    final String? token = await PreferenceHandler.getToken();
    final url = Uri.parse(Endpoint.checkin);

    final response = await http.post(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {
        "attendance_date": attendanceDate,
        "check_in": CheckInTime,
        "check_in_lat": checkInLat.toString(),
        "check_in_lng": checkInLng.toString(),
        "check_in_address": checkInAddress,
        "status": status,
      },
    );

    log("CHECK IN: ${response.statusCode}");
    log(response.body);

    if (response.statusCode == 200) {
      return AttendenceModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"]);
    }
  }

  //================ CHECK - OUT ======================//
  static Future<AttendenceModel> CheckOut({
    required String attendanceDate,
    required String CheckoutTime,
    required double checkoutLat,
    required double checkoutLng,
    required String checkoutAddress,
    required String status,
  }) async {
    final String? token = await PreferenceHandler.getToken();
    final url = Uri.parse(Endpoint.checkout);

    final response = await http.post(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {
        "attendance_date": attendanceDate,
        "check_out": CheckoutTime,
        "check_out_lat": checkoutLat.toString(),
        "check_out_lng": checkoutLng.toString(),
        "check_out_address": checkoutAddress,
        "status": status,
      },
    );

    log("CHECK OUT: ${response.statusCode}");
    log(response.body);

    if (response.statusCode == 200) {
      return AttendenceModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"]);
    }
  }

  // ================== GET ATTENDANCE STATS ==================
  static Future<StatsModel> getStatsAttendence() async {
    final url = Uri.parse(Endpoint.absenstats);
    final String? token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    log("STATS: ${response.statusCode}");
    log(response.body);

    if (response.statusCode == 200) {
      return statsModelFromJson(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal mengambil statistik");
    }
  }

  // ================== GET ATTENDANCE HISTORY ==================
  static Future<List<AttendanceHistoryModel>> getAttendanceHistory() async {
    final String? token = await PreferenceHandler.getToken();
    final url = Uri.parse(Endpoint.historyAbsen);

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    log("HISTORY ABSEN: ${response.statusCode}");
    log(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Ambil LIST dari field "data"
      final List list = jsonData["data"];

      // Convert list ke model
      return list.map((item) => AttendanceHistoryModel.fromJson(item)).toList();
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal mengambil riwayat absensi");
    }
  }
}
