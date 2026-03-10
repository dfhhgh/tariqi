import 'package:flutter_application_1/features/notifications/domain/entities/NotificationEntity.dart';
import 'package:flutter_application_1/features/notifications/domain/repositories/NotificationRepository.dart';

class SendNotificationUseCase {
  final NotificationRepository repository;

  SendNotificationUseCase(this.repository);

  Future<void> call(NotificationEntity notification) {
    return repository.sendNotification(notification);
  }
}
