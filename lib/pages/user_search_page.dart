import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_event_frontend/pages/others_profile.dart';
import 'package:smart_event_frontend/services/searchUser_service.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return UserSearchScreenState();
  }
}

class UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _users = [];

  // Trigger search as user types
  void _searchUsers() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      searchUsersByQuery(query).then((users) {
        setState(() {
          _users = users;
        });
      });
    } else {
      setState(() {
        _users = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#4a43ec"),
        // leading: Padding(padding: EdgeInsets.only(left: 5)),
        
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.01,
            ),
            SizedBox(
              width: screenWidth * 0.9,
              child: TextField(
                onChanged: (_) => _searchUsers(),
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search Username...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OthersProfile(
                                    selectedId: _users[index].id,
                                    username: _users[index].userName,
                                    base64Image: _users[index].profilePicture,
                                  )));
                    },
                    child: UserCard(
                      picture: _users[index].profilePicture,
                      username: _users[index].userName,
                    ),
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

class UserCard extends StatefulWidget {
  final String picture; // base64 string
  final String username;

  const UserCard({
    super.key,
    required this.picture,
    required this.username,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}
class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (widget.picture.isNotEmpty) {
      try {
        imageBytes = base64Decode(widget.picture);
      } catch (e) {
        imageBytes = null;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: imageBytes != null
              ? MemoryImage(imageBytes)
              : const AssetImage("images/profile.jpg") as ImageProvider,
          backgroundColor: Colors.white,
        ),
        title: Text(
          widget.username,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
