// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'package:agro_vision/services/gemini_service/models/fertilization_recommendation_model.dart';
import 'package:agro_vision/services/gemini_service/models/growing_condition_recommendation_model.dart';
import 'package:agro_vision/services/gemini_service/models/harvesting_recommendation_model.dart';
import 'package:agro_vision/services/gemini_service/models/pest_management_recommendation_model.dart';

part 'recommendations_for_crop_response_model.g.dart';

@JsonSerializable()
/// Model representing AI-generated agricultural recommendations for a specific crop.
class RecommendationsForCropResponseModel {
  /// Document ID (useful when stored in Firestore or similar DB).
  String id;

  /// The ID of the user who requested or owns this recommendation.
  String userId;

  /// The name of the crop (e.g., "Tomato", "Wheat").
  final String crop_name;

  /// Recommended growing conditions for the crop.
  final GrowingConditionRecommendationModel growing_conditions;

  /// A list of helpful tips for planting this crop.
  final List<String> planting_tips;

  /// Pest management suggestions including pests and recommended pesticides.
  final PestManagementRecommendationModel pest_management;

  /// Fertilizer-related guidance like type and frequency of application.
  final FertilizationRecommendationModel fertilization;

  /// Recommendations on when and how to harvest the crop.
  final HarvestingRecommendationModel harvesting;

  /// Optional language code to localize the recommendation (e.g., "en", "hi").
  String? languageCode;

  /// Constructor for [RecommendationsForCropResponseModel].
  RecommendationsForCropResponseModel({
    this.id = "",
    this.userId = "",
    required this.crop_name,
    required this.growing_conditions,
    required this.planting_tips,
    required this.pest_management,
    required this.fertilization,
    required this.harvesting,
    this.languageCode,
  });

  /// Creates an instance of [RecommendationsForCropResponseModel] from a JSON object.
  factory RecommendationsForCropResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsForCropResponseModelFromJson(json);

  /// Converts this [RecommendationsForCropResponseModel] instance to a JSON object.
  Map<String, dynamic> toJson() =>
      _$RecommendationsForCropResponseModelToJson(this);

  /// Returns a copy of the current instance with optional new values.
  RecommendationsForCropResponseModel copyWith({
    String? id,
    String? userId,
    String? crop_name,
    GrowingConditionRecommendationModel? growing_conditions,
    List<String>? planting_tips,
    PestManagementRecommendationModel? pest_management,
    FertilizationRecommendationModel? fertilization,
    HarvestingRecommendationModel? harvesting,
    String? languageCode,
  }) {
    return RecommendationsForCropResponseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      crop_name: crop_name ?? this.crop_name,
      growing_conditions: growing_conditions ?? this.growing_conditions,
      planting_tips: planting_tips ?? this.planting_tips,
      pest_management: pest_management ?? this.pest_management,
      fertilization: fertilization ?? this.fertilization,
      harvesting: harvesting ?? this.harvesting,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
