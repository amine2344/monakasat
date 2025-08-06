class TenderStageModel {
  final String id;
  final String tenderId;
  final String stageName;
  final String status;
  final Map<String, dynamic> details;
  final DateTime? startDate;
  final DateTime? endDate;

  TenderStageModel({
    required this.id,
    required this.tenderId,
    required this.stageName,
    required this.status,
    required this.details,
    this.startDate,
    this.endDate,
  });

  factory TenderStageModel.fromJson(Map<String, dynamic> json) {
    return TenderStageModel(
      id: json['id'] ?? '',
      tenderId: json['tenderId'] ?? '',
      stageName: json['stageName'] ?? '',
      status: json['status'] ?? 'pending',
      details: json['details'] ?? {},
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenderId': tenderId,
      'stageName': stageName,
      'status': status,
      'details': details,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
