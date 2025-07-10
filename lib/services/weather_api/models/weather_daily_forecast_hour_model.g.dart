// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_daily_forecast_hour_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherDailyForecastHourModel _$WeatherDailyForecastHourModelFromJson(
        Map<String, dynamic> json) =>
    WeatherDailyForecastHourModel(
      time_epoch: (json['time_epoch'] as num?)?.toInt() ?? 0,
      time: json['time'] as String? ?? '',
      temp_c: (json['temp_c'] as num?)?.toDouble() ?? 0.0,
      temp_f: (json['temp_f'] as num?)?.toDouble() ?? 0.0,
      condition: json['condition'] == null
          ? null
          : WeatherConditionModel.fromJson(
              json['condition'] as Map<String, dynamic>),
      wind_mph: (json['wind_mph'] as num?)?.toDouble() ?? 0.0,
      wind_kph: (json['wind_kph'] as num?)?.toDouble() ?? 0.0,
      wind_degree: (json['wind_degree'] as num?)?.toInt() ?? 0,
      wind_dir: json['wind_dir'] as String? ?? 'N',
      precip_mm: (json['precip_mm'] as num?)?.toDouble() ?? 0.0,
      snow_cm: (json['snow_cm'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['humidity'] as num?)?.toInt() ?? 0,
      cloud: (json['cloud'] as num?)?.toInt() ?? 0,
      feelslike_c: (json['feelslike_c'] as num?)?.toDouble() ?? 0.0,
      feelslike_f: (json['feelslike_f'] as num?)?.toDouble() ?? 0.0,
      dewpoint_c: (json['dewpoint_c'] as num?)?.toDouble() ?? 0.0,
      dewpoint_f: (json['dewpoint_f'] as num?)?.toDouble() ?? 0.0,
      will_it_rain: (json['will_it_rain'] as num?)?.toInt() ?? 0,
      will_it_snow: (json['will_it_snow'] as num?)?.toInt() ?? 0,
      is_day: (json['is_day'] as num?)?.toInt() ?? 1,
      vis_km: (json['vis_km'] as num?)?.toDouble() ?? 0.0,
      vis_miles: (json['vis_miles'] as num?)?.toDouble() ?? 0.0,
      chance_of_rain: (json['chance_of_rain'] as num?)?.toInt() ?? 0,
      chance_of_snow: (json['chance_of_snow'] as num?)?.toInt() ?? 0,
      uv: (json['uv'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$WeatherDailyForecastHourModelToJson(
        WeatherDailyForecastHourModel instance) =>
    <String, dynamic>{
      'time_epoch': instance.time_epoch,
      'time': instance.time,
      'temp_c': instance.temp_c,
      'temp_f': instance.temp_f,
      'condition': instance.condition?.toJson(),
      'wind_mph': instance.wind_mph,
      'wind_kph': instance.wind_kph,
      'wind_degree': instance.wind_degree,
      'wind_dir': instance.wind_dir,
      'precip_mm': instance.precip_mm,
      'snow_cm': instance.snow_cm,
      'humidity': instance.humidity,
      'cloud': instance.cloud,
      'feelslike_c': instance.feelslike_c,
      'feelslike_f': instance.feelslike_f,
      'dewpoint_c': instance.dewpoint_c,
      'dewpoint_f': instance.dewpoint_f,
      'will_it_rain': instance.will_it_rain,
      'will_it_snow': instance.will_it_snow,
      'is_day': instance.is_day,
      'vis_km': instance.vis_km,
      'vis_miles': instance.vis_miles,
      'chance_of_rain': instance.chance_of_rain,
      'chance_of_snow': instance.chance_of_snow,
      'uv': instance.uv,
    };
