import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:smart_event_frontend/models/event_model.dart';
import 'package:smart_event_frontend/pages/event_details_page.dart';
import 'package:smart_event_frontend/pages/filter_page.dart';
import 'package:smart_event_frontend/services/event_service.dart';

class EventSearchScreen extends StatefulWidget {
  const EventSearchScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return EventSearchScreenState();
  }
}

class EventSearchScreenState extends State<EventSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<EventModel> _events = [];
  Map<String, dynamic> _selectedFilters = {};
  final eventService = EventService();

  void _searchEvents() {
  String query = _searchController.text.trim();

  if (query.isEmpty) {
    setState(() {
      _events = [];
    });
    return;
  }

  eventService.searchEvent(query, filters: _selectedFilters).then((events) {
    setState(() {
      _events = events;
    });
  }).catchError((e) {
    print("Error loading events: $e");
    setState(() {
      _events = []; // Clear list on error
    });
  });
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
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => _searchEvents(),
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
                SizedBox(width: screenWidth * 0.02),
                Container(
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                    color: HexColor("#4a43ec"),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.filter_list,
                              color: HexColor('#4a43ec'),
                              size: 15,
                            ),
                            onPressed: () async {
                              final filters = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FilterPage(
                                      selectedFilters: _selectedFilters),
                                ),
                              );
                              if (filters != null) {
                                setState(() {
                                  _selectedFilters = filters;
                                });
                                _searchEvents(); // Apply filters after selection
                              }
                            },
                          ),
                        ),
                        const Text(
                          " Filters",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetails(
                            event: _events[index],
                          ),
                        ),
                      );
                    },
                    child: EventCard(
                      image: _events[index].imageUrl,
                      title: _events[index].title,
                      date: _events[index].date,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatDate(String rawDate) {
  final dateTime = DateTime.parse(rawDate);
  return DateFormat('EEE, MMM d yyyy - h:mm a').format(dateTime);
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
          child: SizedBox(
            width: 60,
            height: 60,
            child: Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 60);
              },
            ),
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
          formatDate(date),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
