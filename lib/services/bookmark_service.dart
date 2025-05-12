// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_event_frontend/models/bookmark_model.dart';
import 'package:smart_event_frontend/url.dart';

class BookmarkService {
  final String apiUrl = '$url/Bookmark'; // Update the URL accordingly
  final storage = const FlutterSecureStorage();

  // Method to get bookmarks by user
  Future<BookmarkModel> getBookmarksByUser(String userId) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$apiUrl/user/$userId"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print(response.body);
      return BookmarkModel.fromJson(jsonDecode(response.body)); // Corrected to return BookmarkModel
    } else {
      print('Failed to load bookmarks: ${response.body}');
      throw Exception('Failed to load Bookmarks: ${response.statusCode}');
    }
  }

  // Method to add a bookmark
  Future<void> addBookmark(Map<String, dynamic> bookmarkDto) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(bookmarkDto),
    );

    if (response.statusCode == 200) {
      print("Successfully added bookmark");
    } else {
      print("Failed to add bookmark: ${response.body}");
    }
  }

  // Method to remove a bookmark
  Future<void> removeBookmark(Map<String, dynamic> bookmarkDto) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(bookmarkDto),
    );

    if (response.statusCode == 200) {
      print("Successfully removed bookmark");
    } else {
      print("Failed to remove bookmark: ${response.body}");
    }
  }

  // Method to check if a bookmark exists
  Future<bool> checkBookmark(String userId, int eventId) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$apiUrl/check?userId=$userId&eventId=$eventId"),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['isBookmarked'] as bool;
    } else {
      print("Failed to check bookmark: ${response.body}");
      throw Exception('Failed to check bookmark: ${response.statusCode}');
    }
  }
}
