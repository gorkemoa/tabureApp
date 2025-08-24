// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  id: json['id'] as String,
  matchId: json['matchId'] as String,
  senderId: json['senderId'] as String,
  content: json['content'] as String,
  type: $enumDecode(_$MessageTypeEnumMap, json['type']),
  sentAt: DateTime.parse(json['sentAt'] as String),
  isRead: json['isRead'] as bool? ?? false,
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'id': instance.id,
  'matchId': instance.matchId,
  'senderId': instance.senderId,
  'content': instance.content,
  'type': _$MessageTypeEnumMap[instance.type]!,
  'sentAt': instance.sentAt.toIso8601String(),
  'isRead': instance.isRead,
};

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.link: 'link',
};
