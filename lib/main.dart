// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:smart_event_frontend/pages/add_event.dart';
// import 'package:smart_event_frontend/pages/event_search_page.dart';
// import 'package:smart_event_frontend/pages/login.dart';
// import 'package:smart_event_frontend/pages/main_screen.dart';
// import 'package:smart_event_frontend/pages/notification.dart';
// import 'package:smart_event_frontend/pages/shareApp.dart';
// import 'package:smart_event_frontend/services/connectivity_service.dart';
// import 'package:smart_event_frontend/pages/no_internet_screen.dart';

// void main() {
//   runApp(const ConnectivityWrapper());
// }

// class ConnectivityWrapper extends StatelessWidget {
//   const ConnectivityWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: ConnectivityService.instance.connectivityStream,
//       builder: (context, snapshot) {
//         final hasInternet = snapshot.data ?? true;
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           // Remove the initialRoute and routes from here
//           home: Stack(
//             children: [
//               const MyApp(),
//               if (!hasInternet) const NoInternetScreen(),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   final storage = const FlutterSecureStorage();

//   Future<bool> isLoggedIn() async {
//     final token = await storage.read(key: 'auth_token');
//     return token != null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // Define routes here instead
//       routes: {
//         '/login': (context) => const Login(),
//         '/home': (context) => const MainScreen(initialIndex: 0),
//         '/explore': (context) => const MainScreen(initialIndex: 1),
//         '/events': (context) => const MainScreen(initialIndex: 2),
//         '/chat': (context) => const MainScreen(initialIndex: 3),
//         '/profile': (context) => const MainScreen(initialIndex: 4),
//         '/add_event': (context) => const AddEvent(),
//         '/notifications': (context) => const NotificationsPage(),
//         '/event_search': (context) => const EventSearchScreen(),
//         '/share_app': (context) => const ShareApp(),
//       },
//       home: FutureBuilder(
//         future: isLoggedIn(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           }
//           return snapshot.data == true 
//               ? const MainScreen(initialIndex: 0) 
//               : const Login();
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_event_frontend/pages/add_event.dart';
import 'package:smart_event_frontend/pages/event_search_page.dart';
import 'package:smart_event_frontend/pages/login.dart';
import 'package:smart_event_frontend/pages/main_screen.dart';
import 'package:smart_event_frontend/pages/notification.dart';
import 'package:smart_event_frontend/pages/shareApp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final storage = const FlutterSecureStorage();

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'auth_token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const MainScreen(initialIndex: 0),
        '/explore': (context) => const MainScreen(initialIndex: 1),
        '/events': (context) => const MainScreen(initialIndex: 2),
        '/chat': (context) => const MainScreen(initialIndex: 3),
        '/profile': (context) => const MainScreen(initialIndex: 4),
        '/add_event': (context) => const AddEvent(),
        '/notifications': (context) => const NotificationsPage(),
        '/event_search': (context) => const EventSearchScreen(),
        '/share_app': (context) => const ShareApp(),
      },
      home: FutureBuilder(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data == true
              ? const MainScreen(initialIndex: 0)
              : const Login();
        },
      ),
    );
  }
}
