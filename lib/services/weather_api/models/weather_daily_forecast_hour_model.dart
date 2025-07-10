// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'package:agro_vision/services/weather_api/models/weather_condition_model.dart';

part 'weather_daily_forecast_hour_model.g.dart';

@JsonSerializable()
class WeatherDailyForecastHourModel {
  final int time_epoch;
  final String time;
  final double? temp_c;               // Nullable
  final double? temp_f;               // Nullable
  final WeatherConditionModel? condition; // Fixed typo and made nullable
  final double? wind_mph;             // Nullable
  final double? wind_kph;             // Nullable
  final int wind_degree;
  final String wind_dir;
  final double? precip_mm;            // Nullable
  final double? snow_cm;              // Nullable
  final int humidity;
  final int cloud;
  final double? feelslike_c;          // Nullable
  final double? feelslike_f;          // Nullable
  final double? dewpoint_c;           // Nullable
  final double? dewpoint_f;           // Nullable
  final int will_it_rain;
  final int will_it_snow;
  final int is_day;
  final double? vis_km;               // Nullable
  final double? vis_miles;            // Nullable
  final int chance_of_rain;
  final int chance_of_snow;
  final int uv;

  WeatherDailyForecastHourModel({
    this.time_epoch = 0,
    this.time = '',
    this.temp_c = 0.0,
    this.temp_f = 0.0,
    this.condition,                 // Nullable
    this.wind_mph = 0.0,
    this.wind_kph = 0.0,
    this.wind_degree = 0,
    this.wind_dir = 'N',
    this.precip_mm = 0.0,
    this.snow_cm = 0.0,
    this.humidity = 0,
    this.cloud = 0,
    this.feelslike_c = 0.0,
    this.feelslike_f = 0.0,
    this.dewpoint_c = 0.0,
    this.dewpoint_f = 0.0,
    this.will_it_rain = 0,
    this.will_it_snow = 0,
    this.is_day = 1,
    this.vis_km = 0.0,
    this.vis_miles = 0.0,
    this.chance_of_rain = 0,
    this.chance_of_snow = 0,
    this.uv = 0,
  });

  factory WeatherDailyForecastHourModel.fromJson(Map<String, dynamic> json) => _$WeatherDailyForecastHourModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDailyForecastHourModelToJson(this);

  WeatherDailyForecastHourModel copyWith({
    int? time_epoch,
    String? time,
    double? temp_c,
    double? temp_f,
    WeatherConditionModel? condition,
    double? wind_mph,
    double? wind_kph,
    int? wind_degree,
    String? wind_dir,
    double? precip_mm,
    double? snow_cm,
    int? humidity,
    int? cloud,
    double? feelslike_c,
    double? feelslike_f,
    double? dewpoint_c,
    double? dewpoint_f,
    int? will_it_rain,
    int? will_it_snow,
    int? is_day,
    double? vis_km,
    double? vis_miles,
    int? chance_of_rain,
    int? chance_of_snow,
    int? uv,
  }) {
    return WeatherDailyForecastHourModel(
      time_epoch: time_epoch ?? this.time_epoch,
      time: time ?? this.time,
      temp_c: temp_c ?? this.temp_c,
      temp_f: temp_f ?? this.temp_f,
      condition: condition ?? this.condition,
      wind_mph: wind_mph ?? this.wind_mph,
      wind_kph: wind_kph ?? this.wind_kph,
      wind_degree: wind_degree ?? this.wind_degree,
      wind_dir: wind_dir ?? this.wind_dir,
      precip_mm: precip_mm ?? this.precip_mm,
      snow_cm: snow_cm ?? this.snow_cm,
      humidity: humidity ?? this.humidity,
      cloud: cloud ?? this.cloud,
      feelslike_c: feelslike_c ?? this.feelslike_c,
      feelslike_f: feelslike_f ?? this.feelslike_f,
      dewpoint_c: dewpoint_c ?? this.dewpoint_c,
      dewpoint_f: dewpoint_f ?? this.dewpoint_f,
      will_it_rain: will_it_rain ?? this.will_it_rain,
      will_it_snow: will_it_snow ?? this.will_it_snow,
      is_day: is_day ?? this.is_day,
      vis_km: vis_km ?? this.vis_km,
      vis_miles: vis_miles ?? this.vis_miles,
      chance_of_rain: chance_of_rain ?? this.chance_of_rain,
      chance_of_snow: chance_of_snow ?? this.chance_of_snow,
      uv: uv ?? this.uv,
    );
  }
}
