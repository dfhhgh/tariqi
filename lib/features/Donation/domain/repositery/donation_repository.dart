import '../entities/donation_entity.dart';

import '../entities/donation_entity.dart';

abstract class DonationRepository {
  Future<void> submitDonation(DonationEntity donation);
}
