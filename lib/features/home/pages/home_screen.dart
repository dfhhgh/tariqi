import 'package:flutter/material.dart';

void main() => runApp(const MyReportApp());

class MyReportApp extends StatelessWidget {
  const MyReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[50], // خلفية فاتحة كما في الصورة
        body: const ReportsList(),
        bottomNavigationBar: const CustomBottomNav(),
      ),
    );
  }
}

class ReportsList extends StatelessWidget {
  const ReportsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
      children: const [
        // البطاقة الأولى: قيد المراجعة
        ReportCard(
          title: "قيد المراجعة",
          titleColor: Colors.orange,
          imagePath: 'assets/street_image.png', // استبدله بمسار الصورة لديك
        ),
        SizedBox(height: 20),
        // البطاقة الثانية: تم الإصلاح
        ReportCard(
          title: "تم الإصلاح",
          titleColor: Colors.green,
          imagePath: 'assets/street_image.png',
        ),
      ],
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String imagePath;

  const ReportCard({
    super.key,
    required this.title,
    required this.titleColor,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              'https://via.placeholder.com/400x200', // رابط تجريبي للصورة
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      currentIndex: 2, // تحديد لوحة المعلومات كعنصر نشط
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الحساب'),
        BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'الكاميرا'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'لوحة المعلومات'),
      ],
    );
  }
}