import 'package:attendance_project/services/api_service.dart';
import 'package:attendance_project/view/checkin_screen.dart';
import 'package:attendance_project/view/register_screen.dart';
import 'package:attendance_project/widget/custom_button.dart';
import 'package:attendance_project/widget/textfield.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenAttendence extends StatefulWidget {
  const LoginScreenAttendence({super.key});

  @override
  State<LoginScreenAttendence> createState() => _LoginScreenAttendenceState();
}

class _LoginScreenAttendenceState extends State<LoginScreenAttendence> {
  bool hidePass = true;
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool loading = false;

  Future<void> handleLogin() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final result = await AuthAPI.loginUser(
        email: emailC.text,
        password: passC.text,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", result.data?.token ?? "");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TakeAttendenceScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF2C6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text("Login untuk melanjutkan"),
                SizedBox(height: 72),

                CustomTextField(
                  hint: 'example@gmail.com',
                  label: "Email",
                  icon: Icons.email_outlined,
                  controller: emailC,
                  validator: (v) =>
                      v!.isEmpty ? "Email tidak boleh kosong" : null,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  hint: 'Password123.',
                  label: "Password",
                  isPassword: true,
                  obscure: hidePass,
                  icon: Icons.lock_outline,
                  controller: passC,
                  onToggleObscure: () => setState(() => hidePass = !hidePass),
                  validator: (v) =>
                      v!.isEmpty ? "Password tidak boleh kosong" : null,
                ),

                SizedBox(height: 30),

                CustomButton(
                  label: loading ? " " : "Login",
                  isLoading: false,
                  onPressed: () {
                    loading ? null : handleLogin();
                  },
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreenAttendence(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun?",
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(width: 12),
                      Text("Daftar", style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
