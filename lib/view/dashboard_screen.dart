import 'dart:async';
import 'package:attendance_project/widget/account_information.dart';
import 'package:attendance_project/widget/attendence_stat.dart';
import 'package:attendance_project/widget/attendence_today.dart';
import 'package:attendance_project/widget/current_time.dart';
import 'package:attendance_project/widget/greeting_header.dart';
import 'package:flutter/material.dart';

// Import widget yang sudah dipisah


class DashboardScreenAttendence extends StatefulWidget {
  const DashboardScreenAttendence({super.key});

  @override
  State<DashboardScreenAttendence> createState() =>
      _DashboardScreenAttendenceState();
}

class _DashboardScreenAttendenceState extends State<DashboardScreenAttendence> {
  late Timer _timer;
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Live clock updater
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String twoDigits(int n) => n.toString().padLeft(2, "0");

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

              // ------------------ HEADER -------------------
              GreetingHeader(
                username: "Budi Santoso",
                subtitle: "Welcome back to your dashboard",
                avatarUrl: "https://i.pravatar.cc/300",
              ),

              const SizedBox(height: 20),

              // ------------------ CURRENT TIME -------------------
              CurrentTimeCard(
                hour: hour,
                minute: minute,
                second: second,
              ),

              const SizedBox(height: 20),

              // ------------------ ATTENDANCE TODAY -------------------
              const AttendanceTodayCard(),

              const SizedBox(height: 20),

              // ------------------ ACCOUNT INFO -------------------
              const AccountInformationCard(),

              const SizedBox(height: 20),

              // ------------------ STATISTICS -------------------
              const AttendanceStatisticsCard(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
