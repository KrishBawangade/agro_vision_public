// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'package:agro_vision/services/gemini_service/models/crop_calendar_item_model.dart';

part 'crop_calendar_response_model.g.dart';

@JsonSerializable()
/// Model representing the complete crop calendar for a specific farm plot.
class CropCalendarResponseModel {
  /// Unique identifier for the crop calendar entry (Firestore document ID).
  String id;

  /// ID of the user to whom this crop calendar belongs.
  String userId;

  /// ID of the associated farm plot.
  String farmPlotId;

  /// Name of the crop (e.g., Wheat, Rice).
  final String crop;

  /// List of crop calendar stages with respective durations and descriptions.
  final List<CropCalendarItemModel> crop_calendar;

  /// Optional language code (e.g., "en", "hi", "mr").
  String? languageCode;

  CropCalendarResponseModel({
    this.id = "",
    this.userId = "",
    this.farmPlotId = "",
    required this.crop,
    required this.crop_calendar,
    this.languageCode,
  });

  /// Creates a [CropCalendarResponseModel] from JSON.
  factory CropCalendarResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CropCalendarResponseModelFromJson(json);

  /// Converts the current model to JSON.
  Map<String, dynamic> toJson() => _$CropCalendarResponseModelToJson(this);

  /// Returns a copy of the model with updated values.
  CropCalendarResponseModel copyWith({
    String? id,
    String? userId,
    String? farmPlotId,
    String? crop,
    List<CropCalendarItemModel>? crop_calendar,
    String? languageCode,
  }) {
    return CropCalendarResponseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      farmPlotId: farmPlotId ?? this.farmPlotId,
      crop: crop ?? this.crop,
      crop_calendar: crop_calendar ?? this.crop_calendar,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
