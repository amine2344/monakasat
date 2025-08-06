class OfferModel {
  final String id;
  final String tenderId;
  final String contractorId;
  final double financialOffer;
  final String technicalOffer;
  final String duration;
  final String documentUrl;

  OfferModel({
    required this.id,
    required this.tenderId,
    required this.contractorId,
    required this.financialOffer,
    required this.technicalOffer,
    required this.duration,
    required this.documentUrl,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] ?? '',
      tenderId: json['tenderId'] ?? '',
      contractorId: json['contractorId'] ?? '',
      financialOffer: json['financialOffer']?.toDouble() ?? 0.0,
      technicalOffer: json['technicalOffer'] ?? '',
      duration: json['duration'] ?? '',
      documentUrl: json['documentUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenderId': tenderId,
      'contractorId': contractorId,
      'financialOffer': financialOffer,
      'technicalOffer': technicalOffer,
      'duration': duration,
      'documentUrl': documentUrl,
    };
  }
}
