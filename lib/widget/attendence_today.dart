import 'package:attendance_project/widget/attendence_item.dart';
import 'package:flutter/material.dart';

class AttendanceTodayCard extends StatelessWidget {
  const AttendanceTodayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: const [
              Icon(Icons.people_alt_outlined, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text(
                "Attendance Today",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: const [
              Expanded(
                child: AttendanceItemCard(
                  label: "Check-in",
                  time: "08:15:23",
                  icon: Icons.login,
                  bgColor: Color(0xFFE8F5E9),
                  iconColor: Colors.green,
                  textColor: Color(0xFF1B5E20),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: AttendanceItemCard(
                  label: "Check-out",
                  time: "16:45:12",
                  icon: Icons.logout,
                  bgColor: Color(0xFFE3F2FD),
                  iconColor: Colors.blue,
                  textColor: Color(0xFF0D47A1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
