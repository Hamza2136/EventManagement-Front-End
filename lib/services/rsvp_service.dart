import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_event_frontend/services/auth_service.dart';
import 'package:smart_event_frontend/url.dart';
import '../models/rsvp_model.dart';
import '../models/rsvp_request.dart';
import '../models/rsvp_counts.dart';

class RSVPService {
  final AuthService _authService = AuthService();
  
  // Create a new RSVP
  Future<RSVPModel> createRSVP(RSVPRequest request) async {
    final token = await _authService.getToken();
    
    final response = await http.post(
      Uri.parse('$url/RSVP'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );
    
    if (response.statusCode == 201) {
      return RSVPModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create RSVP: ${response.body}');
    }
  }
  
  // Update an existing RSVP
  Future<RSVPModel> updateRSVP(int rsvpId, RSVPRequest request) async {
    final token = await _authService.getToken();
    
    final response = await http.put(
      Uri.parse('$url/RSVP/$rsvpId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );
    
    if (response.statusCode == 200) {
      return RSVPModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update RSVP: ${response.body}');
    }
  }
  
  // Delete an RSVP
  Future<bool> deleteRSVP(int rsvpId) async {
    final token = await _authService.getToken();
    
    final response = await http.delete(
      Uri.parse('$url/RSVP/$rsvpId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    return response.statusCode == 204;
  }
  
  // Get RSVP by ID
  Future<RSVPModel> getRSVPById(int rsvpId) async {
    final token = await _authService.getToken();
    
    final response = await http.get(
      Uri.parse('$url/RSVP/$rsvpId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      return RSVPModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get RSVP: ${response.body}');
    }
  }
  
  // Get current user's RSVP for a specific event
  Future<RSVPModel?> getUserEventRSVP(int eventId) async {
    final token = await _authService.getToken();
    
    try {
      final response = await http.get(
        Uri.parse('$url/RSVP/event/$eventId/user'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        return RSVPModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        // No RSVP found for this user and event
        return null;
      } else {
        throw Exception('Failed to get user event RSVP: ${response.body}');
      }
    } catch (e) {
      // If 404 error occurs, return null instead of throwing an exception
      if (e.toString().contains('404')) {
        return null;
      }
      rethrow;
    }
  }
  
  // Get all RSVPs for a specific event
  Future<List<RSVPModel>> getEventRSVPs(int eventId) async {
    final token = await _authService.getToken();
    
    final response = await http.get(
      Uri.parse('$url/RSVP/event/$eventId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => RSVPModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get event RSVPs: ${response.body}');
    }
  }
  
  // Get all RSVPs for the current user
  Future<List<RSVPModel>> getUserRSVPs() async {
    final token = await _authService.getToken();
    
    final response = await http.get(
      Uri.parse('$url/RSVP/user'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => RSVPModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get user RSVPs: ${response.body}');
    }
  }
  
  // Get RSVP counts for a specific event
  Future<RSVPCounts> getEventRSVPCounts(int eventId) async {
    final token = await _authService.getToken();
    
    final response = await http.get(
      Uri.parse('$url/RSVP/event/$eventId/counts'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      return RSVPCounts.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get event RSVP counts: ${response.body}');
    }
  }
}