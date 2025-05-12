import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event_frontend/services/notification_service.dart';
import 'package:smart_event_frontend/url.dart';

class InviteFriendPage extends StatefulWidget {
  final int eventId;
  const InviteFriendPage({super.key, required this.eventId});

  @override
  InviteFriendPageState createState() => InviteFriendPageState();
}

class InviteFriendPageState extends State<InviteFriendPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  String currentUserId = "";
  final notificationService = NotificationService();

  final storage = FlutterSecureStorage();
  final String apiUrl = "$url/follow";

  final TextEditingController _searchController = TextEditingController();

  List<dynamic> followers = [];
  List<dynamic> following = [];

  List<dynamic> filteredFollowers = [];
  List<dynamic> filteredFollowing = [];

  List<bool> selectedFollowers = [];
  List<bool> selectedFollowing = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    _searchController.addListener(_filterLists);

    init();
  }

  Future<void> init() async {
    await loadCurrentUserId();
    await loadFriends();
  }

  Future<void> loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      final Map<String, dynamic> json = jsonDecode(userData);
      currentUserId = json['id'].toString();
    }
  }

  Future<List> getFollowers(String userId, String token) async {
    final response = await http.get(
      Uri.parse("$url/Follow/followers/$userId"),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      throw Exception('Failed to load Followers');
    }
  }

  Future<List> getFollowing(String userId, String token) async {
    final response = await http.get(
      Uri.parse("$url/Follow/following/$userId"),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      throw Exception('Failed to load Following');
    }
  }

  Future<void> loadFriends() async {
    try {
      final token = await storage.read(key: 'auth_token');
      if (token == null || currentUserId.isEmpty) {
        throw Exception("Token or User ID not found");
      }

      final fetchedFollowers = await getFollowers(currentUserId, token);
      final fetchedFollowing = await getFollowing(currentUserId, token);

      setState(() {
        followers = fetchedFollowers;
        following = fetchedFollowing;

        filteredFollowers = List.from(followers);
        filteredFollowing = List.from(following);

        selectedFollowers = List.filled(followers.length, false);
        selectedFollowing = List.filled(following.length, false);
        isLoading = false;
      });
    } catch (e) {
      print("Error loading friends: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterLists() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredFollowers = followers
          .where((f) => (f['userName'] ?? '').toLowerCase().contains(query))
          .toList();

      filteredFollowing = following
          .where((f) => (f['userName'] ?? '').toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Invite Friend",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.9,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search...",
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
              const SizedBox(height: 10),
              isLoading
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : Expanded(
                      child: ListView(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Followers",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...filteredFollowers.asMap().entries.map((entry) {
                            int index = followers
                                .indexOf(entry.value); // get original index
                            var friend = entry.value;
                            return buildFriendTile(
                                friend, selectedFollowers[index], (val) {
                              setState(() {
                                selectedFollowers[index] = val;
                              });
                            });
                          }).toList(),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Following",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...filteredFollowing.asMap().entries.map((entry) {
                            int index = following
                                .indexOf(entry.value); // get original index
                            var friend = entry.value;
                            return buildFriendTile(
                                friend, selectedFollowing[index], (val) {
                              setState(() {
                                selectedFollowing[index] = val;
                              });
                            });
                          }).toList(),
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: (selectedFollowers.contains(true) ||
                          selectedFollowing.contains(true))
                      ? () async {
                          try {
                            // Send invites to selected followers
                            for (int i = 0; i < selectedFollowers.length; i++) {
                              if (selectedFollowers[i]) {
                                final userId = followers[i]['id'].toString();
                                await notificationService
                                    .sendEventInviteNotification(
                                        userId, widget.eventId);
                              }
                            }

                            // Send invites to selected following
                            for (int i = 0; i < selectedFollowing.length; i++) {
                              if (selectedFollowing[i]) {
                                final userId = following[i]['id'].toString();
                                await notificationService
                                    .sendEventInviteNotification(
                                        userId, widget.eventId);
                              }
                            }

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Invites sent successfully')),
                              );
                            }
                          } catch (e) {
                            print("Invite error: $e");
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Failed to send invites: $e')),
                              );
                            }
                          }
                        }
                      : null,
                  child: const Text("INVITE"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFriendTile(
    Map<String, dynamic> friend,
    bool isSelected,
    Function(bool) onChanged,
  ) {
    String base64Image = friend['profilePicture'] ?? '';
    ImageProvider imageProvider;

    if (base64Image.isNotEmpty) {
      try {
        imageProvider = MemoryImage(base64Decode(base64Image));
      } catch (_) {
        imageProvider = const AssetImage("images/profile.jpg");
      }
    } else {
      imageProvider = const AssetImage("images/profile.jpg");
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        backgroundImage: imageProvider,
      ),
      title: Text(friend['userName'] ?? "No Name"),
      subtitle: Text(friend['email'] ?? ""),
      trailing: Checkbox(
        shape: const CircleBorder(),
        value: isSelected,
        onChanged: (bool? value) {
          onChanged(value ?? false);
        },
      ),
    );
  }
}
