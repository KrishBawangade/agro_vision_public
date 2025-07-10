// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_condition_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherConditionModel _$WeatherConditionModelFromJson(
        Map<String, dynamic> json) =>
    WeatherConditionModel(
      text: json['text'] as String? ?? "",
      icon: json['icon'] as String? ?? "",
      code: (json['code'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$WeatherConditionModelToJson(
        WeatherConditionModel instance) =>
    <String, dynamic>{
      'text': instance.text,
      'icon': instance.icon,
      'code': instance.code,
    };
