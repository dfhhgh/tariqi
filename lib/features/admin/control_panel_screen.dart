import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/admin/admin_report_details_screen.dart';
import 'package:flutter_application_1/features/Report/domain/entities/report_entity.dart';

class ControlPanelScreen extends StatelessWidget {
  const ControlPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("reports").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final reports = snapshot.data!.docs;

            if (reports.isEmpty) {
              return const Center(
                child: Text("لا يوجد بلاغات"),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final data = reports[index];

                final map = data.data() as Map<String, dynamic>;

                final status = map["status"] ?? "pending";

                final imageUrl = map["image"] ?? "";

                /// تحويل البيانات إلى Entity
                final report = ReportEntity(
                  id: data.id,
                  userId: map["userId"] ?? "",
                  governorate: map["governorate"] ?? "",
                  coordinates: map["coordinates"] ?? "",
                  city: map["city"] ?? "",
                  street: map["street"] ?? "",
                  details: map["details"] ?? "",
                  image: imageUrl,
                  status: status,
                  dateTime: map["dateTime"] ?? "",
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminReportDetailsScreen(
                            report: report,
                          ),
                        ),
                      );
                    },
                    child: _buildAdminCard(
                      title: _getTitle(status),
                      titleColor: _getColor(status),
                      imageUrl: imageUrl,
                      showClockButton: status != "pending",
                      onApprove: () {
                        _updateStatus(data.id, "approved");
                      },
                      onReject: () {
                        _updateStatus(data.id, "rejected");
                      },
                      onPending: () {
                        _updateStatus(data.id, "pending");
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// تحديث حالة البلاغ
  void _updateStatus(String reportId, String status) {
    FirebaseFirestore.instance.collection("reports").doc(reportId).update({
      "status": status,
    });
  }

  /// لون الحالة
  Color _getColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;

      case "rejected":
        return Colors.red;

      default:
        return const Color(0xFFFFD03A);
    }
  }

  /// عنوان الحالة
  String _getTitle(String status) {
    switch (status) {
      case "approved":
        return "تم الإصلاح";

      case "rejected":
        return "مرفوض";

      default:
        return "قيد المراجعة";
    }
  }

  /// كارت البلاغ
  Widget _buildAdminCard({
    required String title,
    required Color titleColor,
    required String imageUrl,
    required bool showClockButton,
    required VoidCallback onApprove,
    required VoidCallback onReject,
    VoidCallback? onPending,
  }) {
    return Center(
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            /// الحالة
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: "Cairo",
              ),
            ),

            const SizedBox(height: 16),

            /// صورة البلاغ
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: imageUrl.isEmpty
                  ? Container(
                      width: 260,
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 40,
                      ),
                    )
                  : Image.network(
                      imageUrl,
                      width: 260,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
            ),

            const SizedBox(height: 20),

            /// الأزرار
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// قبول
                _buildActionButton(
                  icon: Icons.check,
                  iconColor: const Color(0xFF4CAF50),
                  backgroundColor: const Color(0xFFC8E6C9),
                  onTap: onApprove,
                ),

                const SizedBox(width: 12),

                /// رفض
                _buildActionButton(
                  icon: Icons.close,
                  iconColor: const Color(0xFFF44336),
                  backgroundColor: const Color(0xFFFFCDD2),
                  onTap: onReject,
                ),

                /// إعادة للمراجعة
                if (showClockButton) ...[
                  const SizedBox(width: 12),
                  _buildActionButton(
                    icon: Icons.access_time_filled,
                    iconColor: const Color(0xFFFFB300),
                    backgroundColor: const Color(0xFFFFF9C4),
                    onTap: onPending ?? () {},
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// زر التحكم
  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 26,
        ),
      ),
    );
  }
}
