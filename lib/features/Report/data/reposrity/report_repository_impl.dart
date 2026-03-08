import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repository/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final FirebaseFirestore firestore;

  ReportRepositoryImpl({
    required this.firestore,
  });

  /// إرسال البلاغ
  @override
  Future<void> submitReport(ReportEntity report) async {
    await firestore.collection("reports").add({
      "userId": report.userId,

      "governorate": report.governorate,
      "city": report.city,
      "street": report.street,
      "coordinates": report.coordinates,
      "details": report.details,

      /// رابط الصورة من Cloudinary
      "image": report.image,

      "dateTime": report.dateTime,

      /// حالة البلاغ
      "status": "قيد المراجعة",

      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// جلب بلاغات المستخدم
  @override
  Stream<List<ReportEntity>> getUserReports(String userId) {
    return firestore
        .collection("reports")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map<ReportEntity>((doc) {
        final data = doc.data();
        final timestamp = data['createdAt'] as Timestamp;
        return ReportEntity(
          id: doc.id,
          userId: data["userId"] ?? "",
          governorate: data["governorate"] ?? "",
          city: data["city"] ?? "",
          street: data["street"] ?? "",
          coordinates: data["coordinates"] ?? "",
          details: data["details"] ?? "",
          image: data["image"] ?? "",
          dateTime:
              DateFormat('yyyy/MM/dd - hh:mm a').format(timestamp.toDate()),
          status: data["status"] ?? "قيد المراجعة",
        );
      }).toList();
    });
  }
}
