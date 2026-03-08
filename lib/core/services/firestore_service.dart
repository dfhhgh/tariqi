import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTestReport() async {
    await _db.collection("reports").add({
      "description": "Test road defect",
      "status": "pending",
      "timestamp": FieldValue.serverTimestamp(),
    });
  }
}
