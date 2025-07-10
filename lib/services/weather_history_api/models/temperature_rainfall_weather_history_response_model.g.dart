// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temperature_rainfall_weather_history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemperatureRainfallWeatherHistoryResponseModel
    _$TemperatureRainfallWeatherHistoryResponseModelFromJson(
            Map<String, dynamic> json) =>
        TemperatureRainfallWeatherHistoryResponseModel(
          daily: json['daily'] == null
              ? null
              : DailyTemperatureRainfallHistoryModel.fromJson(
                  json['daily'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$TemperatureRainfallWeatherHistoryResponseModelToJson(
        TemperatureRainfallWeatherHistoryResponseModel instance) =>
    <String, dynamic>{
      'daily': instance.daily?.toJson(),
    };
