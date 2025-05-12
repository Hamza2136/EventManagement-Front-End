import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event_frontend/models/event_model.dart';
import 'package:smart_event_frontend/pages/event_details_page.dart';
import 'package:smart_event_frontend/pages/others_profile.dart';
import 'package:smart_event_frontend/services/notification_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return NotificationsPageState();
  }
}

class NotificationsPageState extends State<NotificationsPage> {
  final storage = const FlutterSecureStorage();
  String currentUserId = "";
  final NotificationService _notificationService = NotificationService();
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      List response = await _notificationService.getNotifications();

      setState(() {
        notifications = response.map((notif) {
          return {
            'notificationId': notif['id'],
            'message': notif['message'],
            'senderId': notif['fromUserId'],
            "senderName": notif['fromUserName'],
            'profilePicture': base64Decode(notif['fromUserProfilePicture']),
            'time': _formatTimestamp(notif['createdAt']),
            'hasAction': notif['type'] == "EventInvite" ||
                notif['type'] == "EventCreation",
            'type': notif['type'],
            'isRead': notif['isRead'],
            'event': notif['event']
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  String _formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hr ago";
    } else {
      return dateTime.toLocal().toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
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
        title: const Text(
          "Notification",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader
          : hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Failed to load notifications",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchNotifications,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return GestureDetector(
                      // onTap: () {
                      //   _notificationService
                      //       .markAsRead(notification['notificationId']);
                      //   if (notification['type'] == "Follow") {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => OthersProfile(
                      //                 selectedId: notification['senderId'],
                      //                 username: notification['senderName'],
                      //                 imageUrl: notification['image'])));
                      //   }
                      // },
                      child: Card(
                        color: notification['isRead']
                            ? Colors.white
                            : Colors.grey[300],
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    notification['profilePicture'] != null
                                        ? MemoryImage(
                                            notification['profilePicture'])
                                        : null,
                                backgroundColor: HexColor("#4a43ec"),
                                child: notification['profilePicture'] == null
                                    ? Text(
                                        notification['senderName'][0]
                                            .toUpperCase(), // Show first letter
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      )
                                    : null, // Or any default background color
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification['senderName'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      notification['message'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      notification['time'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    if (notification['hasAction'] &&
                                        notification['isRead'] == false)
                                      Row(
                                        children: [
                                          OutlinedButton(
                                            onPressed: () async {
                                              await _notificationService
                                                  .markAsRead(notification[
                                                      'notificationId']);
                                              setState(() {
                                                notifications[index]['isRead'] =
                                                    true;
                                              });
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: HexColor("#4a43ec")),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text('Ignore'),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventDetails(
                                                    event: EventModel.fromJson(notification['event']),
                                                  ),
                                                ),
                                              );
                                              await _notificationService
                                                  .markAsRead(notification[
                                                      'notificationId']);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor:
                                                  HexColor("#4a43ec"),
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('View'),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
