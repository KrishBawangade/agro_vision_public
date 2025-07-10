// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop_calendar_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CropCalendarResponseModel _$CropCalendarResponseModelFromJson(
        Map<String, dynamic> json) =>
    CropCalendarResponseModel(
      id: json['id'] as String? ?? "",
      userId: json['userId'] as String? ?? "",
      farmPlotId: json['farmPlotId'] as String? ?? "",
      crop: json['crop'] as String,
      crop_calendar: (json['crop_calendar'] as List<dynamic>)
          .map((e) => CropCalendarItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      languageCode: json['languageCode'] as String?,
    );

Map<String, dynamic> _$CropCalendarResponseModelToJson(
        CropCalendarResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'farmPlotId': instance.farmPlotId,
      'crop': instance.crop,
      'crop_calendar': instance.crop_calendar.map((e) => e.toJson()).toList(),
      'languageCode': instance.languageCode,
    };
