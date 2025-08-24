// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  profession: json['profession'] as String,
  company: json['company'] as String,
  skills: (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
  lookingFor: json['lookingFor'] as String,
  profilePhotoUrl: json['profilePhotoUrl'] as String,
  city: json['city'] as String,
  experienceLevel: json['experienceLevel'] as String,
  linkedinProfile: json['linkedinProfile'] as String?,
  isVerified: json['isVerified'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastActive: json['lastActive'] == null
      ? null
      : DateTime.parse(json['lastActive'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'profession': instance.profession,
  'company': instance.company,
  'skills': instance.skills,
  'lookingFor': instance.lookingFor,
  'profilePhotoUrl': instance.profilePhotoUrl,
  'city': instance.city,
  'experienceLevel': instance.experienceLevel,
  'linkedinProfile': instance.linkedinProfile,
  'isVerified': instance.isVerified,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastActive': instance.lastActive?.toIso8601String(),
};
