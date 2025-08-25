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
  final DateTime? updatedAt;
  final DateTime createdAt;
  final String stage;
  final String? featuredImageUrl;
  final String? documentName;
  final String? documentUrl;
  final String? category;
  final String? wilaya;
  final String? folderId;
  final List<Map<String, dynamic>>? offers;
  final String? announcer;

  TenderModel({
    required this.id,
    required this.userId,
    required this.projectName,
    required this.serviceType,
    required this.requirements,
    required this.budget,
    this.updatedAt,
    required this.legalRequirements,
    required this.startDate,
    required this.endDate,
    this.featuredImageUrl,
    required this.createdAt,
    required this.stage,
    this.documentName,
    this.documentUrl,
    this.category,
    this.wilaya,
    this.folderId,
    this.offers,
    this.announcer,
  });

  factory TenderModel.fromJson(Map<String, dynamic> json, String id) {
    return TenderModel(
      id: id,
      userId: json['userId'] ?? '',
      projectName: json['projectName'] ?? '',
      serviceType: json['serviceType'] ?? '',
      requirements: json['requirements'] ?? '',
      featuredImageUrl: json['featuredImageUrl'],
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      legalRequirements: json['legalRequirements'] ?? '',
      startDate: _convertToDateTime(json['startDate']),
      endDate: _convertToDateTime(json['endDate']),
      createdAt: _convertToDateTime(json['createdAt']),
      updatedAt: _convertToDateTime(json['updatedAt']),
      stage: json['stage'] ?? 'announced',
      documentName: json['documentName'],
      documentUrl: json['documentUrl'],
      category: json['category'],
      wilaya: json['wilaya'],
      folderId: json['folderId'],
      offers: (json['offers'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
      announcer: json['announcer'],
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
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'stage': stage,
      'documentName': documentName,
      'documentUrl': documentUrl,
      'category': category,
      'wilaya': wilaya,
      'folderId': folderId,
      'offers': offers,
      'featuredImageUrl': featuredImageUrl,
      'announcer': announcer,
    };
  }

  static DateTime _convertToDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
