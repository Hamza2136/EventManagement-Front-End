// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:smart_event_frontend/services/searchUser_service.dart';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  _SearchUsersScreenState createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final TextEditingController _controller = TextEditingController();
  List<User> _users = [];

  // Trigger search as user types
  void _searchUsers() {
    String query = _controller.text.trim();
    if (query.isNotEmpty) {
      searchUsersByQuery(query).then((users) {
        setState(() {
          _users = users;
        });
      });
    } else {
      setState(() {
        _users = []; // Clear results if input is empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Users')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Search Users'),
              onChanged: (_) => _searchUsers(), // Trigger search on change
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_users[index].userName),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
