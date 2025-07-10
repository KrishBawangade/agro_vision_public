// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_temperature_rainfall_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyTemperatureRainfallHistoryModel
    _$DailyTemperatureRainfallHistoryModelFromJson(Map<String, dynamic> json) =>
        DailyTemperatureRainfallHistoryModel(
          temperature_2m_mean: (json['temperature_2m_mean'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toDouble())
              .toList(),
          rain_sum: (json['rain_sum'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toDouble())
              .toList(),
        );

Map<String, dynamic> _$DailyTemperatureRainfallHistoryModelToJson(
        DailyTemperatureRainfallHistoryModel instance) =>
    <String, dynamic>{
      'temperature_2m_mean': instance.temperature_2m_mean,
      'rain_sum': instance.rain_sum,
    };
