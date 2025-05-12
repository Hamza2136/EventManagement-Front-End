class RSVPCounts {
  final int attending;
  final int notAttending;
  final int maybe;

  RSVPCounts({
    required this.attending,
    required this.notAttending,
    required this.maybe,
  });

  factory RSVPCounts.fromJson(Map<String, dynamic> json) {
    return RSVPCounts(
      attending: json['Attending'] ?? 0,
      notAttending: json['Not Attending'] ?? 0,
      maybe: json['Maybe'] ?? 0,
    );
  }
}