import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetUserRoleUseCase {
  final FirebaseFirestore firestore;

  GetUserRoleUseCase(this.firestore);

  Future<String> call() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final doc = await firestore.collection("users").doc(user.uid).get();

    return doc.data()?["role"] ?? "user";
  }
}
