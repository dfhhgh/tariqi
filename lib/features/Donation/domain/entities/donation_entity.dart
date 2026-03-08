class DonationEntity {
  final String userId;
  final String method;
  final String amount;
  final String receiptImage;
  final DateTime createdAt;

  DonationEntity({
    required this.userId,
    required this.method,
    required this.amount,
    required this.receiptImage,
    required this.createdAt,
  });
}
