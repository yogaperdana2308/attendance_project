import 'package:attendance_project/models/batch_model.dart';
import 'package:attendance_project/models/register_model.dart';
import 'package:attendance_project/models/training_model.dart';
import 'package:attendance_project/preferences/preferences_handler.dart';
import 'package:attendance_project/services/api_service.dart';
import 'package:attendance_project/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreenAttendence extends StatefulWidget {
  const RegisterScreenAttendence({super.key});
  static const id = "/register_Attendence";

  @override
  State<RegisterScreenAttendence> createState() =>
      _RegisterScreenAttendenceState();
}

class _RegisterScreenAttendenceState extends State<RegisterScreenAttendence> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isVisibility = false;
  bool isLoading = false;
  bool isLoadingDropdown = false;

  RegisterModel user = RegisterModel();

  final _formKey = GlobalKey<FormState>();

  // --- state baru ---
  String? selectedGender; // 'L' / 'P'
  int? selectedTrainingId;
  int? selectedBatchId;

  List<TrainingModelData> trainings = [];
  List<BatchModelData> batches = [];

  final List<Map<String, String>> genderOptions = const [
    {"label": "Laki-laki", "value": "L"},
    {"label": "Perempuan", "value": "P"},
  ];

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    setState(() {
      isLoadingDropdown = true;
      selectedTrainingId = null;
      selectedBatchId = null;
    });
    try {
      final trainingList = await TrainingAPI.getTrainings();
      final batchList = await TrainingAPI.getTrainingBatches();
      setState(() {
        trainings = trainingList;
        batches = batchList;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Gagal mengambil data: $e');
    } finally {
      setState(() {
        isLoadingDropdown = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground(), buildLayer()]));
  }

  SafeArea buildLayer() {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Hello, Welcome",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  height(12),
                  const Text("Register to access your account"),
                  height(24),

                  // --- Email ---
                  buildTitle("Email Address"),
                  height(12),
                  buildTextField(
                    hintText: "Enter your email",
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email tidak boleh kosong";
                      } else if (!value.contains('@')) {
                        return "Email tidak valid";
                      } else if (!RegExp(
                        r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$",
                      ).hasMatch(value)) {
                        return "Format Email tidak valid";
                      }
                      return null;
                    },
                  ),

                  height(16),

                  // --- Password ---
                  buildTitle("Password"),
                  height(12),
                  buildTextField(
                    hintText: "Enter your password",
                    isPassword: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      } else if (value.length < 6) {
                        return "Password minimal 6 karakter";
                      }
                      return null;
                    },
                  ),

                  height(16),

                  // --- Name ---
                  buildTitle("Name"),
                  height(12),
                  buildTextField(
                    hintText: "Enter your name",
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name tidak boleh kosong";
                      }
                      return null;
                    },
                  ),

                  height(16),

                  // --- Jenis Kelamin ---
                  buildTitle("Jenis Kelamin"),
                  height(12),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    isExpanded: true,
                    decoration: _dropdownDecoration(),
                    items: genderOptions
                        .map(
                          (g) => DropdownMenuItem<String>(
                            value: g['value'],
                            child: Text(g['label'] ?? ''),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Pilih jenis kelamin";
                      }
                      return null;
                    },
                  ),

                  height(16),

                  // --- Training ---
                  buildTitle("Pelatihan"),
                  height(12),
                  isLoadingDropdown
                      ? Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<int>(
                          value: selectedTrainingId,
                          isExpanded: true,
                          decoration: _dropdownDecoration(),
                          items: trainings
                              .map(
                                (t) => DropdownMenuItem<int>(
                                  value: t.id,
                                  child: Text(t.title ?? ''),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTrainingId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Pilih Kejuruan";
                            }
                            return null;
                          },
                        ),

                  height(16),

                  // --- Batch ---
                  buildTitle("Batch"),
                  height(12),
                  isLoadingDropdown
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<int>(
                          value: selectedBatchId,
                          isExpanded: true,
                          decoration: _dropdownDecoration(),
                          items: batches
                              .map(
                                (b) => DropdownMenuItem<int>(
                                  value: b.id,
                                  child: Text(b.batchKe ?? ''),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBatchId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Pilih batch pelatihan";
                            }
                            return null;
                          },
                        ),

                  height(24),

                  // --- Button Register ---
                  CustomButton(
                    label: "Register",
                    isLoading: isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (selectedGender == null ||
                            selectedTrainingId == null ||
                            selectedBatchId == null) {
                          Fluttertoast.showToast(
                            msg:
                                "Jenis kelamin, pelatihan, dan batch harus dipilih",
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        try {
                          final result = await AuthAPI.registerUser(
                            email: emailController.text.trim(),
                            name: nameController.text.trim(),
                            password: passwordController.text,
                            jenisKelamin: selectedGender!, // 'L' / 'P'
                            batchId: selectedBatchId!,
                            trainingId: selectedTrainingId!,
                            profilePhoto: "", // nanti bisa diisi base64
                          );

                          setState(() {
                            isLoading = false;
                            user = result;
                          });

                          // contoh: simpan token kalau ada
                          if (user.data?.token != null) {
                            await PreferenceHandler.saveToken(
                              user.data!.token!,
                            );
                          }
                        } catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Validation Error"),
                              content: const Text("Please fill all fields"),
                              actions: [
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: const Text("Ga OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),

                  height(16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/login_screen',
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: const BorderSide(color: Colors.black, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 202, 216, 241),
        // fit: BoxFit.cover,
      ),
    );
  }

  TextFormField buildTextField({
    String? hintText,
    bool isPassword = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: isPassword ? isVisibility : false,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: Colors.black, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : null,
      ),
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);

  Widget buildTitle(String text) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            // color: AppColor.gray88,
          ),
        ),
      ],
    );
  }
}
