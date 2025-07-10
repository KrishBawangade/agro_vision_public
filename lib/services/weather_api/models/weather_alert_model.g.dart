// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherAlertModel _$WeatherAlertModelFromJson(Map<String, dynamic> json) =>
    WeatherAlertModel(
      headline: json['headline'] as String?,
      msgtype: json['msgtype'] as String?,
      severity: json['severity'] as String?,
      urgency: json['urgency'] as String?,
      areas: json['areas'] as String?,
      certainty: json['certainty'] as String?,
      event: json['event'] as String?,
      instruction: json['instruction'] as String?,
    );

Map<String, dynamic> _$WeatherAlertModelToJson(WeatherAlertModel instance) =>
    <String, dynamic>{
      'headline': instance.headline,
      'msgtype': instance.msgtype,
      'severity': instance.severity,
      'urgency': instance.urgency,
      'areas': instance.areas,
      'certainty': instance.certainty,
      'event': instance.event,
      'instruction': instance.instruction,
    };
