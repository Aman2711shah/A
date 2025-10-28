import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  const UserProfile({
    required this.uid,
    required this.email,
    this.name,
    this.phone,
    this.profileImage,
    this.companyName,
    this.designation,
    this.country,
    this.createdAt,
    this.updatedAt,
  });

  final String uid;
  final String email;
  final String? name;
  final String? phone;
  final String? profileImage;
  final String? companyName;
  final String? designation;
  final String? country;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      uid: data['uid'] as String,
      email: data['email'] as String? ?? '',
      name: data['name'] as String?,
      phone: data['phone'] as String?,
      profileImage: data['profileImage'] as String?,
      companyName: data['companyName'] as String?,
      designation: data['designation'] as String?,
      country: data['country'] as String?,
      createdAt: _toDateTime(data['createdAt']),
      updatedAt: _toDateTime(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (profileImage != null) 'profileImage': profileImage,
      if (companyName != null) 'companyName': companyName,
      if (designation != null) 'designation': designation,
      if (country != null) 'country': country,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  UserProfile copyWith({
    String? uid,
    String? email,
    String? name,
    String? phone,
    String? profileImage,
    String? companyName,
    String? designation,
    String? country,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      companyName: companyName ?? this.companyName,
      designation: designation ?? this.designation,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.uid == uid &&
        other.email == email &&
        other.name == name &&
        other.phone == phone &&
        other.profileImage == profileImage &&
        other.companyName == companyName &&
        other.designation == designation &&
        other.country == country;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        profileImage.hashCode ^
        companyName.hashCode ^
        designation.hashCode ^
        country.hashCode;
  }
}
