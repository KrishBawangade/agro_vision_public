// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'weather_condition_model.g.dart';

@JsonSerializable()
class WeatherConditionModel {
  final String? text; // Nullable
  final String? icon; // Nullable
  final int? code;    // Nullable

  WeatherConditionModel({
    this.text = "", 
    this.icon = "", 
    this.code = 0,
  });

  factory WeatherConditionModel.fromJson(Map<String, dynamic> json) => _$WeatherConditionModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherConditionModelToJson(this);

  WeatherConditionModel copyWith({
    String? text,
    String? icon,
    int? code,
  }) {
    return WeatherConditionModel(
      text: text ?? this.text,
      icon: icon ?? this.icon,
      code: code ?? this.code,
    );
  }
}
