
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'daily_temperature_rainfall_history_model.g.dart';

@JsonSerializable()
class DailyTemperatureRainfallHistoryModel {
  final List<double?>? temperature_2m_mean;
  final List<double?>? rain_sum;

  DailyTemperatureRainfallHistoryModel({required this.temperature_2m_mean, required this.rain_sum});

  factory DailyTemperatureRainfallHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$DailyTemperatureRainfallHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyTemperatureRainfallHistoryModelToJson(this);

}