// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'weather_daily_forecast_astro_model.g.dart';

@JsonSerializable()
class WeatherDailyForecastAstroModel {
  final String? sunrise; // Nullable
  final String? sunset;  // Nullable
  final String? moonrise; // Nullable
  final String? moonset;  // Nullable

  WeatherDailyForecastAstroModel({
    this.sunrise = "", 
    this.sunset = "", 
    this.moonrise = "", 
    this.moonset = "",
  });

  factory WeatherDailyForecastAstroModel.fromJson(Map<String, dynamic> json) => _$WeatherDailyForecastAstroModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDailyForecastAstroModelToJson(this);

  WeatherDailyForecastAstroModel copyWith({
    String? sunrise,
    String? sunset,
    String? moonrise,
    String? moonset,
  }) {
    return WeatherDailyForecastAstroModel(
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      moonrise: moonrise ?? this.moonrise,
      moonset: moonset ?? this.moonset,
    );
  }
}
