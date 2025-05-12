// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_event_frontend/url.dart';

Future<List<User>> searchUsersByQuery(String query) async {
  final response =
      await http.get(Uri.parse('$url/userAccount/search?query=$query'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((user) => User.fromJson(user)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}

class User {
  final String id;
  final String userName;
  final String profilePicture;
  // final bool emailConfirmed;

  User({
    required this.id,
    required this.userName,
    required this.profilePicture,
    // required this.emailConfirmed,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '', 
      userName:
          json['userName'] ?? '', // Use a fallback value if userName is null
      profilePicture: json['profilePicture'] ?? '', // Use a fallback value if email is null
      // emailConfirmed:
      //     json['emailConfirmed'] ?? false, // Default to false if null
      // Handle other fields similarly
    );
  }
}
