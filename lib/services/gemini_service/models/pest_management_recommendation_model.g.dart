// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pest_management_recommendation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PestManagementRecommendationModel _$PestManagementRecommendationModelFromJson(
        Map<String, dynamic> json) =>
    PestManagementRecommendationModel(
      common_pests: (json['common_pests'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      pesticides: (json['pesticides'] as List<dynamic>)
          .map((e) =>
              PesticidesRecommendationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PestManagementRecommendationModelToJson(
        PestManagementRecommendationModel instance) =>
    <String, dynamic>{
      'common_pests': instance.common_pests,
      'pesticides': instance.pesticides.map((e) => e.toJson()).toList(),
    };
