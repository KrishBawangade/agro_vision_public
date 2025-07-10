// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentWeatherModel _$CurrentWeatherModelFromJson(Map<String, dynamic> json) =>
    CurrentWeatherModel(
      last_updated: json['last_updated'] as String?,
      last_updated_epoch: (json['last_updated_epoch'] as num?)?.toInt(),
      temp_c: (json['temp_c'] as num?)?.toDouble(),
      temp_f: (json['temp_f'] as num?)?.toDouble(),
      feelslike_c: (json['feelslike_c'] as num?)?.toDouble(),
      feelslike_f: (json['feelslike_f'] as num?)?.toDouble(),
      dewpoint_c: (json['dewpoint_c'] as num?)?.toDouble(),
      dewpoint_f: (json['dewpoint_f'] as num?)?.toDouble(),
      condition: json['condition'] == null
          ? null
          : WeatherConditionModel.fromJson(
              json['condition'] as Map<String, dynamic>),
      wind_mph: (json['wind_mph'] as num?)?.toDouble(),
      wind_kph: (json['wind_kph'] as num?)?.toDouble(),
      wind_degree: (json['wind_degree'] as num?)?.toInt(),
      wind_dir: json['wind_dir'] as String?,
      precip_mm: (json['precip_mm'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toInt(),
      cloud: (json['cloud'] as num?)?.toInt(),
      is_day: (json['is_day'] as num?)?.toInt(),
      vis_km: (json['vis_km'] as num?)?.toDouble(),
      vis_miles: (json['vis_miles'] as num?)?.toDouble(),
      uv: (json['uv'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CurrentWeatherModelToJson(
        CurrentWeatherModel instance) =>
    <String, dynamic>{
      'last_updated': instance.last_updated,
      'last_updated_epoch': instance.last_updated_epoch,
      'temp_c': instance.temp_c,
      'temp_f': instance.temp_f,
      'feelslike_c': instance.feelslike_c,
      'feelslike_f': instance.feelslike_f,
      'dewpoint_c': instance.dewpoint_c,
      'dewpoint_f': instance.dewpoint_f,
      'condition': instance.condition?.toJson(),
      'wind_mph': instance.wind_mph,
      'wind_kph': instance.wind_kph,
      'wind_degree': instance.wind_degree,
      'wind_dir': instance.wind_dir,
      'precip_mm': instance.precip_mm,
      'humidity': instance.humidity,
      'cloud': instance.cloud,
      'is_day': instance.is_day,
      'vis_km': instance.vis_km,
      'vis_miles': instance.vis_miles,
      'uv': instance.uv,
    };
