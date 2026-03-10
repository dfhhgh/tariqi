import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Dashboard/presentation/ReportList.dart';
import 'package:flutter_application_1/features/camra/presentation/camera_screen.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/profile_screen.dart';

void main() => runApp(const MyReportApp());

class MyReportApp extends StatelessWidget {
  const MyReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Almarai', // كل النصوص هتستخدم Almarai تلقائي
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2;

  final List<Widget> _screens = const [
    ProfileScreen(),
    CameraScreen(),
    ReportsList(),
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