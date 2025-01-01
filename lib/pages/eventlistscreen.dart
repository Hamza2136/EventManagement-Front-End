import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final List<Map<String, String>> events = [
    {
      "date": "Wed, Apr 28 - 5:30 PM",
      "title": "Jo Malone London's Mother’s Day Presents",
      "location": "Radius Gallery • Santa Cruz, CA",
      "imageUrl": "images/noevent.png",
    },
    {
      "date": "Sat, May 1 - 2:00 PM",
      "title": "A Virtual Evening of Smooth Jazz",
      "location": "Lot 13 • Oakland, CA",
      "imageUrl": "images/noevent.png",
    },
    {
      "date": "Sat, Apr 24 - 1:30 PM",
      "title": "Women's Leadership Conference 2021",
      "location": "53 Bush St • San Francisco, CA",
      "imageUrl": "images/noevent.png",
    },
    {
      "date": "Fri, Apr 23 - 6:00 PM",
      "title": "International Kids Safe Parents Night Out",
      "location": "Lot 13 • Oakland, CA",
      "imageUrl": "images/noevent.png",
    },
    {
      "date": "Mon, Jun 21 - 10:00 PM",
      "title": "Collectivity Plays the Music of Jimi",
      "location": "Longboard Margarita Bar",
      "imageUrl": "images/noevent.png",
    },
    {
      "date": "Sun, Apr 25 - 10:15 AM",
      "title": "International Gala Music Festival",
      "location": "36 Guild Street London, UK",
      "imageUrl": "images/noevent.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
              "Events",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {},
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
            )
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return SizedBox(
            width: screenWidth * 0.9,
            child: GestureDetector(
              onTap: () {
                print("${index + 1} card tapped");
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
                    // Event image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      child: Image.asset(
                        event["imageUrl"]!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    // Event details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event date
                            Text(
                              event["date"]!,
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Event title
                            Text(
                              event["title"]!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Event location
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
                                    event["location"]!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
