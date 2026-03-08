class NotificationEntity {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String createdAt;
  final bool isRead;

  NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });
}
