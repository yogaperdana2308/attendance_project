import 'package:attendance_project/preferences/preferences_handler.dart';
import 'package:attendance_project/services/api_service.dart';
import 'package:attendance_project/view/bottom_navigasi.dart';
import 'package:attendance_project/view/register_screen.dart';
import 'package:attendance_project/widget/custom_button.dart';
import 'package:attendance_project/widget/textfield.dart';
import 'package:flutter/material.dart';

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
        email: emailC.text.trim(),
        password: passC.text.trim(),
      );

      // ========================
      //  SAVE TOKEN
      // ========================
      await PreferenceHandler.saveToken(result.data?.token ?? "");

      // ========================
      //  SAVE USERNAME + EMAIL
      // ========================
      final user = result.data?.user;

      await PreferenceHandler.saveUsername(user?.name ?? "User");
      await PreferenceHandler.saveEmail(user?.email ?? "-");

      print("DEBUG USERNAME = ${user?.name}");
      print("DEBUG EMAIL = ${user?.email}");

      // ========================
      //  NOTE:
      //  API LOGIN TIDAK PUNYA TRAINING/BATCH
      //  Jadi tidak disimpan dari login
      // ========================

      // PINDAH KE BOTTOM NAV
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Bottomnav()),
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
      backgroundColor: const Color(0xffFFF2C6),
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
                const Text("Login untuk melanjutkan"),
                const SizedBox(height: 72),

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

                const SizedBox(height: 30),

                CustomButton(
                  label: loading ? " " : "Login",
                  isLoading: loading,
                  onPressed: () => loading ? null : handleLogin(),
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
                    children: const [
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
