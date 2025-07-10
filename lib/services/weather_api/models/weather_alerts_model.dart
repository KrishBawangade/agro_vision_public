// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:agro_vision/services/weather_api/models/weather_alert_model.dart';

part 'weather_alerts_model.g.dart';

@JsonSerializable()
class WeatherAlertsModel {
  final List<WeatherAlertModel>? alert;

  WeatherAlertsModel(this.alert);

  factory WeatherAlertsModel.fromJson(Map<String, dynamic> json) => _$WeatherAlertsModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherAlertsModelToJson(this);

  WeatherAlertsModel copyWith({
    List<WeatherAlertModel>? alert,
  }) {
    return WeatherAlertsModel(
      alert ?? this.alert,
    );
  }
}
