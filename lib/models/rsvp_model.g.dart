// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rsvp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RSVPModel _$RSVPModelFromJson(Map<String, dynamic> json) => RSVPModel(
      id: (json['id'] as num?)?.toInt(),
      eventId: (json['eventId'] as num).toInt(),
      eventTitle: json['eventTitle'] as String?,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RSVPModelToJson(RSVPModel instance) => <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'eventTitle': instance.eventTitle,
      'userId': instance.userId,
      'userName': instance.userName,
      'status': instance.status,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
