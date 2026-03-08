import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Dashboard/presentation/ReportList.dart';
import 'package:flutter_application_1/features/camra/presentation/camera_screen.dart';

void main() => runApp(const MyReportApp());

class MyReportApp extends StatelessWidget {
  const MyReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

// ─── الشاشة الرئيسية التي تحتوي على الـ NavBar ──────────────────────────────

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // لوحة المعلومات هي الافتراضية

  // قائمة الشاشات بنفس ترتيب الـ NavBar
  final List<Widget> _screens = const [
    AccountScreen(), // index 0 - الحساب
    CameraScreen(), // index 1 - الكاميرا
    ReportsList(), // index 2 - لوحة المعلومات
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الحساب',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'الكاميرا',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'لوحة المعلومات',
          ),
        ],
      ),
    );
  }
}

// ─── شاشة التقارير ───────────────────────────────────────────────────────────

// ─── شاشة الحساب (placeholder) ───────────────────────────────────────────────

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'صفحة الحساب',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
