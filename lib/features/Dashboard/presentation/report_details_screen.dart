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

  String getStatusTitle(String status) {
    switch (status) {
      case "approved":
        return "تم الإصلاح شكرا لتعاونك في توثيق حالة الشارع والمساهمة في تحسينه";
      case "rejected":
        return "تم رفض البلاغ نظرًا لعدم دقة المعلومات أو لكون الصورة المرفقة لا تعكس الحالة الواقعية للموقع";
      default:
        return "قيد المراجعة سيتم إبلاغك عند الانتهاء";
    }
  }

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

    return Directionality(
      textDirection: TextDirection.rtl, // كل النصوص عربية من اليمين
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // زر العودة
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

                // معلومات البلاغ
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "صورة للطريق",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: widget.report.image.isEmpty
                            ? Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              )
                            : Image.network(
                                widget.report.image,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "معلومات المشكلة",
                        textAlign: TextAlign.right,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "حالة الطريق:",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              statusTitle,
                              textAlign: TextAlign.right,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfo("تاريخ البلاغ:", widget.report.dateTime),
                      _buildInfo("رقم البلاغ:", widget.report.id.substring(0, 8)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // تعديل _buildInfo لتكسر النصوص الطويلة وتكون على اليمين
  Widget _buildInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title ",
            textAlign: TextAlign.right,
            softWrap: true,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}