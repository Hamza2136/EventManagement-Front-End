import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class OthersProfile extends StatefulWidget {
  const OthersProfile({super.key});
  @override
  State<StatefulWidget> createState() {
    return OthersProfileState();
  }
}

class OthersProfileState extends State<OthersProfile> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.01,
          ),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('images/profile.jpg'),
          ),
          SizedBox(height: screenHeight * 0.02),
          const Text(
            "Hamza Abid",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                children: [
                  Text(
                    "350",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Following",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(width: screenWidth * 0.07),
              const Column(
                children: [
                  Text(
                    "346",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Followers",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.person_add_alt,
                  color: Colors.white,
                ),
                label: const Text(
                  "Follow",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.message_outlined, color: Colors.blue),
                label: const Text(
                  "Messages",
                  style: TextStyle(color: Colors.blue),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
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
                            style: TextStyle(fontSize: 14, color: Colors.grey),
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
