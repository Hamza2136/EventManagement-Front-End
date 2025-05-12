class RSVPRequest {
  final int eventId;
  final String status;
  final String? notes;

  RSVPRequest({
    required this.eventId,
    required this.status,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'eventId': eventId,
    'status': status,
    if (notes != null) 'notes': notes,
  };
}