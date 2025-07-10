// ignore_for_file: non_constant_identifier_names


import 'package:json_annotation/json_annotation.dart';

part 'hourly_humidity_model.g.dart';

@JsonSerializable()
class HourlyHumidityModel {
  final List<double?>? relative_humidity_2m;

  HourlyHumidityModel({required this.relative_humidity_2m}); 

  factory HourlyHumidityModel.fromJson(Map<String, dynamic> json) =>
      _$HourlyHumidityModelFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyHumidityModelToJson(this);
}