import 'package:agro_vision/services/weather_history_api/models/daily_temperature_rainfall_history_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'temperature_rainfall_weather_history_response_model.g.dart';

@JsonSerializable()
class TemperatureRainfallWeatherHistoryResponseModel {
  final DailyTemperatureRainfallHistoryModel? daily;

  TemperatureRainfallWeatherHistoryResponseModel({required this.daily});

  factory TemperatureRainfallWeatherHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TemperatureRainfallWeatherHistoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TemperatureRainfallWeatherHistoryResponseModelToJson(this);

}