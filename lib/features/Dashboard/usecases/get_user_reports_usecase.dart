import 'package:flutter_application_1/features/Report/domain/Entities/report_entity.dart'
    hide ReportEntity;
import 'package:flutter_application_1/features/Report/domain/entities/report_entity.dart';
import 'package:flutter_application_1/features/Report/domain/repository/report_repository.dart';

class GetUserReportsUseCase {
  final ReportRepository repository;

  GetUserReportsUseCase(this.repository);

  Stream<List<ReportEntity>> call(String userId) {
    return repository.getUserReports(userId);
  }
}
