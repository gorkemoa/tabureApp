// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  location: json['location'] as String,
  city: json['city'] as String,
  date: DateTime.parse(json['date'] as String),
  category: json['category'] as String,
  participantIds: (json['participantIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  organizer: json['organizer'] as String,
  imageUrl: json['imageUrl'] as String?,
  maxParticipants: (json['maxParticipants'] as num?)?.toInt() ?? 100,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'location': instance.location,
  'city': instance.city,
  'date': instance.date.toIso8601String(),
  'category': instance.category,
  'participantIds': instance.participantIds,
  'organizer': instance.organizer,
  'imageUrl': instance.imageUrl,
  'maxParticipants': instance.maxParticipants,
  'isActive': instance.isActive,
};
