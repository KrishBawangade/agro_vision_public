import 'package:agro_vision/services/weather_history_api/models/hourly_humidity_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hourly_humidity_weather_history_response_model.g.dart';

@JsonSerializable()
class HourlyHumidityWeatherHistoryResponseModel{
  final HourlyHumidityModel? hourly;

  HourlyHumidityWeatherHistoryResponseModel({required this.hourly});

  factory HourlyHumidityWeatherHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HourlyHumidityWeatherHistoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyHumidityWeatherHistoryResponseModelToJson(this);
}