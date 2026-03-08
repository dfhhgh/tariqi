import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Report/domain/entities/report_entity.dart';

class ReportDetailsScreen extends StatefulWidget {
  final ReportEntity report;

  const ReportDetailsScreen({
    super.key,
    required this.report,
  });

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  String userEmail = "";
  String userName = "";

  /// جلب بيانات صاحب البلاغ
  Future<void> getUserData() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.report.userId)
        .get();

    if (doc.exists) {
      final data = doc.data();

      setState(() {
        userEmail = data?["email"] ?? "";

        userName = data?["name"] ?? "";
      });
    }
  }

  /// تحويل الحالة
  String getStatusTitle(String status) {
    switch (status) {
      case "approved":
        return "تم الإصلاح";

      case "rejected":
        return "مرفوض";

      default:
        return "قيد المراجعة";
    }
  }

  /// لون الحالة
  Color getStatusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;

      case "rejected":
        return Colors.red;

      default:
        return const Color(0xFFFFD03A);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final statusTitle = getStatusTitle(widget.report.status);
    final statusColor = getStatusColor(widget.report.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// زر الرجوع
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFF55B3E6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// الكارت
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    /// عنوان الصورة
                    const Text(
                      "صورة للطريق",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// صورة البلاغ
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.report.image,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// عنوان المعلومات
                    const Text(
                      "معلومات المشكلة",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildInfo("الاسم:", userName),
                    _buildInfo("البريد الإلكتروني:", userEmail),
                    _buildInfo("المحافظة:", widget.report.governorate),
                    _buildInfo("الإحداثيات:", widget.report.coordinates),
                    _buildInfo("اسم الشارع:", widget.report.street),
                    _buildInfo("المدينة:", widget.report.city),
                    _buildInfo("وصف الموقع:", widget.report.details),

                    const SizedBox(height: 16),

                    /// الحالة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "حالة الطريق:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusTitle,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildInfo("تاريخ البلاغ:", widget.report.dateTime),

                    _buildInfo(
                      "رقم البلاغ:",
                      widget.report.id.substring(0, 8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// عنصر معلومات
  Widget _buildInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
