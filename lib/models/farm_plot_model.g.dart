// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_plot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmPlotModel _$FarmPlotModelFromJson(Map<String, dynamic> json) =>
    FarmPlotModel(
      id: json['id'] as String? ?? "",
      userId: json['userId'] as String? ?? "",
      name: json['name'] as String,
      crop: json['crop'] as String,
      areaValue: (json['areaValue'] as num).toDouble(),
      areaUnit: $enumDecode(_$FarmPlotAreaUnitsEnumMap, json['areaUnit']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      plantationDateMillis: (json['plantationDateMillis'] as num).toInt(),
      languageCode: json['languageCode'] as String?,
    );

Map<String, dynamic> _$FarmPlotModelToJson(FarmPlotModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'crop': instance.crop,
      'areaValue': instance.areaValue,
      'areaUnit': _$FarmPlotAreaUnitsEnumMap[instance.areaUnit]!,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'plantationDateMillis': instance.plantationDateMillis,
      'languageCode': instance.languageCode,
    };

const _$FarmPlotAreaUnitsEnumMap = {
  FarmPlotAreaUnits.acre: 'acre',
  FarmPlotAreaUnits.hectare: 'hectare',
  FarmPlotAreaUnits.guntha: 'guntha',
  FarmPlotAreaUnits.bigha: 'bigha',
  FarmPlotAreaUnits.sqmt: 'sqmt',
};
