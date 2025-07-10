// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_data_model.g.dart';

@JsonSerializable()

/// A model representing user-specific data and usage limits.
class UserDataModel {
  /// Unique ID for the user document (usually Firestore document ID)
  String id;

  /// User's full name
  final String name;

  /// User's email address
  final String email;

  /// Profile image URL
  String image;

  /// File name used for the stored profile image (optional)
  String imageFileName;

  /// Number of crop calendar generation requests remaining
  int cropCalendarRequestsLeft;

  /// Number of crop suggestion requests remaining
  int cropSuggestionsRequestsLeft;

  /// Number of chatbot usage requests remaining
  int chatBotRequestsLeft;

  /// Timestamp of the last time request limits were updated
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? lastTimeRequestsUpdated;

  /// Constructor to initialize user data with default request limits
  UserDataModel({
    this.id = "",
    required this.name,
    required this.email,
    required this.image,
    this.imageFileName = "",
    this.cropCalendarRequestsLeft = 2,
    this.cropSuggestionsRequestsLeft = 3,
    this.chatBotRequestsLeft = 5,
    this.lastTimeRequestsUpdated,
  });

  /// Converts Firestore Timestamp to Dart DateTime
  static DateTime? _timestampFromJson(Timestamp? timestamp) =>
      timestamp?.toDate();

  /// Converts Dart DateTime to Firestore Timestamp
  static Timestamp? _timestampToJson(DateTime? dateTime) =>
      dateTime != null ? Timestamp.fromDate(dateTime) : null;

  /// Factory constructor to create an instance from JSON
  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);

  /// Converts instance to JSON for storage or transmission
  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);

  /// Returns a copy of the current instance with optional modified fields
  UserDataModel copyWith({
    String? id,
    String? name,
    String? email,
    String? image,
    String? imageFileName,
    int? cropCalendarRequestsLeft,
    int? cropSuggestionsRequestsLeft,
    int? chatBotRequestsLeft,
    DateTime? lastTimeRequestsUpdated,
  }) {
    return UserDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      imageFileName: imageFileName ?? this.imageFileName,
      cropCalendarRequestsLeft:
          cropCalendarRequestsLeft ?? this.cropCalendarRequestsLeft,
      cropSuggestionsRequestsLeft:
          cropSuggestionsRequestsLeft ?? this.cropSuggestionsRequestsLeft,
      chatBotRequestsLeft: chatBotRequestsLeft ?? this.chatBotRequestsLeft,
      lastTimeRequestsUpdated:
          lastTimeRequestsUpdated ?? this.lastTimeRequestsUpdated,
    );
  }
}
