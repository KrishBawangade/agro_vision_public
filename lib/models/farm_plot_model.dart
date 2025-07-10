// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:agro_vision/utils/enums.dart';

part 'farm_plot_model.g.dart';

@JsonSerializable()

/// A data model representing a farm plot's details.
class FarmPlotModel {
  /// Unique ID of the farm plot (Firestore doc ID)
  String id;

  /// ID of the user who owns this farm plot
  final String userId;

  /// Name of the farm plot
  final String name;

  /// Name of the crop planted in this plot
  final String crop;

  /// Area value (e.g., 2.5)
  final double areaValue;

  /// Unit of area (e.g., acres, hectares)
  final FarmPlotAreaUnits areaUnit;

  /// Latitude coordinate of the plot
  final double latitude;

  /// Longitude coordinate of the plot
  final double longitude;

  /// Address or location details
  final String address;

  /// Plantation date in epoch milliseconds (used for crop calendar)
  final int plantationDateMillis;

  /// Language code used for localization (optional)
  String? languageCode;

  /// Constructor for creating a FarmPlotModel instance
  FarmPlotModel({
    this.id = "",
    this.userId = "",
    required this.name,
    required this.crop,
    required this.areaValue,
    required this.areaUnit,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.plantationDateMillis,
    this.languageCode,
  });

  /// Creates a model instance from a JSON map
  factory FarmPlotModel.fromJson(Map<String, dynamic> json) =>
      _$FarmPlotModelFromJson(json);

  /// Converts the model instance to a JSON map
  Map<String, dynamic> toJson() => _$FarmPlotModelToJson(this);

  /// Returns a copy of this model with optional updated fields
  FarmPlotModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? crop,
    double? areaValue,
    FarmPlotAreaUnits? areaUnit,
    double? latitude,
    double? longitude,
    String? address,
    int? plantationDateMillis,
    String? languageCode,
  }) {
    return FarmPlotModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      crop: crop ?? this.crop,
      areaValue: areaValue ?? this.areaValue,
      areaUnit: areaUnit ?? this.areaUnit,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      plantationDateMillis: plantationDateMillis ?? this.plantationDateMillis,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
