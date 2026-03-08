import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Report/domain/entities/report_entity.dart';
import 'package:intl/intl.dart';

class ReportDetailsScreen extends StatelessWidget {
  final ReportEntity report;

  const ReportDetailsScreen({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
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
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),

              const SizedBox(height: 24),

              /// الكارت الرئيسي
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
                    const Text(
                      'صورة للطريق',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// صورة البلاغ
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        report.image,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'معلومات البلاغ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildInfoRow('المحافظة:', report.governorate),
                    _buildInfoRow('الإحداثيات:', report.coordinates),
                    _buildInfoRow('اسم الشارع:', report.street),
                    _buildInfoRow('المدينة:', report.city),
                    _buildInfoRow('الوصف:', report.details),

                    const SizedBox(height: 16),

                    /// الحالة
                    Text(
                      report.status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFFFD03A),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildInfoRow(
                      'تاريخ البلاغ:',
                      report.dateTime,
                    ),
                    _buildInfoRow('رقم البلاغ:', report.id.substring(0, 8)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
