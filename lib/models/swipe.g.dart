// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Swipe _$SwipeFromJson(Map<String, dynamic> json) => Swipe(
  id: json['id'] as String,
  swiperId: json['swiperId'] as String,
  swipedUserId: json['swipedUserId'] as String,
  action: $enumDecode(_$SwipeActionEnumMap, json['action']),
  swipedAt: DateTime.parse(json['swipedAt'] as String),
);

Map<String, dynamic> _$SwipeToJson(Swipe instance) => <String, dynamic>{
  'id': instance.id,
  'swiperId': instance.swiperId,
  'swipedUserId': instance.swipedUserId,
  'action': _$SwipeActionEnumMap[instance.action]!,
  'swipedAt': instance.swipedAt.toIso8601String(),
};

const _$SwipeActionEnumMap = {
  SwipeAction.like: 'like',
  SwipeAction.pass: 'pass',
};
