import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'name': 'David Silbia',
      'message': "Invite Jo Malone London’s Mother’s",
      'time': 'Just now',
      'hasAction': true,
      'image': 'images/profile.jpg',
    },
    {
      'name': 'Adnan Safi',
      'message': "Started following you",
      'time': '5 min ago',
      'hasAction': false,
      'image': 'images/profile.jpg',
    },
    {
      'name': 'Joan Baker',
      'message': "Invite A virtual Evening of Smooth Jazz",
      'time': '20 min ago',
      'hasAction': true,
      'image': 'images/profile.jpg',
    },
    {
      'name': 'Ronald C. Kinch',
      'message': "Like your events",
      'time': '1 hr ago',
      'hasAction': false,
      'image': 'images/profile.jpg',
    },
    {
      'name': 'Clara Tolson',
      'message': "Join your Event Gala Music Festival",
      'time': '9 hr ago',
      'hasAction': false,
      'image': 'images/profile.jpg',
    },
    {
      'name': 'Jennifer Fritz',
      'message': "Invite you International Kids Safe",
      'time': 'Tue, 5:10 pm',
      'hasAction': true,
      'image': 'images/profile.jpg',
    },
    {
      'name': 'Eric G. Prickett',
      'message': "Started following you",
      'time': 'Wed, 3:30 pm',
      'hasAction': false,
      'image': 'images/profile.jpg',
    },
  ];

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
        title: const Text(
          "Notification",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            color: Colors.white54,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(notification['image']),
                    radius: 30,
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          notification['message'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          notification['time'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        if (notification['hasAction'])
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: HexColor("#4a43ec")),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Reject'),
                              ),
                              SizedBox(width: screenHeight * 0.02),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: HexColor("#4a43ec"),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Accept'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
