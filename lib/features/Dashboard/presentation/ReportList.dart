import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Dashboard/presentation/report_details_screen.dart';
import 'package:flutter_application_1/features/Dashboard/domain/usecases/get_user_reports_usecase.dart';
import 'package:flutter_application_1/features/Dashboard/widgets/ReportCard.dart';
import 'package:flutter_application_1/features/Report/data/reposrity/report_repository_impl.dart';
import 'package:flutter_application_1/features/Report/domain/entities/report_entity.dart';

class ReportsList extends StatelessWidget {
  const ReportsList({super.key});

  /// تحويل الحالة إلى نص عربي
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
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository =
        ReportRepositoryImpl(firestore: FirebaseFirestore.instance);

    final usecase = GetUserReportsUseCase(repository);

    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<List<ReportEntity>>(
      stream: usecase(userId),
      builder: (context, snapshot) {
        /// loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        /// no data
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "لا يوجد بلاغات",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        final reports = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 40,
          ),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];

            /// تحويل الحالة
            final statusTitle = getStatusTitle(report.status);
            final statusColor = getStatusColor(report.status);

            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReportDetailsScreen(report: report),
                      ),
                    );
                  },
                  child: ReportCard(
                    title: statusTitle,
                    titleColor: statusColor,
                    imageUrl: report.image,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      },
    );
  }
}
