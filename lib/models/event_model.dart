class EventModel {
  final int id;
  final String date;
  final String title;
  final String attendees;
  final String location;
  final String imageUrl;
  final String description;
  final String organizerName;
  final String organizerPicture;
  final String organizerId;
  final int eventCategoryId;
  final String eventCategoryName;
  final String status;
  final String tags;
  final double cost;
  final String endDate;
  final int maxCapacity;

  EventModel({
    required this.id,
    required this.date,
    required this.title,
    required this.attendees,
    required this.location,
    required this.imageUrl,
    required this.description,
    required this.organizerName,
    required this.organizerPicture,
    required this.organizerId,
    required this.eventCategoryId,
    required this.eventCategoryName,
    required this.status,
    required this.tags,
    required this.cost,
    required this.endDate,
    required this.maxCapacity
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      date: json['startDate'],
      title: json['title'],
      attendees: json['rsvpCount'].toString(),
      location: json['location'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      organizerName: json['organizerName'],
      organizerPicture: json['organizerPicture'],
      organizerId: json['organizerId'],
      eventCategoryId: json['eventCategoryId'],
      eventCategoryName: json['eventCategoryName'],
      status: json['status'],
      tags: json['tags'],
      cost: json['cost'],
      endDate: json['endDate'],
      maxCapacity: json['maxCapacity']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': date,
      'title': title,
      'rsvpCount': int.parse(attendees), // Assuming attendees is a string but needs to be an integer
      'location': location,
      'imageUrl': imageUrl,
      'description': description,
      'organizerName': organizerName,
      'organizerPicture': organizerPicture,
      'organizerId': organizerId,
      'eventCategoryId': eventCategoryId,
      'eventCategoryName': eventCategoryName,
      'status': status,
      'tags': tags,
      'cost': cost,
      'endDate': endDate,
      'maxCapacity': maxCapacity,
    };
  }
}
