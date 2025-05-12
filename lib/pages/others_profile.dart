// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event_frontend/pages/chat_screen.dart';
import 'package:smart_event_frontend/pages/followerfollwinglist.dart';
import 'package:smart_event_frontend/services/follow_service.dart';

class OthersProfile extends StatefulWidget {
  final String selectedId;
  final String username;
  final String base64Image;

  const OthersProfile({
    required this.selectedId,
    required this.username,
    required this.base64Image,
    super.key,
  });

  @override
  State<OthersProfile> createState() => _OthersProfileState();
}

class _OthersProfileState extends State<OthersProfile> {
  final FollowService _followService = FollowService();
  final storage = const FlutterSecureStorage();
  Uint8List? imageBytes;

  List followers = [];
  List following = [];
  List<Map<String, dynamic>> followerslist = [];
  List<Map<String, dynamic>> followinglist = [];

  bool isLoading = true;
  bool isFollower = false;
  String currentUserId = "";
  final List<Map<String, String>> events = [
    {
      "image": "images/noevent.png",
      "title": "A virtual evening of smooth jazz",
      "date": "1st May - Sat - 2:00 PM"
    },
    {
      "image": "images/noevent.png",
      "title": "Jo malone london’s mother’s day",
      "date": "1st May - Sat - 2:00 PM"
    },
    {
      "image": "images/noevent.png",
      "title": "Women's leadership conference",
      "date": "1st May - Sat - 2:00 PM"
    },
    {
      "image": "images/noevent.png",
      "title": "International kids safe parents night out",
      "date": "1st May - Sat - 2:00 PM"
    },
    {
      "image": "images/noevent.png",
      "title": "International gala music festival",
      "date": "1st May - Sat - 2:00 PM"
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadFollowData();
    loadUserId();
    loadImage();
  }

  void loadImage() {
    setState(() {
      if (widget.base64Image.isNotEmpty) {
        imageBytes = base64Decode(widget.base64Image);
      }
    });
  }
  
  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');

    if (userData != null) {
      final Map<String, dynamic> json = jsonDecode(userData);
      setState(() {
        currentUserId = json['id'];
      });
    }
  }

  Future<void> _loadFollowData() async {
    setState(() {
      isLoading = true;
    });

    try {
      followers = await _followService.getFollowers(widget.selectedId);
      following = await _followService.getFollowing(widget.selectedId);
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
      isFollower =
          await _followService.isFollower(currentUserId, widget.selectedId);
    } catch (e) {
      print('Error loading follow data: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _toggleFollow() async {
    setState(() => isLoading = true);
    if (isFollower) {
      await _followService.unfollowUser(currentUserId, widget.selectedId);
    } else {
      await _followService.followUser(currentUserId, widget.selectedId);
    }
    await _loadFollowData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#4a43ec"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: screenHeight * 0.01),
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      imageBytes != null ? MemoryImage(imageBytes!) : null,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  widget.username,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeight * 0.01),
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
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (currentUserId == widget.selectedId)
                      ElevatedButton.icon(
                        onPressed: () {
                          // Placeholder: You can add functionality here later
                        },
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          "Edit Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                    else ...[
                      ElevatedButton.icon(
                        onPressed: _toggleFollow,
                        icon: Icon(
                          isFollower ? Icons.person_off : Icons.person_add_alt,
                          color: Colors.white,
                        ),
                        label: Text(
                          isFollower ? "Unfollow" : "Follow",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isFollower ? Colors.red : Colors.blue,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      if (isFollower)
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    receiverId: widget.selectedId,
                                    receiverName: widget.username),
                              ),
                            );
                          },
                          icon: const Icon(Icons.message_outlined,
                              color: Colors.blue),
                          label: const Text("Messages",
                              style: TextStyle(color: Colors.blue)),
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                    ]
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      const TabBar(
                        indicatorColor: Colors.blue,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: "ABOUT"),
                          Tab(text: "EVENT"),
                          Tab(text: "REVIEWS"),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.38,
                        child: TabBarView(
                          children: [
                            const SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ),
                            ),
                            ListView.builder(
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: EventCard(
                                    image: events[index]["image"]!,
                                    title: events[index]["title"]!,
                                    date: events[index]["date"]!,
                                  ),
                                );
                              },
                            ),
                            ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                _buildReviewTile(
                                  name: "Rocks Velkeijnen",
                                  date: "10 Feb",
                                  review:
                                      "Cinemas is the ultimate experience to see new movies in Gold Class or Vmax. Find a cinema near you.",
                                  rating: 5,
                                  avatarUrl: "images/profile.jpg",
                                ),
                                const SizedBox(height: 16),
                                _buildReviewTile(
                                  name: "Angelina Zolly",
                                  date: "10 Feb",
                                  review:
                                      "Cinemas is the ultimate experience to see new movies in Gold Class or Vmax. Find a cinema near you.",
                                  rating: 5,
                                  avatarUrl: "images/profile.jpg",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

class EventCard extends StatelessWidget {
  final String image;
  final String title;
  final String date;

  const EventCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            image,
            width: 60,
            height: 60,
            fit: BoxFit.fill,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          date,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

Widget _buildReviewTile({
  required String name,
  required String date,
  required String review,
  required int rating,
  required String avatarUrl,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(avatarUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    rating,
                    (index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  review,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
