import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event_frontend/models/event_model.dart';
import 'package:smart_event_frontend/pages/invite_friend_screen.dart';
import 'package:smart_event_frontend/pages/main_screen.dart';
import 'package:smart_event_frontend/pages/others_profile.dart';
import 'package:smart_event_frontend/pages/rsvp_event_details.dart';
import 'package:smart_event_frontend/pages/update_event.dart';
import 'package:smart_event_frontend/services/bookmark_service.dart';
import 'package:smart_event_frontend/services/event_service.dart';

class EventDetails extends StatefulWidget {
  final EventModel event;
  const EventDetails({super.key, required this.event});

  @override
  State<StatefulWidget> createState() {
    return EventDetailsState();
  }
}

class EventDetailsState extends State<EventDetails> {
  final storage = const FlutterSecureStorage();
  final EventService _eventService = EventService();
  final BookmarkService _bookmarkService = BookmarkService();
  bool _isBookmarked = false;
  bool _isLoading = true;
  String currentUserId = "";
  String? userRole = "";

  String formatDate(String rawDate) {
    final dateTime = DateTime.parse(rawDate);
    return DateFormat('EEE, MMM d yyyy - h:mm a').format(dateTime);
  }

  Future<void> _toggleBookmark() async {
    try {
      final bookmarkDto = {
        'userId': currentUserId,
        'eventId': widget.event.id,
      };

      if (_isBookmarked) {
        await _bookmarkService.removeBookmark(bookmarkDto);
      } else {
        await _bookmarkService.addBookmark(bookmarkDto);
      }

      setState(() {
        _isBookmarked = !_isBookmarked;
      });
    } catch (e) {
      print('Error toggling bookmark: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadCurrentUserId().then((_) {
      _checkBookmarkStatus();
    });
    loadRole();
  }

  Future<void> loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      final Map<String, dynamic> json = jsonDecode(userData);
      setState(() {
        currentUserId = json['id'];
        print("Current user ID loaded: $currentUserId");
      });
    }
  }
   Future<void> loadRole() async {
    userRole = await storage.read(key: 'role');
  }

  Future<void> _checkBookmarkStatus() async {
    if (currentUserId.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      print(
          "Checking bookmark status for user: $currentUserId and event: ${widget.event.id}");
      final isBookmarked =
          await _bookmarkService.checkBookmark(currentUserId, widget.event.id);
      setState(() {
        _isBookmarked = isBookmarked;
        _isLoading = false;
      });
      print("Bookmark status: $_isBookmarked");
    } catch (e) {
      print('Error checking bookmark status: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showFullScreenImage(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black.withOpacity(0.7),
          body: Stack(
            children: [
              Center(
                child: PhotoView(
                  imageProvider: NetworkImage(widget.event.imageUrl),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.05,
                left: screenWidth * 0.4,
                right: screenWidth * 0.4,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Event Details",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
            IconButton(
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(
                      _isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                      color: Colors.white,
                      size: 30,
                    ),
              onPressed: _isLoading ? null : _toggleBookmark,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _showFullScreenImage(context);
                  },
                  child: Container(
                    height: screenHeight * 0.45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.event.imageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          color: HexColor('#eef0f7'),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RSVPDetailScreen(event: widget.event),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#4a43ec"),
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('RSVP Event'),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                  ),
                                  builder: (context) => SizedBox(
                                    height: screenHeight * 0.8,
                                    child: InviteFriendPage(
                                        eventId: widget.event.id),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#4a43ec"),
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Invite Friend'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Text(
                          widget.event.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.06,
                        decoration: BoxDecoration(
                          color: HexColor('#eef0f7'),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: HexColor("#4a43ec"),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Text(formatDate(widget.event.date)), //
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          color: HexColor('#eef0f7'),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: HexColor("#4a43ec"),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Expanded(
                                child: Text(
                                  widget.event.location,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.06,
                        decoration: BoxDecoration(
                          color: HexColor('#eef0f7'),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.monetization_on,
                                color: HexColor("#4a43ec"),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Text(
                                'Price: ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(widget.event.cost)}', // Format price as currency
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          color: HexColor('#eef0f7'),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    widget.event.organizerPicture.isNotEmpty
                                        ? MemoryImage(base64Decode(
                                            widget.event.organizerPicture))
                                        : null,
                                backgroundColor: Colors.grey[
                                    300], // optional: shows a light grey background if image is null
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Text(widget.event.organizerName),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OthersProfile(
                                        selectedId: widget.event.organizerId,
                                        username: widget.event.organizerName,
                                        base64Image:
                                            widget.event.organizerPicture,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#4a43ec"),
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('View Profile'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      const Row(
                        children: [
                          Text(
                            'About Event',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 16, left: 5, top: 16, bottom: 16),
                        child: Text(
                          widget.event.description,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.1),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (currentUserId == widget.event.organizerId || userRole == "Admin")
            Positioned(
              bottom: screenHeight * 0.02,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UpdateEvent(event: widget.event),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Edit Event',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this event?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            await _eventService.deleteEvent(widget.event.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Event deleted successfully!')),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()),
                              (route) => false,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Delete Event',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            )
          // else
          //   Positioned(
          //     bottom: screenHeight * 0.02,
          //     left: screenWidth * 0.05,
          //     right: screenWidth * 0.05,
          //     child: ElevatedButton(
          //       onPressed: () {
          //         // Handle buy ticket logic here
          //       },
          //       style: ElevatedButton.styleFrom(
          //         padding: const EdgeInsets.symmetric(vertical: 16),
          //         backgroundColor: HexColor("#4a43ec"),
          //         foregroundColor: Colors.white,
          //         elevation: 5,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //       ),
          //       child: const Text(
          //         'Buy Ticket \$120',
          //         style: TextStyle(fontSize: 20),
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }
}
