// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_daily_forecast_day_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherDailyForecastDayModel _$WeatherDailyForecastDayModelFromJson(
        Map<String, dynamic> json) =>
    WeatherDailyForecastDayModel(
      maxtemp_c: (json['maxtemp_c'] as num?)?.toDouble(),
      maxtemp_f: (json['maxtemp_f'] as num?)?.toDouble(),
      mintemp_c: (json['mintemp_c'] as num?)?.toDouble(),
      mintemp_f: (json['mintemp_f'] as num?)?.toDouble(),
      avgtemp_c: (json['avgtemp_c'] as num?)?.toDouble(),
      avgtemp_f: (json['avgtemp_f'] as num?)?.toDouble(),
      maxwind_mph: (json['maxwind_mph'] as num?)?.toDouble(),
      maxwind_kph: (json['maxwind_kph'] as num?)?.toDouble(),
      totalprecip_mm: (json['totalprecip_mm'] as num?)?.toDouble(),
      totalsnow_cm: (json['totalsnow_cm'] as num?)?.toDouble(),
      avgvis_km: (json['avgvis_km'] as num?)?.toDouble(),
      avgvis_miles: (json['avgvis_miles'] as num?)?.toDouble(),
      avghumidity: (json['avghumidity'] as num?)?.toInt(),
      condition: json['condition'] == null
          ? null
          : WeatherConditionModel.fromJson(
              json['condition'] as Map<String, dynamic>),
      daily_chance_of_rain: (json['daily_chance_of_rain'] as num?)?.toInt(),
      uv: (json['uv'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WeatherDailyForecastDayModelToJson(
        WeatherDailyForecastDayModel instance) =>
    <String, dynamic>{
      'maxtemp_c': instance.maxtemp_c,
      'maxtemp_f': instance.maxtemp_f,
      'mintemp_c': instance.mintemp_c,
      'mintemp_f': instance.mintemp_f,
      'avgtemp_c': instance.avgtemp_c,
      'avgtemp_f': instance.avgtemp_f,
      'maxwind_mph': instance.maxwind_mph,
      'maxwind_kph': instance.maxwind_kph,
      'totalprecip_mm': instance.totalprecip_mm,
      'totalsnow_cm': instance.totalsnow_cm,
      'avgvis_km': instance.avgvis_km,
      'avgvis_miles': instance.avgvis_miles,
      'avghumidity': instance.avghumidity,
      'condition': instance.condition?.toJson(),
      'daily_chance_of_rain': instance.daily_chance_of_rain,
      'uv': instance.uv,
    };
