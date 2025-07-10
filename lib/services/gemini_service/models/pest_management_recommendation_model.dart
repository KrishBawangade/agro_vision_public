// ignore_for_file: non_constant_identifier_names

import 'package:agro_vision/services/gemini_service/models/pesticides_recommendation_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pest_management_recommendation_model.g.dart';

@JsonSerializable()
/// Model representing pest management recommendations for a crop.
class PestManagementRecommendationModel {
  /// A list of common pests affecting the crop 
  /// (e.g., ["Aphids", "Whiteflies", "Mealybugs"]).
  final List<String> common_pests;

  /// A list of pesticide recommendations for handling the common pests.
  final List<PesticidesRecommendationModel> pesticides;

  /// Constructor for [PestManagementRecommendationModel].
  PestManagementRecommendationModel({
    required this.common_pests,
    required this.pesticides,
  });

  /// Creates an instance of [PestManagementRecommendationModel] from a JSON object.
  factory PestManagementRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$PestManagementRecommendationModelFromJson(json);

  /// Converts this [PestManagementRecommendationModel] instance to a JSON object.
  Map<String, dynamic> toJson() => _$PestManagementRecommendationModelToJson(this);
}
