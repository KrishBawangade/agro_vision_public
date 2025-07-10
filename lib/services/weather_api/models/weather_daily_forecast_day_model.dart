// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'package:agro_vision/services/weather_api/models/weather_condition_model.dart';

part 'weather_daily_forecast_day_model.g.dart';

@JsonSerializable()
class WeatherDailyForecastDayModel {
  final double? maxtemp_c;       // Nullable
  final double? maxtemp_f;       // Nullable
  final double? mintemp_c;       // Nullable
  final double? mintemp_f;       // Nullable
  final double? avgtemp_c;       // Nullable
  final double? avgtemp_f;       // Nullable
  final double? maxwind_mph;     // Nullable
  final double? maxwind_kph;     // Nullable
  final double? totalprecip_mm;  // Nullable
  final double? totalsnow_cm;    // Nullable
  final double? avgvis_km;       // Nullable
  final double? avgvis_miles;    // Nullable
  final int? avghumidity;        // Nullable
  final WeatherConditionModel? condition; // Nullable
  final int? daily_chance_of_rain;
  final int? uv;                 // Nullable

  const WeatherDailyForecastDayModel({
    this.maxtemp_c , 
    this.maxtemp_f , 
    this.mintemp_c , 
    this.mintemp_f, 
    this.avgtemp_c, 
    this.avgtemp_f, 
    this.maxwind_mph, 
    this.maxwind_kph , 
    this.totalprecip_mm , 
    this.totalsnow_cm, 
    this.avgvis_km, 
    this.avgvis_miles, 
    this.avghumidity, 
    this.condition, // Nullable
    this.daily_chance_of_rain,
    this.uv ,
  });

  factory WeatherDailyForecastDayModel.fromJson(Map<String, dynamic> json) => _$WeatherDailyForecastDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDailyForecastDayModelToJson(this);

  WeatherDailyForecastDayModel copyWith({
    double? maxtemp_c,
    double? maxtemp_f,
    double? mintemp_c,
    double? mintemp_f,
    double? avgtemp_c,
    double? avgtemp_f,
    double? maxwind_mph,
    double? maxwind_kph,
    double? totalprecip_mm,
    double? totalsnow_cm,
    double? avgvis_km,
    double? avgvis_miles,
    int? avghumidity,
    WeatherConditionModel? condition,
    int? daily_chance_of_rain,
    int? uv,
  }) {
    return WeatherDailyForecastDayModel(
      maxtemp_c: maxtemp_c ?? this.maxtemp_c,
      maxtemp_f: maxtemp_f ?? this.maxtemp_f,
      mintemp_c: mintemp_c ?? this.mintemp_c,
      mintemp_f: mintemp_f ?? this.mintemp_f,
      avgtemp_c: avgtemp_c ?? this.avgtemp_c,
      avgtemp_f: avgtemp_f ?? this.avgtemp_f,
      maxwind_mph: maxwind_mph ?? this.maxwind_mph,
      maxwind_kph: maxwind_kph ?? this.maxwind_kph,
      totalprecip_mm: totalprecip_mm ?? this.totalprecip_mm,
      totalsnow_cm: totalsnow_cm ?? this.totalsnow_cm,
      avgvis_km: avgvis_km ?? this.avgvis_km,
      avgvis_miles: avgvis_miles ?? this.avgvis_miles,
      avghumidity: avghumidity ?? this.avghumidity,
      condition: condition ?? this.condition,
      daily_chance_of_rain: daily_chance_of_rain ?? this.daily_chance_of_rain,
      uv: uv ?? this.uv,
    );
  }
}
