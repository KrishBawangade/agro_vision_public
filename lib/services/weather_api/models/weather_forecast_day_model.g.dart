// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_forecast_day_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherForecastDayModel _$WeatherForecastDayModelFromJson(
        Map<String, dynamic> json) =>
    WeatherForecastDayModel(
      json['date'] as String?,
      (json['date_epoch'] as num?)?.toInt(),
      json['day'] == null
          ? null
          : WeatherDailyForecastDayModel.fromJson(
              json['day'] as Map<String, dynamic>),
      json['astro'] == null
          ? null
          : WeatherDailyForecastAstroModel.fromJson(
              json['astro'] as Map<String, dynamic>),
      (json['hour'] as List<dynamic>?)
          ?.map((e) =>
              WeatherDailyForecastHourModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeatherForecastDayModelToJson(
        WeatherForecastDayModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'date_epoch': instance.date_epoch,
      'day': instance.day?.toJson(),
      'astro': instance.astro?.toJson(),
      'hour': instance.hour?.map((e) => e.toJson()).toList(),
    };
