
import 'package:json_annotation/json_annotation.dart';

part 'fertilization_recommendation_model.g.dart';

@JsonSerializable()
/// Model representing fertilization recommendations for a crop.
class FertilizationRecommendationModel {
  /// Frequency of fertilizer application (e.g., "Apply in early spring and after harvest").
  final String frequency;

  /// Type of fertilizer to use (e.g., "High potassium and nitrogen fertilizers").
  final String type;

  /// Constructor for [FertilizationRecommendationModel].
  FertilizationRecommendationModel({
    required this.frequency,
    required this.type,
  });

  /// Creates an instance of [FertilizationRecommendationModel] from a JSON object.
  factory FertilizationRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$FertilizationRecommendationModelFromJson(json);

  /// Converts this [FertilizationRecommendationModel] instance to a JSON object.
  Map<String, dynamic> toJson() => _$FertilizationRecommendationModelToJson(this);
}
