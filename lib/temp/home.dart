// import 'package:flutter/material.dart';
// import 'dart:ui';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:smart_event_frontend/pages/add_event.dart';
// import 'package:smart_event_frontend/pages/event_details_page.dart';
// import 'package:smart_event_frontend/pages/events.dart';
// import 'package:smart_event_frontend/pages/notification.dart';
// import 'package:smart_event_frontend/pages/event_search_page.dart';
// import 'package:smart_event_frontend/pages/shareApp.dart';
// import 'package:smart_event_frontend/pages/sidebar.dart';
// import 'package:smart_event_frontend/pages/profile.dart';
// import 'package:smart_event_frontend/pages/user_search_page.dart';
// import 'package:smart_event_frontend/pages/users_list_screen.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return HomePageState();
//   }
// }

// class HomePageState extends State<HomePage> {
//   String _location = "Fetching location...";
//   @override
//   void initState() {
//     super.initState();
//     _setLocation();
//   }

//   Future<Position?> _getCurrentPosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return null;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return null;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return null;
//     }

//     return await Geolocator.getCurrentPosition();
//   }

//   Future<String> _getCityName(Position position) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;
//         return "${place.locality}, ${place.country}";
//       }
//     } catch (e) {
//       // Handle error
//     }
//     return "Location not available";
//   }

//   Future<void> _setLocation() async {
//     final position = await _getCurrentPosition();
//     if (position != null) {
//       final city = await _getCityName(position);
//       setState(() {
//         _location = city;
//       });
//     } else {
//       setState(() {
//         _location = "Location not available";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     // TextEditingController searchController = TextEditingController();
//     return Scaffold(
//       drawer: const CustomSidebar(),
//       appBar: PreferredSize(
//         preferredSize:
//             Size.fromHeight(screenHeight * 0.19), // Adjust height here
//         child: AppBar(
//           backgroundColor: HexColor("#4a43ec"),
//           leading: Builder(builder: (context) {
//             return IconButton(
//               icon: const Icon(
//                 Icons.menu_sharp,
//                 color: Colors.white,
//                 size: 30,
//               ),
//               onPressed: () {
//                 build(context);
//                 Scaffold.of(context).openDrawer();
//               },
//             );
//           }),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 20.0),
//               child: IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const NotificationsPage(),
//                     ),
//                   );
//                 },
//                 icon: const Icon(
//                   Icons.notifications,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(40),
//               bottomRight: Radius.circular(40),
//             ),
//           ),
//           flexibleSpace: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: screenHeight * 0.01,
//                 ),
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Current Location',
//                       style: TextStyle(fontSize: 11, color: Colors.white),
//                     ),
//                     Icon(
//                       Icons.arrow_drop_down,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//                 Text(
//                   _location,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(
//                   height: screenHeight * 0.01,
//                 ),
//                 Expanded(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const EventSearchScreen(),
//                             ),
//                           );
//                         },
//                         child: Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.search_sharp,
//                                 color: Color.fromARGB(255, 224, 209, 209),
//                                 size: 25,
//                                 weight: 3,
//                               ),
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const EventSearchScreen(),
//                                   ),
//                                 );
//                               },
//                             ),
//                             const Text(
//                               "| Search",
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.w300,
//                                 color: Color.fromARGB(255, 224, 209, 209),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const EventSearchScreen(),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           height: screenHeight * 0.06,
//                           decoration: BoxDecoration(
//                             color: HexColor("#a29ef0"),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   height: 30,
//                                   width: 30,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                   child: IconButton(
//                                     icon: Icon(
//                                       Icons.filter_list,
//                                       color: HexColor('#4a43ec'),
//                                       size: 15,
//                                     ),
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               const EventSearchScreen(),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 const Text(
//                                   " Filters",
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w300,
//                                     color: Colors.white,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       backgroundColor: HexColor("#ffffff"),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Category Chips Section
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 categoryChip('Sports', Colors.red),
//                 categoryChip('Music', Colors.orange),
//                 categoryChip('Food', Colors.green),
//                 categoryChip('Art', HexColor("#4a43ec")),
//                 categoryChip('Technology', Colors.purple),
//                 categoryChip('Health', Colors.teal),
//                 categoryChip('Fashion', Colors.pink),
//                 categoryChip('Education', Colors.yellow),
//                 categoryChip('Environment', Colors.lightGreen),
//                 categoryChip('Movies', Colors.cyan),
//                 categoryChip('Business', Colors.indigo),
//                 categoryChip('Travel', Colors.brown),
//                 categoryChip('Gaming', Colors.blueGrey),
//                 categoryChip('Theater', Colors.redAccent),
//                 categoryChip('Literature', Colors.amber),
//                 categoryChip('Science', Colors.greenAccent),
//                 categoryChip('Fitness', Colors.deepOrange),
//                 categoryChip('Charity', Colors.lime),
//                 categoryChip('Photography', Colors.deepPurple),
//                 categoryChip('Dance', Colors.pinkAccent),
//                 categoryChip('Comedy', Colors.lightBlue),
//                 categoryChip('History', Colors.orangeAccent),
//                 categoryChip('Family', Colors.black),
//                 categoryChip('Spirituality', Colors.grey),
//                 categoryChip('Crafts', Colors.yellowAccent),
//                 categoryChip('Animals', Colors.indigoAccent),
//                 categoryChip('Automobiles', Colors.blueGrey),
//                 categoryChip('Adventure', Colors.lightGreenAccent),
//                 categoryChip('Startup', Colors.purpleAccent),
//                 categoryChip('Podcasts', HexColor("#4a43ec")),
//                 categoryChip('Politics', Colors.red),
//                 categoryChip('Nature', Colors.green),
//                 categoryChip('Networking', Colors.tealAccent),
//                 categoryChip('Social', Colors.purple),
//               ],
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.01),

//           // Upcoming Events Section
//           sectionTitle('Upcoming Events', onSeeAll: () {}),
//           SizedBox(height: screenHeight * 0.01),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 eventCard(
//                   context,
//                   date: '10 January',
//                   title: 'International Band Music Concert',
//                   attendees: '+20 Going',
//                   location: '36 Guild Street London, UK',
//                   imageUrl:
//                       'https://i.pinimg.com/736x/d5/da/e6/d5dae69e5b38ec26b49dbb4bee613e58.jpg',
//                 ),
//                 SizedBox(
//                   width: screenWidth * 0.01,
//                 ),
//                 eventCard(
//                   context,
//                   date: '10 JUNE',
//                   title: 'Jo Malone London’s Mother’s Day',
//                   attendees: '+15 Going',
//                   location: 'Radius Gallery, London',
//                   imageUrl:
//                       'https://d3jmn01ri1fzgl.cloudfront.net/photoadking/webp_thumbnail/vintage-car-show-event-flyer-template-kexu4od3c842fd.webp',
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: screenHeight * 0.01,
//           ),
//           // Invite Section
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.lightBlueAccent.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Invite your friends',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Get \$20 for a ticket',
//                       style: TextStyle(color: HexColor("#4a43ec")),
//                     ),
//                   ],
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(10),
//                         ),
//                       ),
//                       builder: (context) => SizedBox(
//                         height: screenHeight * 0.5,
//                         child: const ShareApp(),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                       elevation: 5,
//                       foregroundColor: Colors.white,
//                       backgroundColor: HexColor("#4a43ec"),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       )),
//                   child: const Text('Share'),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: screenHeight * 0.01,
//           ),
//           sectionTitle('Nearby You', onSeeAll: () {}),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 eventCard(
//                   context,
//                   date: '10 JUNE',
//                   title: 'International Band Music Concert',
//                   attendees: '+20 Going',
//                   location: '36 Guild Street London, UK',
//                   imageUrl:
//                       'https://i.pinimg.com/736x/d5/da/e6/d5dae69e5b38ec26b49dbb4bee613e58.jpg',
//                 ),
//                 SizedBox(
//                   width: screenWidth * 0.01,
//                 ), // Add spacing between cards
//                 eventCard(
//                   context,
//                   date: '10 JUNE',
//                   title: 'Jo Malone London’s Mother’s Day',
//                   attendees: '+15 Going',
//                   location: 'Radius Gallery, London',
//                   imageUrl:
//                       'https://d3jmn01ri1fzgl.cloudfront.net/photoadking/webp_thumbnail/vintage-car-show-event-flyer-template-kexu4od3c842fd.webp',
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: SizedBox(
//         height: 40, // Decrease size of the button
//         width: 40,
//         child: FloatingActionButton(
//           onPressed: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => const AddEvent()));
//           },
//           backgroundColor: HexColor("#4a43ec"),
//           foregroundColor: Colors.white,
//           // shape: const CircleBorder(),
//           child: const Icon(Icons.add, size: 20),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//       bottomNavigationBar: SizedBox(
//         height: screenHeight * 0.140, // Set the height of the BottomAppBar
//         child: BottomAppBar(
//           color: Colors.grey[300],
//           shape: const CircularNotchedRectangle(),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(Icons.home),
//                     color: HexColor("#4a43ec"),
//                     iconSize: 30,
//                   ),
//                   Text(
//                     'Home',
//                     style: TextStyle(fontSize: 12, color: HexColor("#4a43ec")),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const UserSearchScreen(),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.explore),
//                     color: Colors.grey,
//                     iconSize: 30,
//                   ),
//                   const Text(
//                     'Explore',
//                     style: TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const Events(),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.event),
//                     color: Colors.grey,
//                     iconSize: 30,
//                   ),
//                   const Text(
//                     'Events',
//                     style: TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => UsersListScreen(),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.map),
//                     color: Colors.grey,
//                     iconSize: 30,
//                   ),
//                   const Text(
//                     'Chat',
//                     style: TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ProfilePage(),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.person),
//                     color: Colors.grey,
//                     iconSize: 30,
//                   ),
//                   const Text(
//                     'Profile',
//                     style: TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget categoryChip(String label, Color color) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 3),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(40),
//         ),
//         child: Text(
//           label,
//           style: const TextStyle(color: Colors.white, fontSize: 14),
//         ),
//       ),
//     );
//   }

//   Widget sectionTitle(String title, {required VoidCallback onSeeAll}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         TextButton(
//           onPressed: onSeeAll,
//           child: const Text('See All'),
//         ),
//       ],
//     );
//   }

//   Widget eventCard(BuildContext context,
//       {required String date,
//       required String title,
//       required String attendees,
//       required String location,
//       required String imageUrl}) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => EventDetails(
//               title: title,
//               imageUrl: imageUrl,
//               location: location,
//               date: date,
//               attendees: attendees,
//             ),
//           ),
//         );
//       },
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: SizedBox(
//           width: screenWidth * 0.7, // Set card width relative to the screen
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius:
//                     const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: Image.network(
//                   imageUrl,
//                   height: 200,
//                   width: double.infinity,
//                   fit: BoxFit.fill,
//                   errorBuilder: (context, error, stackTrace) {
//                     return const SizedBox(
//                       height: 150,
//                       child: Center(
//                         child: Icon(
//                           Icons.broken_image,
//                           size: 40,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       date,
//                       style: TextStyle(
//                           color: HexColor("#4a43ec"),
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       title,
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const CircleAvatar(
//                             radius: 12, backgroundColor: Colors.blueAccent),
//                         const SizedBox(width: 4),
//                         const CircleAvatar(
//                             radius: 12, backgroundColor: Colors.redAccent),
//                         const SizedBox(width: 8),
//                         Text(attendees),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on,
//                             size: 16, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         Text(location,
//                             style: const TextStyle(color: Colors.grey)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
