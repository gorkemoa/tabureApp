import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String profession;
  final String company;
  final List<String> skills;
  final String lookingFor; // iş ortağı, mentor, yatırımcı, freelance müşteri, iş fırsatı, sosyal bağlantı
  final String profilePhotoUrl;
  final String city;
  final String experienceLevel; // öğrenci, junior, senior, girişimci
  final String? linkedinProfile;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? lastActive;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profession,
    required this.company,
    required this.skills,
    required this.lookingFor,
    required this.profilePhotoUrl,
    required this.city,
    required this.experienceLevel,
    this.linkedinProfile,
    this.isVerified = false,
    required this.createdAt,
    this.lastActive,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? profession,
    String? company,
    List<String>? skills,
    String? lookingFor,
    String? profilePhotoUrl,
    String? city,
    String? experienceLevel,
    String? linkedinProfile,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profession: profession ?? this.profession,
      company: company ?? this.company,
      skills: skills ?? this.skills,
      lookingFor: lookingFor ?? this.lookingFor,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      city: city ?? this.city,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      linkedinProfile: linkedinProfile ?? this.linkedinProfile,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
