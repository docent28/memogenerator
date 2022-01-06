import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:memogenerator/data/models/position.dart';

part 'text_with_position.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TextWithPosition extends Equatable {
  final String id;
  final String text;
  final Position position;
  final double fontSize;
  final Color color;

  TextWithPosition({
    required this.id,
    required this.text,
    required this.position,
    required this.fontSize,
    required this.color,
  });

  factory TextWithPosition.fromJson(final Map<String, dynamic> json) =>
      _$TextWithPositionFromJson(json);

  Map<String, dynamic> toJson() => _$TextWithPositionToJson(this);

  @override
  List<Object?> get props => [id, text, position, fontSize, color];
}
