import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Dashboard/usecases/get_user_reports_usecase.dart';
import 'package:flutter_application_1/features/Report/data/reposrity/report_repository_impl.dart';
import 'package:flutter_application_1/features/Report/domain/entities/report_entity.dart';

class ReportsList extends StatelessWidget {
  const ReportsList({super.key});

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

            return Column(
              children: [
                ReportCard(
                  title: report.status,
                  titleColor: report.status == "تم الإصلاح"
                      ? Colors.green
                      : Colors.orange,
                  imageUrl: report.image,
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

class ReportCard extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String imageUrl;

  const ReportCard({
    super.key,
    required this.title,
    required this.titleColor,
    required this.imageUrl,
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
          /// title
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),

          const SizedBox(height: 20),

          /// image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
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
