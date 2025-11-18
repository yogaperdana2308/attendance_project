import 'dart:convert';
import 'dart:developer';

import 'package:attendance_project/models/attendence_model.dart';
import 'package:attendance_project/preferences/preferences_handler.dart';
import 'package:http/http.dart' as http;

import '../constant/endpoint.dart';
import '../models/batch_model.dart';
import '../models/register_model.dart';
import '../models/training_model.dart';

class AuthAPI {
  static Future<RegisterModel> registerUser({
    required String email,
    String? name,
    required String password,
    String? jenisKelamin, // 'L' / 'P'
    int? batchId,
    int? trainingId,
    String profilePhoto = "", // sementara kosong
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

    log(response.body);
    log('status: ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RegisterModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Terjadi kesalahan");
    }
  }

  static Future<RegisterModel> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Endpoint.login); // Gunakan Endpoint.login
    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );

    log('loginUser: ${response.statusCode}');
    log(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Asumsi respons login menggunakan struktur RegisterModel
      return RegisterModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      // Pesan error di sini akan muncul di Snackbar Anda
      throw Exception(error["message"] ?? "Email atau password salah");
    }
  }
}

class TrainingAPI {
  // Menggunakan TrainingModel untuk parse respons
  static Future<List<TrainingModelData>> getTrainings() async {
    final url = Uri.parse(Endpoint.trainings);
    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    log('getTrainings: ${response.statusCode}');
    log(response.body);

    if (response.statusCode == 200) {
      // 1. Gunakan model utama untuk mengurai seluruh respons
      final trainingModel = trainingModelFromJson(response.body);

      // 2. Kembalikan List data, jika null kembalikan list kosong
      return trainingModel.data ?? [];
    } else {
      // Tangani kesalahan jika status code bukan 200
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal mengambil data pelatihan");
    }
  }

  // Menggunakan BatchModel untuk parse respons
  static Future<List<BatchModelData>> getTrainingBatches() async {
    final url = Uri.parse(Endpoint.trainingBatches);
    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    log('getTrainingBatches: ${response.statusCode}');
    log(response.body);

    if (response.statusCode == 200) {
      // 1. Gunakan model utama untuk mengurai seluruh respons
      final batchModel = batchModelFromJson(response.body);

      // 2. Kembalikan List data, jika null kembalikan list kosong
      return batchModel.data ?? [];
    } else {
      // Tangani kesalahan jika status code bukan 200
      final error = json.decode(response.body);
      throw Exception(
        error["message"] ?? "Gagal mengambil data batch pelatihan",
      );
    }
  }

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
    print(response.body);
    print(response.statusCode);
    log(response.body);
    if (response.statusCode == 200) {
      return AttendenceModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"]);
    }
  }
}
