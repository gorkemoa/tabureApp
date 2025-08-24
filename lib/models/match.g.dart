// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
  id: json['id'] as String,
  user1Id: json['user1Id'] as String,
  user2Id: json['user2Id'] as String,
  matchedAt: DateTime.parse(json['matchedAt'] as String),
  lastMessageAt: json['lastMessageAt'] == null
      ? null
      : DateTime.parse(json['lastMessageAt'] as String),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
  'id': instance.id,
  'user1Id': instance.user1Id,
  'user2Id': instance.user2Id,
  'matchedAt': instance.matchedAt.toIso8601String(),
  'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
  'isActive': instance.isActive,
};
