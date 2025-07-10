// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_daily_forecast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherDailyForecastModel _$WeatherDailyForecastModelFromJson(
        Map<String, dynamic> json) =>
    WeatherDailyForecastModel(
      forecastday: (json['forecastday'] as List<dynamic>?)
          ?.map((e) =>
              WeatherForecastDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeatherDailyForecastModelToJson(
        WeatherDailyForecastModel instance) =>
    <String, dynamic>{
      'forecastday': instance.forecastday?.map((e) => e.toJson()).toList(),
    };
