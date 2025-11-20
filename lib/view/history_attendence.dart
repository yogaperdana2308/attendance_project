import 'package:attendance_project/models/attedance_history.dart';
import 'package:attendance_project/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryAttendenceScreen extends StatefulWidget {
  const HistoryAttendenceScreen({super.key});

  @override
  State<HistoryAttendenceScreen> createState() =>
      _HistoryAttendenceScreenState();
}

class _HistoryAttendenceScreenState extends State<HistoryAttendenceScreen> {
  List<AttendanceHistoryModel> historyList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final data = await TrainingAPI.getAttendanceHistory();
      setState(() {
        historyList = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print("Error load history: $e");
    }
  }

  String formatDate(String? date) {
    if (date == null) return "-";
    final DateTime dt = DateTime.parse(date);
    return DateFormat("dd MMM yyyy").format(dt);
  }

  String formatDay(String? date) {
    if (date == null) return "-";
    final DateTime dt = DateTime.parse(date);
    return DateFormat("EEEE", "id_ID").format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Riwayat Absensi",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  final item = historyList[index];
                  return _rekapItem(
                    tanggal: formatDate(item.attendanceDate),
                    hari: formatDay(item.attendanceDate),
                    lokasi: item.checkInAddress ?? '=',
                    status: item.status ?? "-",
                    masuk: item.checkInTime ?? "-",
                    keluar: item.checkOutTime ?? "-",
                  );
                },
              ),
            ),
    );
  }

  Widget _rekapItem({
    required String tanggal,
    required String lokasi,
    required String hari,
    required String status,
    required String masuk,
    required String keluar,
    // required String lokasi,
  }) {
    Color statusColor = status == "masuk"
        ? Colors.green.shade100
        : Colors.grey.shade200;

    Color statusTextColor = status == "masuk"
        ? Colors.green.shade700
        : Colors.grey.shade600;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tanggal,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    color: statusTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Text(
            hari,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          Text(
            lokasi,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.login, size: 18, color: Colors.green),
              SizedBox(width: 6),
              Text(
                "Masuk: $masuk",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.logout, size: 18, color: Colors.red),
              const SizedBox(width: 6),
              Text(
                "Keluar: $keluar",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
