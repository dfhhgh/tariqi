import '../entities/report_entity.dart';

abstract class ReportRepository {
  Future<void> submitReport(ReportEntity report);
  Stream<List<ReportEntity>> getUserReports(String userId);
}
