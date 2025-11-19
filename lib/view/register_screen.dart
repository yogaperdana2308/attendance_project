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

  // Dropdown State
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
                children: [
                  const Text(
                    "Hello, Welcome",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  height(12),
                  const Text("Register to access your account"),
                  height(24),

                  // EMAIL
                  buildTitle("Email Address"),
                  height(12),
                  buildTextField(
                    hintText: "Enter your email",
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email tidak boleh kosong";
                      }
                      if (!value.contains('@')) {
                        return "Format email tidak valid";
                      }
                      return null;
                    },
                  ),

                  height(16),

                  // PASSWORD
                  buildTitle("Password"),
                  height(12),
                  buildTextField(
                    hintText: "Enter your password",
                    isPassword: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      if (value.length < 6) {
                        return "Password minimal 6 karakter";
                      }
                      return null;
                    },
                  ),

                  height(16),

                  // NAME
                  buildTitle("Name"),
                  height(12),
                  buildTextField(
                    hintText: "Enter your name",
                    controller: nameController,
                    validator: (value) => value == null || value.isEmpty
                        ? "Name tidak boleh kosong"
                        : null,
                  ),

                  height(16),

                  // GENDER
                  buildTitle("Jenis Kelamin"),
                  height(12),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: _dropdownDecoration(),
                    items: genderOptions
                        .map(
                          (g) => DropdownMenuItem(
                            value: g['value'],
                            child: Text(g['label']!),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => selectedGender = v),
                    validator: (v) => v == null ? "Pilih jenis kelamin" : null,
                  ),

                  height(16),

                  // TRAINING
                  buildTitle("Pelatihan"),
                  height(12),
                  isLoadingDropdown
                      ? Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<int>(
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
                          onChanged: (v) =>
                              setState(() => selectedTrainingId = v),
                          validator: (v) => v == null ? "Pilih kejuruan" : null,
                        ),

                  height(16),

                  // BATCH
                  buildTitle("Batch"),
                  height(12),
                  isLoadingDropdown
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<int>(
                          value: selectedBatchId,
                          decoration: _dropdownDecoration(),
                          items: batches
                              .map(
                                (b) => DropdownMenuItem<int>(
                                  value: b.id,
                                  child: Text(b.batchKe ?? ''),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => selectedBatchId = v),
                          validator: (v) => v == null ? "Pilih batch" : null,
                        ),

                  height(24),

                  // REGISTER BUTTON
                  CustomButton(
                    label: "Register",
                    isLoading: isLoading,
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      if (selectedGender == null ||
                          selectedTrainingId == null ||
                          selectedBatchId == null) {
                        Fluttertoast.showToast(msg: "Semua data harus dipilih");
                        return;
                      }

                      setState(() => isLoading = true);

                      try {
                        final result = await AuthAPI.registerUser(
                          email: emailController.text.trim(),
                          name: nameController.text.trim(),
                          password: passwordController.text,
                          jenisKelamin: selectedGender!,
                          batchId: selectedBatchId!,
                          trainingId: selectedTrainingId!,
                          profilePhoto: "",
                        );

                        setState(() {
                          isLoading = false;
                          user = result;
                        });

                        // SIMPAN TOKEN
                        if (user.data?.token != null) {
                          await PreferenceHandler.saveToken(user.data!.token!);
                        }

                        // SAVE NAME & EMAIL
                        await PreferenceHandler.saveUsername(
                          nameController.text.trim(),
                        );
                        await PreferenceHandler.saveEmail(
                          emailController.text.trim(),
                        );

                        // SAVE TRAINING NAME
                        final selectedTrainingName =
                            trainings
                                .firstWhere((t) => t.id == selectedTrainingId)
                                .title ??
                            "";

                        // SAVE BATCH NAME
                        final selectedBatchName =
                            batches
                                .firstWhere((b) => b.id == selectedBatchId)
                                .batchKe ??
                            "";

                        // SAVE TO PREFERENCES
                        await PreferenceHandler.saveTraining(
                          selectedTrainingName,
                        );
                        await PreferenceHandler.saveBatch(selectedBatchName);

                        Fluttertoast.showToast(msg: "Register berhasil!");

                        Navigator.pushReplacementNamed(
                          context,
                          '/login_screen',
                        );
                      } catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                        setState(() => isLoading = false);
                      }
                    },
                  ),

                  height(20),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login_screen');
                    },
                    child: const Text(
                      "Sudah punya akun? Login",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ========================== UI SUPPORT WIDGETS ==========================

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: const BorderSide(color: Colors.black),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Container buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(255, 202, 216, 241),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
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

  SizedBox height(double value) => SizedBox(height: value);

  Widget buildTitle(String text) {
    return Row(children: [Text(text, style: const TextStyle(fontSize: 12))]);
  }
}
