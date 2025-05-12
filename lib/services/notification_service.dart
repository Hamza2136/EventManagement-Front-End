// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event_frontend/url.dart';

class NotificationService {
  final String apiUrl = '$url/Notifications';
  final storage = const FlutterSecureStorage();
  String currentUserId = "";
  Future<String?> _getToken() async => await storage.read(key: 'auth_token');

  Future<String> loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      final Map<String, dynamic> json = jsonDecode(userData);
      return json['id'].toString();
    }
    return "";
  }

  Future<List> getNotifications() async {
    final token = await _getToken();
    final userId = await loadCurrentUserId();
    final response = await http.get(
      Uri.parse("$apiUrl/getusernotifications/$userId"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      throw Exception('Failed to load Notifications: ${response.statusCode}');
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$apiUrl/markAsRead/$notificationId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      print("Successfully Mark As Read");
    } else {
      print("Failed to mark as read");
    }
  }

  Future<void> sendFollowNotification(String toUserId) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$apiUrl/follow?toUserId=$toUserId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    _handleResponse(response, "Follow notification sent.");
  }

  Future<void> sendEventCreationNotification(int eventId) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$apiUrl/event-created?eventId=$eventId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    _handleResponse(response, "Event creation notifications sent.");
  }

  Future<void> sendEventInviteNotification(String toUserId, int eventId) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$apiUrl/invite?toUserId=$toUserId&eventId=$eventId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    _handleResponse(response, "Event invitation notification sent.");
  }

  Future<void> sendMessageNotification(
      String toUserId, int messageId, String messageText) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse(
          "$apiUrl/message?toUserId=$toUserId&messageId=$messageId&messageText=${Uri.encodeComponent(messageText)}"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    _handleResponse(response, "Message notification sent.");
  }

  void _handleResponse(http.Response response, String successMessage) {
    if (response.statusCode == 200) {
      print(successMessage);
    } else {
      print("Request failed: ${response.statusCode}");
    }
  }
}
