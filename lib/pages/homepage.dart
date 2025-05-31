import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_event_frontend/models/event_model.dart';
import 'package:smart_event_frontend/pages/event_details_page.dart';
import 'package:smart_event_frontend/pages/events.dart';
import 'package:smart_event_frontend/pages/shareApp.dart';
import 'package:smart_event_frontend/pages/sidebar.dart';
import 'package:smart_event_frontend/services/event_service.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:developer';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<String> selectedTags = [];
  late Future<List<EventModel>> filteredEvents;

  // Future<void> getCurrentLocation() async {
  //   LocationPermission permission = await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     log("Location permission denied, requesting permission...");
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied ||
  //         permission == LocationPermission.deniedForever) {
  //       log("Location permission still denied.");
  //       return;
  //     }
  //   }

  //   try {
  //     Position currentPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     double latitude = currentPosition.latitude;
  //     double longitude = currentPosition.longitude;
  //     // getCityFromCoordinates(48.8566, 2.3522);
  //   } catch (e) {
  //     log("Error getting location: $e");
  //   }
  // }

// Future<void> getCityFromCoordinates(double latitude, double longitude) async {
//   try {
//     List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude, localeIdentifier: "en");

//     if (placemarks.isNotEmpty) {
//       Placemark place = placemarks.first;

//       String? city = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea;
//       log('City: $city');
//     } else {
//       log('No placemarks found');
//     }
//   } catch (e, stacktrace) {
//     log('Error during reverse geocoding: $e');
//     log('Stacktrace: $stacktrace');
//   }
// }
  String formatDate(String rawDate) {
    final dateTime = DateTime.parse(rawDate);
    return DateFormat('EEE, MMM d yyyy - h:mm a').format(dateTime);
  }

// Check and request notification permission at runtime
  void requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      // Request notification permission
      await Permission.notification.request();
    }
  }

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    filteredEvents = EventService().getAllUpcomingEvents();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: const CustomSidebar(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.19),
        child: AppBar(
          backgroundColor: HexColor("#4a43ec"),
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu_sharp,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                build(context);
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          // Rest of the AppBar code remains the same
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Current Location',
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ],
                ),
                const Text(
                  'Bahawalpur Pakistan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/event_search');
                        },
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.search_sharp,
                                color: Color.fromARGB(255, 224, 209, 209),
                                size: 25,
                                weight: 3,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/event_search');
                              },
                            ),
                            const Text(
                              "| Search",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w300,
                                color: Color.fromARGB(255, 224, 209, 209),
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/event_search');
                        },
                        child: Container(
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                            color: HexColor("#a29ef0"),
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
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/event_search');
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: HexColor("#ffffff"),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                categoryChip('Sports', Colors.red),
                categoryChip('Music', Colors.orange),
                categoryChip('Food', Colors.green),
                categoryChip('Art', HexColor("#4a43ec")),
                // Other category chips
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          sectionTitle('Upcoming Events', onSeeAll: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Events()));
          }),
          SizedBox(height: screenHeight * 0.01),
          FutureBuilder<List<EventModel>>(
            future: filteredEvents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No events found.'));
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: snapshot.data!.map((event) {
                    return Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.01),
                      child: eventCard(context, event: event),
                    );
                  }).toList(),
                ),
              );
            },
          ),

          SizedBox(
            height: screenHeight * 0.01,
          ),
          // Invite Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Invite your friends',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get \$20 for a ticket',
                      style: TextStyle(color: HexColor("#4a43ec")),
                    ),
                  ],
                ),
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
                        height: screenHeight * 0.5,
                        child: const ShareApp(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      foregroundColor: Colors.white,
                      backgroundColor: HexColor("#4a43ec"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: const Text('Share'),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          sectionTitle('Nearby You', onSeeAll: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Events()));
          }),
          SizedBox(height: screenHeight * 0.01),
          FutureBuilder<List<EventModel>>(
            future: filteredEvents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No events found.'));
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: snapshot.data!.map((event) {
                    return Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.01),
                      child: eventCard(context, event: event),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
      // Remove bottom navigation bar from here as it's now handled by MainScreen
    );
  }

  // Utility methods remain the same
  Widget categoryChip(String label, Color color) {
    final isSelected = selectedTags.contains(label);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedTags.remove(label);
            } else {
              selectedTags.add(label);
            }

            if (selectedTags.isEmpty) {
              filteredEvents = EventService().getAllUpcomingEvents();
            } else {
              filteredEvents = EventService().getEventsByTags(selectedTags);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title, {required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text('See All'),
        ),
      ],
    );
  }

  Widget eventCard(BuildContext context, {required EventModel event}) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    DateTime parsedDate = DateTime.parse(event.date);
    String formattedDate = DateFormat('EEE, MMM d - h:mm a').format(parsedDate);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetails(
              event: event,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          width: screenWidth * 0.7,
          height: screenHeight * 0.50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  event.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                          color: HexColor("#4a43ec"),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: const TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                          ),
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
  }
}
