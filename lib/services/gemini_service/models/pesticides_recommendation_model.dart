
import 'package:json_annotation/json_annotation.dart';

part 'pesticides_recommendation_model.g.dart';

@JsonSerializable()
/// Model representing a single pesticide recommendation.
class PesticidesRecommendationModel {
  /// The name of the pesticide 
  /// (e.g., "Neem oil", "Spinosad").
  final String name;

  /// Instructions on how to use the pesticide effectively 
  /// (e.g., "Apply in the evening to control aphids").
  final String usage;

  /// Constructor for [PesticidesRecommendationModel].
  PesticidesRecommendationModel({
    required this.name,
    required this.usage,
  });

  /// Creates an instance of [PesticidesRecommendationModel] from a JSON object.
  factory PesticidesRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$PesticidesRecommendationModelFromJson(json);

  /// Converts this [PesticidesRecommendationModel] instance to a JSON object.
  Map<String, dynamic> toJson() => _$PesticidesRecommendationModelToJson(this);
}
