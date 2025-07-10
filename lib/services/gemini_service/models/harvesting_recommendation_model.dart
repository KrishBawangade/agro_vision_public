
import 'package:json_annotation/json_annotation.dart';

part 'harvesting_recommendation_model.g.dart';

@JsonSerializable()
/// Model representing harvesting recommendations for a crop.
class HarvestingRecommendationModel {
  /// The ideal time or condition for harvesting the crop 
  /// (e.g., "Harvest when fruits are fully ripe").
  final String timing;

  /// Storage instructions after harvesting 
  /// (e.g., "Store in a cool, dry place").
  final String storage;

  /// Constructor for [HarvestingRecommendationModel].
  HarvestingRecommendationModel({
    required this.timing,
    required this.storage,
  });

  /// Creates an instance of [HarvestingRecommendationModel] from a JSON object.
  factory HarvestingRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$HarvestingRecommendationModelFromJson(json);

  /// Converts this [HarvestingRecommendationModel] instance to a JSON object.
  Map<String, dynamic> toJson() => _$HarvestingRecommendationModelToJson(this);
}
