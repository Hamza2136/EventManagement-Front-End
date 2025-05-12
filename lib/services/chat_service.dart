// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:smart_event_frontend/url.dart';

class ChatService {
  final String apiUrl = '$url/chat';
  final storage = const FlutterSecureStorage();
  static late HubConnection connection;

  Future<void> initialize() async {
    final token = await storage.read(key: 'auth_token');

    connection = HubConnectionBuilder()
        .withUrl(
          "${simpleUrl}ChatHub",
          options: HttpConnectionOptions(
            accessTokenFactory: () async => '$token',
          ),
        )
        .build();

    await connection.start();
    print('Connected to SignalR');
  }

  Future<List> getUsers() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$apiUrl/users"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  void listenForMessages(Function(String message) onMessageReceived) {
    connection.on("ReceiveMessage", (message) {
      if (message != null && message.isNotEmpty) {
        // Assuming the payload is just the message
        final msg = message[0]?.toString() ?? "No message";
        onMessageReceived(msg); // Send only the message text to the UI
      }
    });
  }

  void stopListening() {
    connection.off("ReceiveMessage");
  }

  Future<void> sendMessage(String receiverId, String message) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse("$apiUrl/send"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'receiverId': receiverId, 'message': message}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getMessages(String receiverId) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$apiUrl/messages/$receiverId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'messages': data['messages'] ?? [],
      };
    } else {
      throw Exception('Failed to load messages: ${response.statusCode}');
    }
  }
}
