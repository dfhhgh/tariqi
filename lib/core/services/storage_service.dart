import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<String> uploadImage(File file, String reportId) async {
    final ref =
        FirebaseStorage.instance.ref().child("reports/$reportId/image.jpg");

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }
}
