import 'package:json_annotation/json_annotation.dart';

part 'swipe.g.dart';

@JsonSerializable()
class Swipe {
  final String id;
  final String swiperId;
  final String swipedUserId;
  final SwipeAction action;
  final DateTime swipedAt;

  Swipe({
    required this.id,
    required this.swiperId,
    required this.swipedUserId,
    required this.action,
    required this.swipedAt,
  });

  factory Swipe.fromJson(Map<String, dynamic> json) => _$SwipeFromJson(json);
  Map<String, dynamic> toJson() => _$SwipeToJson(this);
}

enum SwipeAction {
  like,
  pass,
}
