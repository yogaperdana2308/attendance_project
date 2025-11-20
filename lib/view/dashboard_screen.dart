import 'dart:async';

import 'package:attendance_project/models/stats_model.dart';
import 'package:attendance_project/preferences/preferences_handler.dart';
import 'package:attendance_project/services/api_service.dart';
import 'package:attendance_project/view/login_screen.dart';
import 'package:attendance_project/widget/account_information.dart';
import 'package:attendance_project/widget/attendence_stat.dart';
import 'package:attendance_project/widget/attendence_today.dart';
import 'package:attendance_project/widget/current_time.dart';
import 'package:attendance_project/widget/greeting_header.dart';
import 'package:flutter/material.dart';

class DashboardScreenAttendence extends StatefulWidget {
  const DashboardScreenAttendence({super.key});

  @override
  State<DashboardScreenAttendence> createState() =>
      _DashboardScreenAttendenceState();
}

class _DashboardScreenAttendenceState extends State<DashboardScreenAttendence> {
  late Timer _timer;
  DateTime currentTime = DateTime.now();

  StatsModel? stat;

  // Data yang diambil dari SharedPreferences
  String username = "-";
  String training = "-";
  String batch = "-";

  @override
  void initState() {
    super.initState();

    loadUserInfo();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => currentTime = DateTime.now());
    });

    loadData();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  // 🔥 Ambil username + training + batch
  Future<void> loadUserInfo() async {
    final savedName = await PreferenceHandler.getUsername();
    final savedTraining = await PreferenceHandler.getTraining();
    final savedBatch = await PreferenceHandler.getBatch();

    setState(() {
      username = savedName ?? "-";
      training = savedTraining ?? "-";
      batch = savedBatch ?? "-";
    });

    print("DEBUG username = $username");
    print("DEBUG training = $training");
    print("DEBUG batch = $batch");
  }

  Future<void> handleLogout() async {
    await PreferenceHandler.removeToken();
    await PreferenceHandler.removeUsername();
    await PreferenceHandler.removeEmail();
    await PreferenceHandler.removeTraining();
    await PreferenceHandler.removeBatch();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreenAttendence()),
    );
  }

  void loadData() async {
    final response = await TrainingAPI.getStatsAttendence();
    setState(() {
      stat = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hour = twoDigits(currentTime.hour);
    final minute = twoDigits(currentTime.minute);
    final second = twoDigits(currentTime.second);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingHeader(
                username: username,
                subtitle: "Welcome back to your dashboard",
                avatarUrl: "https://i.pravatar.cc/300",
                onLogout: handleLogout,
              ),

              // HEADER
              SizedBox(height: 20),

              // CURRENT TIME
              CurrentTimeCard(hour: hour, minute: minute, second: second),

              const SizedBox(height: 20),

              // ATTENDANCE TODAY
              const AttendanceTodayCard(),

              const SizedBox(height: 20),

              // ACCOUNT INFORMATION (DINAMIS)
              AccountInformationCard(
                username: username,
                training: training,
                batch: batch,
              ),

              const SizedBox(height: 20),

              // STATISTICS
              stat == null
                  ? const Center(child: CircularProgressIndicator())
                  : AttendanceStatisticsCard(
                      totalAbsen: stat!.data!.totalMasuk!,
                      totalIzin: stat!.data!.totalIzin!,
                    ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
