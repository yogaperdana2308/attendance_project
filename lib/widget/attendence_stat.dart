import 'package:attendance_project/widget/stat_item.dart';
import 'package:flutter/material.dart';

class AttendanceStatisticsCard extends StatelessWidget {
  const AttendanceStatisticsCard({
    super.key,
    required this.totalAbsen,
    required this.totalIzin,
  });

  final int totalAbsen;
  final int totalIzin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Attendance Statistics",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: StatItemCard(
                  icon: Icons.check_box,
                  iconColor: Colors.green,
                  bgColor: Color(0xFFE8F5E9),
                  value: totalAbsen.toString(),
                  label: "Total Hadir",
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatItemCard(
                  icon: Icons.calendar_month,
                  iconColor: Colors.orange,
                  bgColor: Color(0xFFFFF8E1),
                  value: totalIzin.toString(),
                  label: "Total Izin",
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatItemCard(
                  icon: Icons.cancel,
                  iconColor: Colors.red,
                  bgColor: Color(0xFFFFEBEE),
                  value: "0",
                  label: "Tidak Hadir",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
