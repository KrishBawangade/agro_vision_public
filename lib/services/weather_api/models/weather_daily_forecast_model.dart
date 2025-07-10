// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'package:agro_vision/services/weather_api/models/weather_forecast_day_model.dart';

part 'weather_daily_forecast_model.g.dart';

@JsonSerializable()
class WeatherDailyForecastModel {
  final List<WeatherForecastDayModel>? forecastday; // Made nullable
  

  WeatherDailyForecastModel({
    this.forecastday
  });

  factory WeatherDailyForecastModel.fromJson(Map<String, dynamic> json) => _$WeatherDailyForecastModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDailyForecastModelToJson(this);

  WeatherDailyForecastModel copyWith({
    List<WeatherForecastDayModel>? forecastday,
  }) {
    return WeatherDailyForecastModel(
      forecastday: forecastday ?? this.forecastday,
    );
  }
}
