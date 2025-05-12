// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event_frontend/pages/followerfollwinglist.dart';
import 'package:smart_event_frontend/services/follow_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final FollowService _followService = FollowService();
  final storage = const FlutterSecureStorage();

  List followers = [];
  List following = [];
  List<Map<String, dynamic>> followerslist = [];
  List<Map<String, dynamic>> followinglist = [];
  bool isLoading = true;
  String currentUserId = "";
  String base64Image = '';
  String username = '';
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    _loadFollowData();
    loadUserId();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');

    if (userData != null) {
      final Map<String, dynamic> json = jsonDecode(userData);
      setState(() {
        currentUserId = json['id'];
        base64Image = json['profilePicture'] ?? '';
        username = json['userName'] ?? '';

        if (base64Image.isNotEmpty) {
          imageBytes = base64Decode(base64Image);
        }
      });
    }
  }

  Future<void> _loadFollowData() async {
    setState(() {
      isLoading = true;
    });

    try {
      followers = await _followService.getFollowers(currentUserId);
      following = await _followService.getFollowing(currentUserId);
      followerslist = followers.map((item) {
        return {
          'userName': item['userName'],
          'userId': item['id'],
          'profilePicture': item['profilePicture'],
        };
      }).toList();

      followinglist = following.map((item) {
        return {
          'userName': item['userName'],
          'userId': item['id'],
          'profilePicture': item['profilePicture'],
        };
      }).toList();
    } catch (e) {
      print('Error loading follow data: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#4a43ec"),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  imageBytes != null ? MemoryImage(imageBytes!) : null,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              username,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: _buildFollowCount("Following", following.length),
                  onTap: () {
                    List<String> followingUsernames = followinglist
                        .map((item) => item['userName'] as String)
                        .toList();
                    List<String> followingImages = followinglist
                        .map((item) => item['profilePicture'] as String)
                        .toList();
                    List<String> followingId = followinglist
                        .map((item) => item['userId'] as String)
                        .toList();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowerFollowingListPage(
                          usernames: followingUsernames,
                          images: followingImages,
                          title: "Following",
                          userId: followingId,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: screenWidth * 0.07),
                GestureDetector(
                  child: _buildFollowCount("Followers", followers.length),
                  onTap: () {
                    List<String> followerUsernames = followerslist
                        .map((item) => item['userName'] as String)
                        .toList();
                    List<String> followerImages = followerslist
                        .map((item) => item['profilePicture'] as String)
                        .toList();
                    List<String> followerId = followerslist
                        .map((item) => item['userId'] as String)
                        .toList();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowerFollowingListPage(
                          usernames: followerUsernames,
                          images: followerImages,
                          title: "Followers",
                          userId: followerId,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                elevation: 5,
                foregroundColor: HexColor("#4a43ec"),
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About Me',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Text(
              'Enjoy your favorite dish and a lovely time with friends and family. Food from local food trucks will be available for purchase. Read More',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Interest',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    print("Button Pressed");
                  },
                  icon: const Icon(Icons.edit_square, size: 20),
                  label: const Text(
                    'Change',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                categoryChip('Games Online', Colors.blue),
                categoryChip('Concert', Colors.red),
                categoryChip('Music', Colors.orange),
                categoryChip('Art', Colors.purple),
                categoryChip('Movie', Colors.green),
                categoryChip('Others', Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildFollowCount(String label, int count) {
    return Column(
      children: [
        Text("$count",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
