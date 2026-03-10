class ReportEntity {
  final String id;
  final String userId;

  final String governorate;
  final String city;
  final String street;
  final String coordinates;
  final String details;

  final String image;

  final String dateTime;
  final String status;

  ReportEntity({
    required this.id,
    required this.userId,
    required this.governorate,
    required this.city,
    required this.street,
    required this.coordinates,
    required this.details,
    required this.image,
    required this.dateTime,
    required this.status,
  });

  Future<ReportEntity> copyWith({required String status}) async {
    return ReportEntity(
      id: id,
      userId: userId,
      governorate: governorate,
      city: city,
      street: street,
      coordinates: coordinates,
      details: details,
      image: image,
      dateTime: dateTime,
      status: status,
    );
  }
}
