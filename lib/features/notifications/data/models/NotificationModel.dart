import 'package:flutter_application_1/features/notifications/domain/entities/NotificationEntity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.message,
    required super.createdAt,
    required super.isRead,
  });

  factory NotificationModel.fromFirestore(
      Map<String, dynamic> json, String id) {
    return NotificationModel(
      id: id,
      userId: json["userId"],
      title: json["title"],
      message: json["message"],
      createdAt: json["createdAt"],
      isRead: json["isRead"] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "title": title,
      "message": message,
      "createdAt": createdAt,
      "isRead": isRead,
    };
  }
}
