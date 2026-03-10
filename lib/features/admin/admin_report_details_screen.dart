import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Report/domain/entities/report_entity.dart';

class AdminReportDetailsScreen extends StatefulWidget {
  final ReportEntity report;

  const AdminReportDetailsScreen({
    super.key,
    required this.report,
  });

  @override
  State<AdminReportDetailsScreen> createState() =>
      _AdminReportDetailsScreenState();
}

class _AdminReportDetailsScreenState extends State<AdminReportDetailsScreen> {
  String userEmail = "";
  String userName = "";
  
  get textDirectio => null;

  Future<void> getUserData() async {
    try {
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
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  Future<void> sendNotification(String status) async {
    String message = "";

    if (status == "approved") {
      message = "تم إصلاح البلاغ الخاص بك";
    } else if (status == "rejected") {
      message = "تم رفض البلاغ الخاص بك";
    } else {
      message = "تم إعادة البلاغ إلى قيد المراجعة";
    }

    await FirebaseFirestore.instance.collection("notifications").add({
      "userId": widget.report.userId,
      "title": "تحديث حالة البلاغ",
      "message": message,
      "reportId": widget.report.id,
      "createdAt": FieldValue.serverTimestamp(),
      "isRead": false,
    });
  }

  Future<void> updateStatus(String status) async {
    try {
      await FirebaseFirestore.instance
          .collection("reports")
          .doc(widget.report.id)
          .update({
        "status": status,
      });

      await sendNotification(status);

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error updating status: $e");
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
  @override
Widget build(BuildContext context) {
  final statusTitle = getStatusTitle(widget.report.status);
  final statusColor = getStatusColor(widget.report.status);

  return Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("تفاصيل البلاغ"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "صورة الطريق",
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
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 24),
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
              _buildInfo("الوصف:", widget.report.details),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "حالة الطريق: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      statusTitle,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    icon: Icons.check,
                    color: Colors.green,
                    onTap: () => updateStatus("approved"),
                  ),
                  const SizedBox(width: 20),
                  _buildActionButton(
                    icon: Icons.close,
                    color: Colors.red,
                    onTap: () => updateStatus("rejected"),
                  ),
                  const SizedBox(width: 20),
                  _buildActionButton(
                    icon: Icons.access_time,
                    color: Colors.orange,
                    onTap: () => updateStatus("pending"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            "$title ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}