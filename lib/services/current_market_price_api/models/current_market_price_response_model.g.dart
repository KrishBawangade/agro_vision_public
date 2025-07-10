// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_market_price_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentMarketPriceResponseModel _$CurrentMarketPriceResponseModelFromJson(
        Map<String, dynamic> json) =>
    CurrentMarketPriceResponseModel(
      records: (json['records'] as List<dynamic>)
          .map((e) =>
              CurrentMarketPriceRecordModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      languageCode: json['languageCode'] as String?,
    );

Map<String, dynamic> _$CurrentMarketPriceResponseModelToJson(
        CurrentMarketPriceResponseModel instance) =>
    <String, dynamic>{
      'records': instance.records.map((e) => e.toJson()).toList(),
      'languageCode': instance.languageCode,
    };
