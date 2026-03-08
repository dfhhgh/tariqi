import 'package:flutter/material.dart';

class ReportsList extends StatelessWidget {
  const ReportsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
      children: const [
        ReportCard(
          title: "قيد المراجعة",
          titleColor: Colors.orange,
        ),
        SizedBox(height: 20),
        ReportCard(
          title: "تم الإصلاح",
          titleColor: Colors.green,
        ),
      ],
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final Color titleColor;

  const ReportCard({
    super.key,
    required this.title,
    required this.titleColor,
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
              'https://via.placeholder.com/400x200',
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
