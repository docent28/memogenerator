import 'package:json_annotation/json_annotation.dart';

part 'position.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Position {
  final double top;
  final double left;

  Position({required this.top, required this.left});

  factory Position.fromJson(final Map<String, dynamic> json) =>
      _$PositionFromJson(json);

  Map<String, dynamic> toJson() => _$PositionToJson(this);
}
