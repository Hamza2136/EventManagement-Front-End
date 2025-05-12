import 'package:json_annotation/json_annotation.dart';

part 'rsvp_model.g.dart';

@JsonSerializable()
class RSVPModel {
  final int? id;
  final int eventId;
  final String? eventTitle;
  final String? userId;
  final String? userName;
  final String status;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RSVPModel({
    this.id,
    required this.eventId,
    this.eventTitle,
    this.userId,
    this.userName,
    required this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory RSVPModel.fromJson(Map<String, dynamic> json) => _$RSVPModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$RSVPModelToJson(this);
}
