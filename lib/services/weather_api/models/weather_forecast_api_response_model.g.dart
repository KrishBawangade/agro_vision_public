// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_forecast_api_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherForecastApiResponseModel _$WeatherForecastApiResponseModelFromJson(
        Map<String, dynamic> json) =>
    WeatherForecastApiResponseModel(
      current:
          CurrentWeatherModel.fromJson(json['current'] as Map<String, dynamic>),
      forecast: json['forecast'] == null
          ? null
          : WeatherDailyForecastModel.fromJson(
              json['forecast'] as Map<String, dynamic>),
      alerts: json['alerts'] == null
          ? null
          : WeatherAlertsModel.fromJson(json['alerts'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherForecastApiResponseModelToJson(
        WeatherForecastApiResponseModel instance) =>
    <String, dynamic>{
      'current': instance.current.toJson(),
      'forecast': instance.forecast?.toJson(),
      'alerts': instance.alerts?.toJson(),
    };
