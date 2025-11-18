import 'package:flutter/material.dart';

class WidgetCard extends StatefulWidget {
  const WidgetCard({super.key});

  @override
  State<WidgetCard> createState() => _WidgetCardState();
}

DateTime today = DateTime.now();

String getDayName(int weekday) {
  switch (weekday) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
    default:
      return "";
  }
}

class _WidgetCardState extends State<WidgetCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 75,
      decoration: BoxDecoration(
        color: const Color(0xFFFFB74D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getDayName(today.weekday), // HARI REALTIME
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            today.day.toString(), // TANGGAL REALTIME
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
