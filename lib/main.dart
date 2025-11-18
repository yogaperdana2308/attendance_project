import 'package:attendance_project/view/bottom_navigasi.dart';
import 'package:attendance_project/view/checkin_screen.dart';
import 'package:attendance_project/view/login_screen.dart';
import 'package:attendance_project/view/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';

void main() {
  // await initializeDateFormatting('id_ID', "");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/login_screen": (context) => LoginScreenAttendence(),
        "/register_screen": (context) => RegisterScreenAttendence(),
        "/dashboard": (context) => TakeAttendenceScreen(),
        
      },

      title: 'E-Nventory',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      home: Bottomnav(),
    );
  }
}
