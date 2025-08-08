class TenderModel {
  final String id;
  final String userId;
  final String projectName;
  final String serviceType;
  final String requirements;
  final double budget;
  final String legalRequirements;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final String? documentName;
  final String stage;
  final String? wilaya;
  final String? announcer;

  TenderModel({
    required this.id,
    required this.userId,
    required this.projectName,
    required this.serviceType,
    required this.requirements,
    required this.budget,
    required this.legalRequirements,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    this.documentName,
    required this.stage,
    this.wilaya,
    this.announcer,
  });

  factory TenderModel.fromJson(Map<String, dynamic> json, String id) {
    return TenderModel(
      id: id,
      userId: json['userId'] ?? '',
      projectName: json['projectName'] ?? '',
      serviceType: json['serviceType'] ?? '',
      requirements: json['requirements'] ?? '',
      budget: (json['budget'] ?? 0.0).toDouble(),
      legalRequirements: json['legalRequirements'] ?? '',
      startDate: DateTime.parse(
        json['startDate']?.toDate().toString() ?? DateTime.now().toString(),
      ),
      endDate: DateTime.parse(
        json['endDate']?.toDate().toString() ?? DateTime.now().toString(),
      ),
      createdAt: DateTime.parse(
        json['createdAt']?.toDate().toString() ?? DateTime.now().toString(),
      ),
      documentName: json['documentName'],
      stage: json['stage'] ?? 'planning',
      wilaya: json['wilaya'],
      announcer: json['announcer'],
    );
  }
}
