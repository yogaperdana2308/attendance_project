// import 'package:attendance_project/view/register_screen.dart';
// import 'package:attendance_project/widget/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_d7/API_day33/services/api.dart';
// import 'package:flutter_d7/API_day33/view/dashboard.dart';
// import 'package:flutter_d7/API_day33/view/register_screen.dart';
// import 'package:flutter_d7/API_day33/widget/login_akun.dart';
// import 'package:flutter_d7/API_day33/widget/login_button.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool hidePass = true;
//   final emailC = TextEditingController();
//   final passC = TextEditingController();
//   final formKey = GlobalKey<FormState>();

//   bool loading = false;

//   Future<void> handleLogin() async {
//     if (!formKey.currentState!.validate()) return;

//     setState(() => loading = true);

//     try {
//       final result = await AuthAPI.loginUser(
//         email: emailC.text,
//         password: passC.text,
//       );

//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString("token", result.data?.token ?? "");

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => DashboardPage(user: result.data!.user),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.toString())));
//     }

//     setState(() => loading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffFFF2C6),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: formKey,
//             child: Column(
//               children: [
//                 const SizedBox(height: 40),
//                 const Text(
//                   "Welcome Back!",
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                 ),
//                 const Text("Login untuk melanjutkan"),
//                 const SizedBox(height: 30),

//                 LoginAkun(
//                   input: "Email",
//                   icon: Icons.email_outlined,
//                   controller: emailC,
//                   validator: (v) =>
//                       v!.isEmpty ? "Email tidak boleh kosong" : null,
//                 ),

//                 const SizedBox(height: 16),

//                 LoginAkun(
//                   input: "Password",
//                   isPassword: true,
//                   obscurePass: hidePass,
//                   icon: Icons.lock_outline,
//                   controller: passC,
//                   whenPress: () => setState(() => hidePass = !hidePass),
//                   validator: (v) =>
//                       v!.isEmpty ? "Password tidak boleh kosong" : null,
//                 ),

//                 const SizedBox(height: 30),

//                 CustomButton(
//                   label: loading ? "Loading..." : "Login",
//                   isLogin: true,
//                   onPress: loading ? null : handleLogin,
//                 ),

//                 const SizedBox(height: 20),

//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const RegisterScreenAttendence()),
//                     );
//                   },
//                   child: const Text(
//                     "Belum punya akun? Daftar",
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
