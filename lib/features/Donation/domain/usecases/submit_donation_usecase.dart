import 'package:flutter_application_1/features/Donation/domain/entities/donation_entity.dart';
import 'package:flutter_application_1/features/Donation/domain/repositery/donation_repository.dart';

class SubmitDonationUseCase {
  final DonationRepository repository;

  SubmitDonationUseCase(this.repository);

  Future<void> call(DonationEntity donation) {
    return repository.submitDonation(donation);
  }
}
