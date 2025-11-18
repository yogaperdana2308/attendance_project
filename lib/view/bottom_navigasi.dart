// import 'package:flutter/material.dart';

// class BottomNavigasi extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const BottomNavigasi({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: onTap,
//       selectedItemColor: const Color(0xFF0A3D91),
//       unselectedItemColor: Colors.grey,
//       showUnselectedLabels: true,
//       type: BottomNavigationBarType.fixed,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.qr_code_scanner),
//           label: "Scan",
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.calendar_today),
//           label: "Kehadiran",
//         ),
//         BottomNavigationBarItem(icon: Icon(Icons.map), label: "Maps"),
//       ],
//     );
//   }
// }
