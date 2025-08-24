import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final String id;
  final String matchId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime sentAt;
  final bool isRead;

  Message({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.sentAt,
    this.isRead = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

enum MessageType {
  text,
  link,
}
