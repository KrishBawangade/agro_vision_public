// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_market_price_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentMarketPriceRecordModel _$CurrentMarketPriceRecordModelFromJson(
        Map<String, dynamic> json) =>
    CurrentMarketPriceRecordModel(
      state: json['state'] as String?,
      district: json['district'] as String?,
      market: json['market'] as String?,
      commodity: json['commodity'] as String?,
      variety: json['variety'] as String?,
      grade: json['grade'] as String?,
      arrival_date: json['arrival_date'] as String?,
      min_price: json['min_price'] as String?,
      max_price: json['max_price'] as String?,
      modal_price: json['modal_price'] as String?,
    );

Map<String, dynamic> _$CurrentMarketPriceRecordModelToJson(
        CurrentMarketPriceRecordModel instance) =>
    <String, dynamic>{
      'state': instance.state,
      'district': instance.district,
      'market': instance.market,
      'commodity': instance.commodity,
      'variety': instance.variety,
      'grade': instance.grade,
      'arrival_date': instance.arrival_date,
      'min_price': instance.min_price,
      'max_price': instance.max_price,
      'modal_price': instance.modal_price,
    };
