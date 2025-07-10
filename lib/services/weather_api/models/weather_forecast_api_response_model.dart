// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:agro_vision/services/weather_api/models/current_weather_model.dart';
import 'package:agro_vision/services/weather_api/models/weather_alerts_model.dart';
import 'package:agro_vision/services/weather_api/models/weather_daily_forecast_model.dart';

part 'weather_forecast_api_response_model.g.dart';

@JsonSerializable()
class WeatherForecastApiResponseModel {
  final CurrentWeatherModel current;
  final WeatherDailyForecastModel? forecast; // Made nullable
  final WeatherAlertsModel? alerts; // Made nullable

  WeatherForecastApiResponseModel({
    required this.current,
    this.forecast, // Made nullable
    this.alerts, // Made nullable
  }) ; // Initialize with an empty list if null

  factory WeatherForecastApiResponseModel.fromJson(Map<String, dynamic> json) => _$WeatherForecastApiResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastApiResponseModelToJson(this);

  WeatherForecastApiResponseModel copyWith({
    CurrentWeatherModel? current,
    WeatherDailyForecastModel? forecast,
    WeatherAlertsModel? alerts,
  }) {
    return WeatherForecastApiResponseModel(
      current: current ?? this.current,
      forecast: forecast ?? this.forecast,
      alerts: alerts ?? this.alerts,
    );
  }
}
