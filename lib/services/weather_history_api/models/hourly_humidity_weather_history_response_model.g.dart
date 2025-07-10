// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hourly_humidity_weather_history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HourlyHumidityWeatherHistoryResponseModel
    _$HourlyHumidityWeatherHistoryResponseModelFromJson(
            Map<String, dynamic> json) =>
        HourlyHumidityWeatherHistoryResponseModel(
          hourly: json['hourly'] == null
              ? null
              : HourlyHumidityModel.fromJson(
                  json['hourly'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$HourlyHumidityWeatherHistoryResponseModelToJson(
        HourlyHumidityWeatherHistoryResponseModel instance) =>
    <String, dynamic>{
      'hourly': instance.hourly?.toJson(),
    };
