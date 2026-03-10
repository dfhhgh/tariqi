import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/admin/admin_report_details_screen.dart';
import 'package:flutter_application_1/features/Report/domain/entities/report_entity.dart';

class ControlPanelScreen extends StatelessWidget {
  const ControlPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          title: const Text("لوحة التحكم"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: "قيد المراجعة"),
              Tab(text: "تم الإصلاح"),
              Tab(text: "المرفوضة"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ReportsTab(status: "pending"),
            ReportsTab(status: "approved"),
            ReportsTab(status: "rejected"),
          ],
        ),
      ),
    );
  }
}

class ReportsTab extends StatelessWidget {
  final String status;

  const ReportsTab({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("reports")
          .where("status", isEqualTo: status)
          .snapshots(),
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

            final imageUrl = map["image"] ?? "";

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
                      builder: (_) => AdminReportDetailsScreen(report: report),
                    ),
                  );
                },
                child: _buildAdminCard(
                  context: context,
                  title: _getTitle(status),
                  titleColor: _getColor(status),
                  imageUrl: imageUrl,
                ),
              ),
            );
          },
        );
      },
    );
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
    required BuildContext context,
    required String title,
    required Color titleColor,
    required String imageUrl,
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
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: titleColor,
                  ),
            ),

            const SizedBox(height: 16),

            /// الصورة
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: imageUrl.isEmpty
                  ? Container(
                      width: 260,
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 40),
                    )
                  : Image.network(
                      imageUrl,
                      width: 260,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
