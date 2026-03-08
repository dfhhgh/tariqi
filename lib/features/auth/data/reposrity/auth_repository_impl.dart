import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRepositoryImpl(
    this.firebaseAuth, {
    FirebaseFirestore? firestore,
  }) : firestore = firestore ?? FirebaseFirestore.instance;

  // ================= LOGIN =================

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ================= REGISTER =================

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;

    if (user == null) {
      throw Exception("User creation failed");
    }

    final uid = user.uid;

    await firestore.collection("users").doc(uid).set({
      "name": name,
      "email": email,
      "uid": uid,
      "location": null,
      "registrationDate": FieldValue.serverTimestamp(),
    });
  }

  // ================= Reset Password =================

  @override
  Future<void> resetPassword({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }
}
