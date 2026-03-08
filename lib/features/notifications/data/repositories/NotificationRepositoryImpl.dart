import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/features/notifications/data/models/NotificationModel.dart';
import 'package:flutter_application_1/features/notifications/domain/entities/NotificationEntity.dart';
import 'package:flutter_application_1/features/notifications/domain/repositories/NotificationRepository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseFirestore firestore;

  NotificationRepositoryImpl(this.firestore);

  @override
  Future<void> sendNotification(NotificationEntity notification) async {
    final model = NotificationModel(
      id: notification.id,
      userId: notification.userId,
      title: notification.title,
      message: notification.message,
      createdAt: notification.createdAt,
      isRead: notification.isRead,
    );

    await firestore.collection("notifications").add(model.toMap());
  }

  @override
  Stream<List<NotificationEntity>> getUserNotifications(String userId) {
    return firestore
        .collection("notifications")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationModel.fromFirestore(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await firestore.collection("notifications").doc(notificationId).update({
      "isRead": true,
    });
  }
}
