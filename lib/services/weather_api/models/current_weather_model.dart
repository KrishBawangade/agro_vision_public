// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'package:agro_vision/services/weather_api/models/weather_condition_model.dart';

part 'current_weather_model.g.dart';

@JsonSerializable()
class CurrentWeatherModel {
  final String? last_updated;       // Nullable
  final int? last_updated_epoch;    // Nullable
  final double? temp_c;             // Nullable
  final double? temp_f;             // Nullable
  final double? feelslike_c;        // Nullable
  final double? feelslike_f;        // Nullable
  final double? dewpoint_c;         // Nullable
  final double? dewpoint_f;         // Nullable
  final WeatherConditionModel? condition; // Nullable
  final double? wind_mph;           // Nullable
  final double? wind_kph;           // Nullable
  final int? wind_degree;           // Nullable
  final String? wind_dir;           // Nullable
  final double? precip_mm;          // Nullable
  final int? humidity;              // Nullable
  final int? cloud;                 // Nullable
  final int? is_day;                // Nullable
  final double? vis_km;             // Nullable
  final double? vis_miles;          // Nullable
  final double? uv;                 // Nullable

  CurrentWeatherModel({
    this.last_updated,
    this.last_updated_epoch,
    this.temp_c,
    this.temp_f,
    this.feelslike_c,
    this.feelslike_f,
    this.dewpoint_c,
    this.dewpoint_f,
    this.condition,
    this.wind_mph,
    this.wind_kph,
    this.wind_degree,
    this.wind_dir,
    this.precip_mm,
    this.humidity,
    this.cloud,
    this.is_day,
    this.vis_km,
    this.vis_miles,
    this.uv,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentWeatherModelToJson(this);

  CurrentWeatherModel copyWith({
    String? last_updated,
    int? last_updated_epoch,
    double? temp_c,
    double? temp_f,
    double? feelslike_c,
    double? feelslike_f,
    double? dewpoint_c,
    double? dewpoint_f,
    WeatherConditionModel? condition,
    double? wind_mph,
    double? wind_kph,
    int? wind_degree,
    String? wind_dir,
    double? precip_mm,
    int? humidity,
    int? cloud,
    int? is_day,
    double? vis_km,
    double? vis_miles,
    double? uv,
  }) {
    return CurrentWeatherModel(
      last_updated: last_updated ?? this.last_updated,
      last_updated_epoch: last_updated_epoch ?? this.last_updated_epoch,
      temp_c: temp_c ?? this.temp_c,
      temp_f: temp_f ?? this.temp_f,
      feelslike_c: feelslike_c ?? this.feelslike_c,
      feelslike_f: feelslike_f ?? this.feelslike_f,
      dewpoint_c: dewpoint_c ?? this.dewpoint_c,
      dewpoint_f: dewpoint_f ?? this.dewpoint_f,
      condition: condition ?? this.condition,
      wind_mph: wind_mph ?? this.wind_mph,
      wind_kph: wind_kph ?? this.wind_kph,
      wind_degree: wind_degree ?? this.wind_degree,
      wind_dir: wind_dir ?? this.wind_dir,
      precip_mm: precip_mm ?? this.precip_mm,
      humidity: humidity ?? this.humidity,
      cloud: cloud ?? this.cloud,
      is_day: is_day ?? this.is_day,
      vis_km: vis_km ?? this.vis_km,
      vis_miles: vis_miles ?? this.vis_miles,
      uv: uv ?? this.uv,
    );
  }
}
