import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String? phone;
  final String fullName;
  final String? profileImageUrl;
  final bool emailVerified;
  final bool phoneVerified;
  final bool profileCompleted;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    this.phone,
    required this.fullName,
    this.profileImageUrl,
    required this.emailVerified,
    required this.phoneVerified,
    required this.profileCompleted,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        fullName,
        profileImageUrl,
        emailVerified,
        phoneVerified,
        profileCompleted,
        createdAt,
      ];
}