// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hourly_humidity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HourlyHumidityModel _$HourlyHumidityModelFromJson(Map<String, dynamic> json) =>
    HourlyHumidityModel(
      relative_humidity_2m: (json['relative_humidity_2m'] as List<dynamic>?)
          ?.map((e) => (e as num?)?.toDouble())
          .toList(),
    );

Map<String, dynamic> _$HourlyHumidityModelToJson(
        HourlyHumidityModel instance) =>
    <String, dynamic>{
      'relative_humidity_2m': instance.relative_humidity_2m,
    };
