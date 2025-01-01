import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smart_event_frontend/pages/invite_friend_screen.dart';

class EventDetails extends StatefulWidget {
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final String attendees;

  const EventDetails({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.attendees,
  });

  @override
  State<StatefulWidget> createState() {
    return EventDetailsState();
  }
}

class EventDetailsState extends State<EventDetails> {
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
                  imageProvider: NetworkImage(widget.imageUrl),
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
              icon: const Icon(
                Icons.bookmark_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {},
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
                        image: NetworkImage(widget.imageUrl),
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
                          color: HexColor('#dfdcd7'),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage('images/profile.jpg'),
                            ),
                            const CircleAvatar(
                              backgroundImage: AssetImage('images/profile.jpg'),
                            ),
                            const CircleAvatar(
                              backgroundImage: AssetImage('images/profile.jpg'),
                            ),
                            Text(
                              widget.attendees,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
                                    child: InviteFriendPage(),
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
                              child: const Text('Invite'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Text(
                          widget.title, // Directly access the title from widget
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
                          color: HexColor('#dfdcd7'),
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
                              Text('${widget.date} | 4:00 PM - 9:00 PM'), //
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          color: HexColor('#dfdcd7'),
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
                              Text(widget.location),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          color: HexColor('#dfdcd7'),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/profile.jpg'),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              const Text('Ashfak Sayem'),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#4a43ec"),
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Follow'),
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
                      const Padding(
                        padding: EdgeInsets.only(
                            right: 16, left: 5, top: 16, bottom: 16),
                        child: Text(
                          'Enjoy your favorite cars and have a great time with your friends and family. Food from local food trucks will be available. Enjoy your favorite cars and have a great time with your friends and family. Food from local food trucks will be available. Enjoy your favorite cars and have a great time with your friends and family. Food from local food trucks will be available.',
                          style: TextStyle(
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
          Positioned(
            bottom: screenHeight * 0.02,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: HexColor("#4a43ec"),
                foregroundColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Buy Ticket \$120',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
