// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_event_frontend/url.dart';

class FollowService {
  final String apiUrl = '$url/Follow';
  final storage = const FlutterSecureStorage();

  Future<List> getFollowers(String userId) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$apiUrl/followers/$userId"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      throw Exception('Failed to load Followers: ${response.statusCode}');
    }
  }

  Future<List> getFollowing(String userId) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$apiUrl/following/$userId"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      throw Exception('Failed to load Following: ${response.statusCode}');
    }
  }

  Future<void> followUser(String followerId, String followingId) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.post(
      Uri.parse("$apiUrl/follow"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'followerId': followerId,
        'followingId': followingId,
      }),
    );
    if (response.statusCode == 200) {
      print("Follow Success");
    } else {
      try {
        final errorData = jsonDecode(response.body);
        print("Failed to Follow User: ${errorData['message']}");
        throw Exception("Failed to Follow User: ${errorData['message']}");
      } catch (e) {
        throw Exception("Failed to Follow User: ${response.body}");
      }
    }
  }

  Future<void> unfollowUser(String followerId, String followingId) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.delete(
      Uri.parse("$apiUrl/unfollow"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'followerId': followerId,
        'followingId': followingId,
      }),
    );
    if (response.statusCode == 200) {
      print("Unfollow Successfully");
    } else {
      try {
        final errorData = jsonDecode(response.body);
        print("Failed to Unfollow User: ${errorData['message']}");
        throw Exception("Failed to Unfollow User: ${errorData['message']}");
      } catch (e) {
        throw Exception("Failed to Unfollow User: ${response.body}");
      }
    }
  }

  Future<void> followBackUser(String followerId, String followingId) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse("$apiUrl/follow-back/$followerId/$followingId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'followerId': followerId,
        'followingId': followingId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to Follow Back User: ${response.statusCode}');
    }
  }

  Future<bool> isMutuallyFollowing(
      String currentUserId, String otherUserId) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$apiUrl/is-mutually-following/$currentUserId/$otherUserId"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('isMutuallyFollowing')) {
        return data['isMutuallyFollowing'] as bool;
      } else {
        throw Exception(
            'Invalid API response: Missing "isMutuallyFollowing" key');
      }
    } else {
      throw Exception(
          'Failed to check follower status. Server responded with: ${response.statusCode}');
    }
  }

  Future<bool> isFollower(String currentUserId, String otherUserId) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.get(
      Uri.parse('$apiUrl/is-follower/$currentUserId/$otherUserId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('isFollower')) {
        return data['isFollower'] as bool;
      } else {
        throw Exception('Invalid API response: Missing "isFollower" key');
      }
    } else {
      throw Exception(
          'Failed to check follower status. Server responded with: ${response.statusCode}');
    }
  }

  Future<bool> isBeingFollowed(String currentUserId, String otherUserId) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$apiUrl/is-being-followed/$currentUserId/$otherUserId"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('isBeingFollowed')) {
        return data['isBeingFollowed'] as bool;
      } else {
        throw Exception('Invalid API response: Missing "isBeingFollowed" key');
      }
    } else {
      throw Exception(
          'Failed to check follower status. Server responded with: ${response.statusCode}');
    }
  }
}
