import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String phone;
  final String role;
  final String? profilePhotoUrl;
  final String? name;
  final String? prename;
  final String? wilaya;
  final String? activitySector;
  final String? companyName;
  final String? companyAddress;
  final String? companyPhone;
  final DateTime? createdAt;
  final String? deviceToken;
  final List<String>? favorites;
  final String? subscription;

  UserModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.role,
    this.profilePhotoUrl,
    this.name,
    this.prename,
    this.wilaya,
    this.activitySector,
    this.companyName,
    this.companyAddress,
    this.companyPhone,
    this.createdAt,
    this.deviceToken,
    this.favorites,
    this.subscription,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'contractor',
      profilePhotoUrl: json['profilePhotoUrl'],
      name: json['name'],
      prename: json['prename'],
      wilaya: json['wilaya'],
      activitySector: json['activitySector'],
      companyName: json['companyName'],
      companyAddress: json['companyAddress'],
      companyPhone: json['companyPhone'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp?)?.toDate()
          : json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      deviceToken: json['deviceToken'],
      favorites: json['favorites'] != null
          ? List<String>.from(json['favorites'])
          : null,
      subscription: json['subscription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'role': role,
      'profilePhotoUrl': profilePhotoUrl,
      'name': name,
      'prename': prename,
      'wilaya': wilaya,
      'activitySector': activitySector,
      'companyName': companyName,
      'companyAddress': companyAddress,
      'companyPhone': companyPhone,
      'createdAt': createdAt?.toIso8601String(),
      'deviceToken': deviceToken,
      'favorites': favorites,
      'subscription': subscription,
    };
  }

  String get userName => role == 'contractor'
      ? '${prename ?? ''} ${name ?? ''}'.trim()
      : companyName ?? '';
}
