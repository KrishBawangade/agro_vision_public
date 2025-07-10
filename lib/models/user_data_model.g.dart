// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDataModel _$UserDataModelFromJson(Map<String, dynamic> json) =>
    UserDataModel(
      id: json['id'] as String? ?? "",
      name: json['name'] as String,
      email: json['email'] as String,
      image: json['image'] as String,
      imageFileName: json['imageFileName'] as String? ?? "",
      cropCalendarRequestsLeft:
          (json['cropCalendarRequestsLeft'] as num?)?.toInt() ?? 2,
      cropSuggestionsRequestsLeft:
          (json['cropSuggestionsRequestsLeft'] as num?)?.toInt() ?? 3,
      chatBotRequestsLeft: (json['chatBotRequestsLeft'] as num?)?.toInt() ?? 5,
      lastTimeRequestsUpdated: UserDataModel._timestampFromJson(
          json['lastTimeRequestsUpdated'] as Timestamp?),
    );

Map<String, dynamic> _$UserDataModelToJson(UserDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'image': instance.image,
      'imageFileName': instance.imageFileName,
      'cropCalendarRequestsLeft': instance.cropCalendarRequestsLeft,
      'cropSuggestionsRequestsLeft': instance.cropSuggestionsRequestsLeft,
      'chatBotRequestsLeft': instance.chatBotRequestsLeft,
      'lastTimeRequestsUpdated':
          UserDataModel._timestampToJson(instance.lastTimeRequestsUpdated),
    };
