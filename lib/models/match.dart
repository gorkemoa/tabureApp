import 'package:json_annotation/json_annotation.dart';

part 'match.g.dart';

@JsonSerializable()
class Match {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime matchedAt;
  final DateTime? lastMessageAt;
  final bool isActive;

  Match({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.matchedAt,
    this.lastMessageAt,
    this.isActive = true,
  });

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
  Map<String, dynamic> toJson() => _$MatchToJson(this);
}
