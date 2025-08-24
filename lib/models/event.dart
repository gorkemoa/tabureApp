import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final String city;
  final DateTime date;
  final String category;
  final List<String> participantIds;
  final String organizer;
  final String? imageUrl;
  final int maxParticipants;
  final bool isActive;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.city,
    required this.date,
    required this.category,
    required this.participantIds,
    required this.organizer,
    this.imageUrl,
    this.maxParticipants = 100,
    this.isActive = true,
  });

  bool get isFull => participantIds.length >= maxParticipants;
  
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
