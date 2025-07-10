// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:agro_vision/services/current_market_price_api/models/current_market_price_record_model.dart';

part 'current_market_price_response_model.g.dart';

@JsonSerializable()
/// Model representing the response from the current market price API.
/// Contains a list of price records and an optional language code.
class CurrentMarketPriceResponseModel {
  /// List of market price records.
  List<CurrentMarketPriceRecordModel> records;

  /// Language code in which the data is presented (e.g., "en", "hi", etc.).
  String? languageCode;

  CurrentMarketPriceResponseModel({
    required this.records,
    this.languageCode,
  });

  /// Creates an instance from JSON.
  factory CurrentMarketPriceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentMarketPriceResponseModelFromJson(json);

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() => _$CurrentMarketPriceResponseModelToJson(this);

  /// Returns a copy of the model with updated values.
  CurrentMarketPriceResponseModel copyWith({
    List<CurrentMarketPriceRecordModel>? records,
    String? languageCode,
  }) {
    return CurrentMarketPriceResponseModel(
      records: records ?? this.records,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
