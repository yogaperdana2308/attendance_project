import 'package:attendance_project/view/checkin_screen.dart';
import 'package:attendance_project/view/login_screen.dart';
import 'package:attendance_project/view/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/login_screen": (context) => LoginScreenAttendence(),
        "/register_screen": (context) => RegisterScreenAttendence(),
        "/dashboard": (context) => DashboardScreenAttendence(),
        // "/bottom_navigasi": (context) => BottomNavigasi(currentIndex: index),
      },

      title: 'E-Nventory',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      home: DashboardScreenAttendence(),
    );
  }
}
