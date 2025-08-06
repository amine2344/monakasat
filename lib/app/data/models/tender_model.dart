import 'package:cloud_firestore/cloud_firestore.dart';

class TenderModel {
  final String id;
  final String title;
  final String category;
  final String wilaya;
  final String date;
  final String announcer;
  final bool isRestricted;

  TenderModel({
    required this.id,
    required this.title,
    required this.category,
    required this.wilaya,
    required this.date,
    required this.announcer,
    required this.isRestricted,
  });

  factory TenderModel.fromJson(Map<String, dynamic> json) {
    return TenderModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      wilaya: json['wilaya'] ?? '',
      date: json['date'] ?? '',
      announcer: json['announcer'] ?? '',
      isRestricted: json['isRestricted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'wilaya': wilaya,
      'date': date,
      'announcer': announcer,
      'isRestricted': isRestricted,
    };
  }
}
