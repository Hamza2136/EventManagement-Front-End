import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_event_frontend/models/event_model.dart';
import 'package:smart_event_frontend/url.dart';

class EventService {
  final String apiUrl = '$url/event';
  final storage = const FlutterSecureStorage();

  Future<List<EventModel>> getAllEvents() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$apiUrl/getallevents"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((event) => EventModel.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  }

  Future<List<EventModel>> getAllUpcomingEvents() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$apiUrl/GetAllUpcomingEvents"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((event) => EventModel.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  }

  Future<List<EventModel>> getAllPastEvents() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$apiUrl/GetAllPastEvents"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((event) => EventModel.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  }


  Future<List<EventModel>> getMyEvents() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$apiUrl/GetEventsByCurrentUser"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((event) => EventModel.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  }

  Future<List<EventModel>> getEventsByTags(List<String> tags) async {
    final token = await storage.read(key: 'auth_token');
    final uri = Uri.parse('$url/event/filter-by-tags');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(tags),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((e) => EventModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load filtered events: ${response.statusCode}');
    }
  }

  Future<void> deleteEvent(int eventId) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.delete(
      Uri.parse('$url/Event/DeleteEvent$eventId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete event: ${response.statusCode}');
    }
  }
  
  Future<List<EventModel>> searchEvent(String query,
      {Map<String, dynamic>? filters}) async {
    final token = await storage.read(key: 'auth_token');

    final Map<String, dynamic> queryParams = {'keyword': query};

    if (filters != null) {
      filters.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          queryParams[key] = value;
        }
      });
    }
    final uri =
        Uri.parse('$url/event/search').replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((event) => EventModel.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  }
}
