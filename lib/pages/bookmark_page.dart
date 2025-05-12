// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event_frontend/models/bookmark_model.dart';
import 'package:smart_event_frontend/pages/events.dart';
import 'package:smart_event_frontend/services/bookmark_service.dart';
import 'package:smart_event_frontend/pages/event_details_page.dart'; // Make sure to import this

class BookmarksPage extends StatefulWidget {
  final String userId;

  const BookmarksPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BookmarksPageState();
}

class BookmarksPageState extends State<BookmarksPage> {
  late Future<List<BookmarkData>> _bookmarksFuture;

  String formatDate(String rawDate) {
    final dateTime = DateTime.parse(rawDate);
    return DateFormat('EEE, MMM d yyyy - h:mm a').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _bookmarksFuture = _loadBookmarks();
  }

  Future<List<BookmarkData>> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData == null) {
      throw Exception("User not logged in");
    }

    final Map<String, dynamic> json = jsonDecode(userData);
    final userId = json['id'];

    final bookmarkService = BookmarkService();
    final response = await bookmarkService.getBookmarksByUser(userId);
    print("Bookmarks response: ${jsonEncode(response)}"); // For debugging
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#4a43ec"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Bookmarks",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<BookmarkData>>(
        future: _bookmarksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Loading bookmarks..."); // For debugging
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(
                "Error loading bookmarks: ${snapshot.error}"); // For debugging
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print("No bookmarks found"); // For debugging
            return const Center(
              child: Text(
                "No bookmarks yet",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            final bookmarks = snapshot.data!;
            print("Loaded ${bookmarks.length} bookmarks"); // For debugging
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                final event = bookmark.event;

                // Parse date for formatting
                String formattedDate;
                try {
                  formattedDate = formatDate(event.startDate);
                } catch (e) {
                  print("Error parsing date: $e");
                  formattedDate = "Date unavailable";
                }

                return SizedBox(
                  width: screenWidth * 0.9,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Events(),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image section
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            child: Image.network(
                              event.imageUrl,
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                print("Error loading image: $error");
                                return Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported,
                                      color: Colors.grey),
                                );
                              },
                            ),
                          ),

                          // Event details section
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    event.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          event.location,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (event.cost > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        "Cost: \$${event.cost.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
