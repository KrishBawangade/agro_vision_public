// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'current_market_price_record_model.g.dart';

@JsonSerializable()
/// Model representing a single market price record for a commodity.
class CurrentMarketPriceRecordModel {
  final String? state; // Name of the state
  final String? district; // District within the state
  final String? market; // Market name where the price was recorded
  final String? commodity; // Commodity name (e.g., Wheat, Onion)
  final String? variety; // Variety of the commodity
  final String? grade; // Grade/quality level of the commodity
  final String? arrival_date; // Date of commodity arrival (format: yyyy-MM-dd)
  final String? min_price; // Minimum recorded price (per quintal)
  final String? max_price; // Maximum recorded price (per quintal)
  final String? modal_price; // Most common price (modal price) in the market

  CurrentMarketPriceRecordModel({
    required this.state,
    required this.district,
    required this.market,
    required this.commodity,
    required this.variety,
    required this.grade,
    required this.arrival_date,
    required this.min_price,
    required this.max_price,
    required this.modal_price,
  });

  /// Creates an instance from JSON.
  factory CurrentMarketPriceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentMarketPriceRecordModelFromJson(json);

  /// Converts the model to JSON.
  Map<String, dynamic> toJson() => _$CurrentMarketPriceRecordModelToJson(this);

  /// Returns a new instance with updated values.
  CurrentMarketPriceRecordModel copyWith({
    String? state,
    String? district,
    String? market,
    String? commodity,
    String? variety,
    String? grade,
    String? arrival_date,
    String? min_price,
    String? max_price,
    String? modal_price,
  }) {
    return CurrentMarketPriceRecordModel(
      state: state ?? this.state,
      district: district ?? this.district,
      market: market ?? this.market,
      commodity: commodity ?? this.commodity,
      variety: variety ?? this.variety,
      grade: grade ?? this.grade,
      arrival_date: arrival_date ?? this.arrival_date,
      min_price: min_price ?? this.min_price,
      max_price: max_price ?? this.max_price,
      modal_price: modal_price ?? this.modal_price,
    );
  }
}
