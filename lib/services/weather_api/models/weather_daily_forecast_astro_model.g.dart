// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_daily_forecast_astro_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherDailyForecastAstroModel _$WeatherDailyForecastAstroModelFromJson(
        Map<String, dynamic> json) =>
    WeatherDailyForecastAstroModel(
      sunrise: json['sunrise'] as String? ?? "",
      sunset: json['sunset'] as String? ?? "",
      moonrise: json['moonrise'] as String? ?? "",
      moonset: json['moonset'] as String? ?? "",
    );

Map<String, dynamic> _$WeatherDailyForecastAstroModelToJson(
        WeatherDailyForecastAstroModel instance) =>
    <String, dynamic>{
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'moonrise': instance.moonrise,
      'moonset': instance.moonset,
    };
