// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop_calendar_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CropCalendarItemModel _$CropCalendarItemModelFromJson(
        Map<String, dynamic> json) =>
    CropCalendarItemModel(
      stage: json['stage'] as String,
      stage_description: json['stage_description'] as String,
      start_date: json['start_date'] as String,
      end_date: json['end_date'] as String,
      colorHexString: json['colorHexString'] as String?,
    );

Map<String, dynamic> _$CropCalendarItemModelToJson(
        CropCalendarItemModel instance) =>
    <String, dynamic>{
      'stage': instance.stage,
      'stage_description': instance.stage_description,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'colorHexString': instance.colorHexString,
    };
