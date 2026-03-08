import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/admin/control_panel_screen.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/profile_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ControlPanelScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFF53B4E7),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            /// لوحة التحكم (نفس أيقونة المستخدم)
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "لوحة التحكم",
            ),

            /// الحساب
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "الحساب",
            ),
          ],
        ));
  }
}
