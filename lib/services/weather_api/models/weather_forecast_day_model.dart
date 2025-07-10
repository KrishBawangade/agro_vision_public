// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'package:agro_vision/services/weather_api/models/weather_daily_forecast_astro_model.dart';
import 'package:agro_vision/services/weather_api/models/weather_daily_forecast_day_model.dart';
import 'package:agro_vision/services/weather_api/models/weather_daily_forecast_hour_model.dart';

part 'weather_forecast_day_model.g.dart';

@JsonSerializable()
class WeatherForecastDayModel {
  final String? date;
  final int? date_epoch;
  final WeatherDailyForecastDayModel? day;
  final WeatherDailyForecastAstroModel? astro; // Made nullable
  final List<WeatherDailyForecastHourModel>? hour;

  WeatherForecastDayModel(this.date, this.date_epoch, this.day, this.astro, this.hour); // Made a list and nullable

  factory WeatherForecastDayModel.fromJson(Map<String, dynamic> json) => _$WeatherForecastDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastDayModelToJson(this);

  WeatherForecastDayModel copyWith({
    String? date,
    int? date_epoch,
    WeatherDailyForecastDayModel? day,
    WeatherDailyForecastAstroModel? astro,
    List<WeatherDailyForecastHourModel>? hour,
  }) {
    return WeatherForecastDayModel(
      date ?? this.date,
      date_epoch ?? this.date_epoch,
      day ?? this.day,
      astro ?? this.astro,
      hour ?? this.hour,
    );
  }
}
