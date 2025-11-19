import 'package:attendance_project/widget/time_box.dart';
import 'package:flutter/material.dart';

class CurrentTimeCard extends StatelessWidget {
  final String hour;
  final String minute;
  final String second;

  const CurrentTimeCard({
    super.key,
    required this.hour,
    required this.minute,
    required this.second,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7F5AF0), Color(0xFF9E7BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.access_time, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Current Time",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TimeBox(value: hour),
              Text(" : ", style: TextStyle(color: Colors.white, fontSize: 32)),
              TimeBox(value: minute),
              Text(" : ", style: TextStyle(color: Colors.white, fontSize: 32)),
              TimeBox(value: second),
            ],
          ),
        ],
      ),
    );
  }
}
