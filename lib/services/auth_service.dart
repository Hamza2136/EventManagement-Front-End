// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:smart_event_frontend/url.dart';

class AuthService {
  final String baseUrl = '$url/userAccount';
  final storage = const FlutterSecureStorage();
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  Future<bool> signup(
    String username,
    String email,
    String password,
    File profilePicture,
    String role,
  ) async {
    final uri = Uri.parse('$baseUrl/create');

    String? deviceToken = await FirebaseMessaging.instance.getToken();

    var request = http.MultipartRequest('POST', uri)
      ..fields['username'] = username
      ..fields['email'] = email
      ..fields['password'] = password
      ..fields['role'] = role;

    if (deviceToken != null) {
      request.fields['deviceToken'] = deviceToken;
    }

    if (profilePicture.path.isNotEmpty) {
      var picture = await http.MultipartFile.fromPath(
        'profilePicture',
        profilePicture.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(picture);
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Signup successful: $responseBody');
        return true;
      } else {
        print('Signup failed: $responseBody');
        return false;
      }
    } catch (e) {
      print('Error during signup: $e');
      return false;
    }
  }

  // Store token securely
  Future<void> storeToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  Future<void> storeDeviceToken(String token) async {
    await storage.write(key: 'device_token', value: token);
  }

  Future<void> storeRole(String role) async {
    await storage.write(key: 'role', value: role);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<String?> getDeviceToken() async {
    return await storage.read(key: 'device_token');
  }

  Future<String?> getRole() async {
    return await storage.read(key: 'role');
  }

  // Remove token on logout
  Future<void> logout() async {
    await storage.delete(key: 'auth_token');
  }

  Future<Map<String, dynamic>?> forgotPassword(
      String email, String username) async {
    try {
      final uri =
          Uri.parse('$baseUrl/forgot-password?email=$email&username=$username');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to reset password: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during forgotPassword: $e');
      return null;
    }
  }

  Future<bool> saveDeviceToken(String userId, String deviceToken) async {
    final uri = Uri.parse('$baseUrl/save-device-token');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'deviceToken': deviceToken}),
      );

      if (response.statusCode == 200) {
        print('Device token saved successfully.');
        return true;
      } else {
        print('Failed to save device token: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during saveDeviceToken: $e');
      return false;
    }
  }
}
