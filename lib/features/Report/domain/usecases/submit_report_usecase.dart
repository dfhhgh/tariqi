import '../entities/report_entity.dart';
import '../repository/report_repository.dart';

class SubmitReportUseCase {
  final ReportRepository repository;

  SubmitReportUseCase(this.repository);

  Future<void> call(ReportEntity report) {
    return repository.submitReport(report);
  }
}
