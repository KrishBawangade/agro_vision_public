// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendations_for_crop_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendationsForCropResponseModel
    _$RecommendationsForCropResponseModelFromJson(Map<String, dynamic> json) =>
        RecommendationsForCropResponseModel(
          id: json['id'] as String? ?? "",
          userId: json['userId'] as String? ?? "",
          crop_name: json['crop_name'] as String,
          growing_conditions: GrowingConditionRecommendationModel.fromJson(
              json['growing_conditions'] as Map<String, dynamic>),
          planting_tips: (json['planting_tips'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
          pest_management: PestManagementRecommendationModel.fromJson(
              json['pest_management'] as Map<String, dynamic>),
          fertilization: FertilizationRecommendationModel.fromJson(
              json['fertilization'] as Map<String, dynamic>),
          harvesting: HarvestingRecommendationModel.fromJson(
              json['harvesting'] as Map<String, dynamic>),
          languageCode: json['languageCode'] as String?,
        );

Map<String, dynamic> _$RecommendationsForCropResponseModelToJson(
        RecommendationsForCropResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'crop_name': instance.crop_name,
      'growing_conditions': instance.growing_conditions.toJson(),
      'planting_tips': instance.planting_tips,
      'pest_management': instance.pest_management.toJson(),
      'fertilization': instance.fertilization.toJson(),
      'harvesting': instance.harvesting.toJson(),
      'languageCode': instance.languageCode,
    };
