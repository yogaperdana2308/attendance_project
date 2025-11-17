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
        "/login_screen": (context) => const LoginScreenAttendence(),
        "/register_screen": (context) => const RegisterScreenAttendence(),
      },

      title: 'E-Nventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      home: RegisterScreenAttendence(),
    );
  }
}
