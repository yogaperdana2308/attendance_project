import 'package:attendance_project/view/checkin_screen.dart';
import 'package:attendance_project/view/dashboard_screen.dart';
import 'package:attendance_project/view/history_attendence.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardScreenAttendence(),
    HistoryAttendenceScreen(),
    TakeAttendenceScreen(),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: _pages[_currentIndex],

      // Bottom Navigation menggunakan google_nav_bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.white,
            ),
          ],
        ),
        child: SafeArea(
          child: GNav(
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            selectedIndex: _currentIndex,

            // Warna
            backgroundColor: Colors.white,
            color: Colors.blue,          // icon normal
            activeColor: Colors.blue,             // icon aktif
            tabBackgroundColor: Colors.blue.shade50,
            tabBorderRadius: 16,

            onTabChange: (index) {
              setState(() => _currentIndex = index);
            },

            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: "Home",
              ),

              GButton(
                icon: Icons.history_outlined,
                text: "History",
              ),
              
              GButton(
                icon: Icons.fact_check_outlined,
                text: "Kehadiran",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
