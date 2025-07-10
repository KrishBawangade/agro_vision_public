// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'weather_alert_model.g.dart';

@JsonSerializable()
class WeatherAlertModel {
  final String? headline;    // Nullable
  final String? msgtype;     // Nullable
  final String? severity;    // Nullable
  final String? urgency;     // Nullable
  final String? areas;       // Nullable
  final String? certainty;    // Nullable
  final String? event;       // Nullable
  final String? instruction; // Nullable

  WeatherAlertModel({
    this.headline,
    this.msgtype,
    this.severity,
    this.urgency,
    this.areas,
    this.certainty,
    this.event,
    this.instruction,
  });

  factory WeatherAlertModel.fromJson(Map<String, dynamic> json) => _$WeatherAlertModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherAlertModelToJson(this);

  WeatherAlertModel copyWith({
    String? headline,
    String? msgtype,
    String? severity,
    String? urgency,
    String? areas,
    String? certainty,
    String? event,
    String? instruction,
  }) {
    return WeatherAlertModel(
      headline: headline ?? this.headline,
      msgtype: msgtype ?? this.msgtype,
      severity: severity ?? this.severity,
      urgency: urgency ?? this.urgency,
      areas: areas ?? this.areas,
      certainty: certainty ?? this.certainty,
      event: event ?? this.event,
      instruction: instruction ?? this.instruction,
    );
  }
}
