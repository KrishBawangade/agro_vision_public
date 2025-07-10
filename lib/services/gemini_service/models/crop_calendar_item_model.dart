// ignore_for_file: public_member_api_docs, sort_constructors_first

// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'crop_calendar_item_model.g.dart';

@JsonSerializable()
/// Model representing a single stage in the crop calendar.
class CropCalendarItemModel {
  /// Name of the crop growth stage (e.g., Germination, Flowering).
  final String stage;

  /// Short description of the stage, usually localized.
  final String stage_description;

  /// Start date of the stage (format: dd-MM-yyyy).
  final String start_date;

  /// End date of the stage (format: dd-MM-yyyy).
  final String end_date;

  /// Optional color represented in hex format (used for UI visualization).
  String? colorHexString;

  CropCalendarItemModel({
    required this.stage,
    required this.stage_description,
    required this.start_date,
    required this.end_date,
    this.colorHexString,
  });

  /// Creates an instance from JSON data.
  factory CropCalendarItemModel.fromJson(Map<String, dynamic> json) =>
      _$CropCalendarItemModelFromJson(json);

  /// Converts this instance to JSON.
  Map<String, dynamic> toJson() => _$CropCalendarItemModelToJson(this);

  /// Creates a copy of this model with updated fields.
  CropCalendarItemModel copyWith({
    String? stage,
    String? stage_description,
    String? start_date,
    String? end_date,
    String? colorHexString,
  }) {
    return CropCalendarItemModel(
      stage: stage ?? this.stage,
      stage_description: stage_description ?? this.stage_description,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      colorHexString: colorHexString ?? this.colorHexString,
    );
  }
}
