import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/services/cloudinary_service.dart';
import 'package:flutter_application_1/features/Donation/domain/repositery/donation_repository.dart';
import '../../domain/entities/donation_entity.dart';

class DonationRepositoryImpl implements DonationRepository {
  final FirebaseFirestore firestore;
  final CloudinaryService cloudinary;

  DonationRepositoryImpl({
    required this.firestore,
    required this.cloudinary,
  });

  @override
  Future<void> submitDonation(DonationEntity donation) async {
    /// رفع صورة الإيصال إلى Cloudinary
    final imageUrl = await cloudinary.uploadImage(
      File(donation.receiptImage),
      preset: cloudinary.donationsPreset,
    );

    /// حفظ بيانات التبرع في Firestore
    await firestore.collection("donations").add({
      "userId": donation.userId,
      "method": donation.method,
      "amount": donation.amount,
      "receiptImage": imageUrl,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
