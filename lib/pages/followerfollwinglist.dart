import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_event_frontend/pages/others_profile.dart';

class FollowerFollowingListPage extends StatefulWidget {
  final List usernames;
  final List images;
  final String title;
  final List userId;

  const FollowerFollowingListPage({
    super.key,
    required this.usernames,
    required this.images,
    required this.title,
    required this.userId,
  });

  @override
  State<FollowerFollowingListPage> createState() =>
      _FollowerFollowingListPageState();
}

class _FollowerFollowingListPageState extends State<FollowerFollowingListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#4a43ec"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: widget.usernames.isEmpty
          ? const Center(child: Text("No users to show"))
          : ListView.builder(
              itemCount: widget.usernames.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OthersProfile(
                            selectedId: widget.userId[index],
                            username: widget.usernames[index],
                            base64Image: widget.images[index],
                          ),
                        ),
                      );
                    },
                    child: UserCard(
                      username: widget.usernames[index],
                      imageUrl: widget.images[index],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class UserCard extends StatefulWidget {
  final String username;
  final String imageUrl;

  const UserCard({
    super.key,
    required this.username,
    required this.imageUrl,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Uint8List? imageBytes;
  void loadImage() {
    setState(() {
      if (widget.imageUrl.isNotEmpty) {
        imageBytes = base64Decode(widget.imageUrl);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
          backgroundImage: widget.imageUrl.isNotEmpty
              ? MemoryImage(base64Decode(widget.imageUrl))
              : null,
          backgroundColor: Colors.grey[
              300], // optional: shows a light grey background if image is null
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
