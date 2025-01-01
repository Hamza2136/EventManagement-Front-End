// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';

// class Events extends StatefulWidget {
//   const Events({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return EventsState();
//   }
// }

// class EventsState extends State<Events> {
//   bool isUpcomingSelected = true;
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: HexColor("#4a43ec"),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//             size: 30,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               "Events",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 22,
//               ),
//             ),
//             IconButton(
//               icon: const Icon(
//                 Icons.more_vert_outlined,
//                 color: Colors.white,
//                 size: 30,
//               ),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 Center(
//                   child: Container(
//                     width: screenWidth * 0.8,
//                     padding: const EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius:
//                           BorderRadius.circular(30), // Rounded container
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Upcoming Events Button
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               isUpcomingSelected = true;
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 10),
//                             decoration: BoxDecoration(
//                               color: isUpcomingSelected
//                                   ? Colors.white
//                                   : Colors.transparent,
//                               borderRadius: BorderRadius.circular(30),
//                               boxShadow: isUpcomingSelected
//                                   ? [
//                                       BoxShadow(
//                                         color: Colors.grey.shade400,
//                                         blurRadius: 4,
//                                         offset: const Offset(0, 2),
//                                       )
//                                     ]
//                                   : null,
//                             ),
//                             child: Text(
//                               "UPCOMING",
//                               style: TextStyle(
//                                 color: isUpcomingSelected
//                                     ? Colors.blue
//                                     : Colors.grey,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               isUpcomingSelected = false;
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 10),
//                             decoration: BoxDecoration(
//                               color: isUpcomingSelected
//                                   ? Colors.transparent
//                                   : Colors.white,
//                               borderRadius: BorderRadius.circular(30),
//                               boxShadow: !isUpcomingSelected
//                                   ? [
//                                       BoxShadow(
//                                         color: Colors.grey.shade400,
//                                         blurRadius: 4,
//                                         offset: const Offset(0, 2),
//                                       )
//                                     ]
//                                   : null,
//                             ),
//                             child: Text(
//                               "PAST EVENTS",
//                               style: TextStyle(
//                                 color: isUpcomingSelected
//                                     ? Colors.grey
//                                     : Colors.blue,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Positioned(
//           //   bottom: 0,
//           //   left: screenWidth * 0.05,
//           //   right: screenWidth * 0.05,
//           //   child: ElevatedButton(
//           //     onPressed: () {},
//           //     style: ElevatedButton.styleFrom(
//           //       padding: const EdgeInsets.symmetric(vertical: 16),
//           //       backgroundColor: HexColor("#4a43ec"),
//           //       foregroundColor: Colors.white,
//           //       shape: RoundedRectangleBorder(
//           //         borderRadius: BorderRadius.circular(30),
//           //       ),
//           //     ),
//           //     child: const Text(
//           //       'Buy Ticket \$120',
//           //       style: TextStyle(fontSize: 20),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_event_frontend/pages/eventlistscreen.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<StatefulWidget> createState() {
    return EventsState();
  }
}

class EventsState extends State<Events> {
  bool isUpcomingSelected = true;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      isUpcomingSelected = (index == 0);
    });
  }

  void _onToggleTap(bool upcomingSelected) {
    setState(() {
      isUpcomingSelected = upcomingSelected;
    });
    _pageController.animateToPage(
      upcomingSelected ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
              "Events",
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
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Center(
            child: Container(
              width: screenWidth * 0.8,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30), // Rounded container
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _onToggleTap(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isUpcomingSelected
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: isUpcomingSelected
                            ? [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Text(
                        "UPCOMING",
                        style: TextStyle(
                          color: isUpcomingSelected ? Colors.blue : Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onToggleTap(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isUpcomingSelected
                            ? Colors.transparent
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: !isUpcomingSelected
                            ? [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Text(
                        "PAST EVENTS",
                        style: TextStyle(
                          color: isUpcomingSelected ? Colors.grey : Colors.blue,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.2,
                      ),
                      Image.asset(
                        "images/noevent.png",
                        height: 150,
                        width: 150,
                      ),
                      const Text(
                        "No Event Found",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Click on Explore Events for more Events",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.15,
                      ),
                      SizedBox(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.8,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EventListScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor("#4a43ec"),
                            foregroundColor: Colors.white,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Explore Events',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Column(
                  children: [
                    Text(
                      "Past Events",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
