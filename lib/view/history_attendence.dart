import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryAttendenceScreen extends StatelessWidget {
  HistoryAttendenceScreen({super.key});

  final List<Map<String, dynamic>> rekapList = [
    {
      "tanggal": "2024, 11, 18",
      "hari": "Senin",
      "status": "Hadir",
      "masuk": "08:15:23",
      "keluar": "16:45:12",
    },
    {
      "tanggal": "2024, 11, 17",
      "hari": "Minggu",
      "status": "Libur",
      "masuk": "-",
      "keluar": "-",
    },
    {
      "tanggal": "2024, 11, 16",
      "hari": "Sabtu",
      "status": "Hadir",
      "masuk": "08:20:15",
      "keluar": "16:50:30",
    },
    {
      "tanggal": "2024, 11, 15",
      "hari": "Jumat",
      "status": "Hadir",
      "masuk": "08:10:45",
      "keluar": "16:40:20",
    },
  ];

  // String formatTanggal(DateTime date) {
  //   return DateFormat("dd MMM yyyy", "id_ID").format(date);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Rekap Kehadiran",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Rekapan Absen Harian",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // List Rekapan
              Column(
                children: rekapList.map((data) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _rekapItem(
                      // tanggal: formatTanggal(data["tanggal"]),
                      tanggal: data["tanggal"],
                      hari: data["hari"],
                      status: data["status"],
                      masuk: data["masuk"],
                      keluar: data["keluar"],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------
  // Item Card
  // -------------------------------
  Widget _rekapItem({
    required String tanggal,
    required String hari,
    required String status,
    required String masuk,
    required String keluar,
  }) {
    Color statusColor = status == "Hadir"
        ? Colors.green.shade100
        : Colors.grey.shade200;

    Color statusTextColor =
        status == "Hadir" ? Colors.green.shade700 : Colors.grey.shade600;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
          // Tanggal + Status
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 16),

          // Jam Masuk/Keluar
          Row(
            children: [
              const Icon(Icons.login, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              const Text(
                "Masuk:",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(width: 6),
              Text(
                masuk,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(width: 16),

              const Icon(Icons.logout, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              const Text(
                "Keluar:",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(width: 6),
              Text(
                keluar,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
