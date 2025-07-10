// ignore_for_file: non_constant_identifier_names


import 'package:json_annotation/json_annotation.dart';

part 'growing_condition_recommendation_model.g.dart';

@JsonSerializable()
/// Model representing recommended growing conditions for a crop.
class GrowingConditionRecommendationModel {
  /// Type of soil suitable for the crop (e.g., "Well-drained loamy soil").
  final String soil_type;

  /// Watering instructions or frequency (e.g., "Keep soil moist; avoid waterlogging").
  final String watering;

  /// Constructor for [GrowingConditionRecommendationModel].
  GrowingConditionRecommendationModel({
    required this.soil_type,
    required this.watering,
  });

  /// Creates an instance of [GrowingConditionRecommendationModel] from a JSON object.
  factory GrowingConditionRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$GrowingConditionRecommendationModelFromJson(json);

  /// Converts this [GrowingConditionRecommendationModel] instance to a JSON object.
  Map<String, dynamic> toJson() => _$GrowingConditionRecommendationModelToJson(this);
}
