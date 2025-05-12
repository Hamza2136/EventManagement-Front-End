// Future<Map<String, dynamic>> getMessages(String receiverId) async {
  //   final token = await storage.read(key: 'auth_token');
  //   final response = await http.get(
  //     Uri.parse('$apiUrl/messages/$receiverId'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return {
  //       'messages': data['messages'] ?? [],
  //     };
  //   } else {
  //     throw Exception('Failed to load messages: ${response.statusCode}');
  //   }
  // }