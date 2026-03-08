import 'package:flutter_application_1/features/notifications/domain/entities/NotificationEntity.dart';

abstract class NotificationRepository {
  Future<void> sendNotification(NotificationEntity notification);

  Stream<List<NotificationEntity>> getUserNotifications(String userId);

  Future<void> markAsRead(String notificationId);
}
