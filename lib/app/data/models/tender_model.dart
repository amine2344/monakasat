import 'package:cloud_firestore/cloud_firestore.dart';

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
  final String stage;
  final String? documentName;
  final String? documentUrl;
  final String? category;
  final String? wilaya;
  final List<Map<String, dynamic>>? offers;

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
    required this.stage,
    this.documentName,
    this.documentUrl,
    this.category,
    this.wilaya,
    this.offers,
  });

  factory TenderModel.fromJson(Map<String, dynamic> json, String id) {
    return TenderModel(
      id: id,
      userId: json['userId'] ?? '',
      projectName: json['projectName'] ?? '',
      serviceType: json['serviceType'] ?? '',
      requirements: json['requirements'] ?? '',
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      legalRequirements: json['legalRequirements'] ?? '',
      startDate: (json['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (json['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      stage: json['stage'] ?? 'announced',
      documentName: json['documentName'],
      documentUrl: json['documentUrl'],
      category: json['category'],
      wilaya: json['wilaya'],
      offers: (json['offers'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'projectName': projectName,
      'serviceType': serviceType,
      'requirements': requirements,
      'budget': budget,
      'legalRequirements': legalRequirements,
      'startDate': startDate,
      'endDate': endDate,
      'createdAt': createdAt,
      'stage': stage,
      'documentName': documentName,
      'documentUrl': documentUrl,
      'category': category,
      'wilaya': wilaya,
      'offers': offers,
    };
  }
}
