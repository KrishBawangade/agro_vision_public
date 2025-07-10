// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_alerts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherAlertsModel _$WeatherAlertsModelFromJson(Map<String, dynamic> json) =>
    WeatherAlertsModel(
      (json['alert'] as List<dynamic>?)
          ?.map((e) => WeatherAlertModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeatherAlertsModelToJson(WeatherAlertsModel instance) =>
    <String, dynamic>{
      'alert': instance.alert?.map((e) => e.toJson()).toList(),
    };
