class BookMarkEventModel {
  final int id;
  final String title;
  final String description;
  final String startDate;  // Changed from 'date' to match JSON
  final String endDate;
  final String location;
  final String organizerId;
  final int eventCategoryId;
  final int rsvpCount;
  final int maxCapacity;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String imageUrl;
  final double cost;
  final String tags;

  BookMarkEventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.organizerId,
    required this.eventCategoryId,
    required this.rsvpCount,
    required this.maxCapacity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl,
    required this.cost,
    required this.tags,
  });

  factory BookMarkEventModel.fromJson(Map<String, dynamic> json) {
    return BookMarkEventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      location: json['location'],
      organizerId: json['organizerId'],
      eventCategoryId: json['eventCategoryId'],
      rsvpCount: json['rsvpCount'],
      maxCapacity: json['maxCapacity'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'] ?? '0001-01-01T00:00:00',  // Provide default for nullable
      imageUrl: json['imageUrl'],
      cost: json['cost'] is int ? (json['cost'] as int).toDouble() : json['cost'],
      tags: json['tags'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'organizerId': organizerId,
      'eventCategoryId': eventCategoryId,
      'rsvpCount': rsvpCount,
      'maxCapacity': maxCapacity,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'imageUrl': imageUrl,
      'cost': cost,
      'tags': tags,
    };
  }
}

class BookmarkData {
  final int id;
  final String userId;
  final dynamic user;  // Changed to dynamic since it's null in your data
  final int eventId;
  final BookMarkEventModel event;
  final String createdAt;  // Using String instead of DateTime to avoid parsing issues

  BookmarkData({
    required this.id,
    required this.userId,
    this.user,
    required this.eventId,
    required this.event,
    required this.createdAt,
  });

  factory BookmarkData.fromJson(Map<String, dynamic> json) {
    return BookmarkData(
      id: json['id'],
      userId: json['userId'],
      user: json['user'],
      eventId: json['eventId'],
      event: BookMarkEventModel.fromJson(json['event']),
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'user': user,
      'eventId': eventId,
      'event': event.toJson(),
      'createdAt': createdAt,
    };
  }
}

class BookmarkModel {
  final String message;
  final bool result;
  final List<BookmarkData> data;

  BookmarkModel({
    required this.message,
    required this.result,
    required this.data,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<BookmarkData> data = dataList.map((i) => BookmarkData.fromJson(i)).toList();

    return BookmarkModel(
      message: json['message'],
      result: json['result'],
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'result': result,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}