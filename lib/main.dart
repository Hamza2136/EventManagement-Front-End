// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:smart_event_frontend/pages/add_event.dart';
// import 'package:smart_event_frontend/pages/event_search_page.dart';
// import 'package:smart_event_frontend/pages/login.dart';
// import 'package:smart_event_frontend/pages/main_screen.dart';
// import 'package:smart_event_frontend/pages/notification.dart';
// import 'package:smart_event_frontend/pages/shareApp.dart';

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
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

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:smart_event_frontend/pages/add_event.dart';
// import 'package:smart_event_frontend/pages/event_search_page.dart';
// import 'package:smart_event_frontend/pages/login.dart';
// import 'package:smart_event_frontend/pages/main_screen.dart';
// import 'package:smart_event_frontend/pages/notification.dart';
// import 'package:smart_event_frontend/pages/shareApp.dart';

// // Notification plugin setup
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('app_icon');

// // Notification channel setup
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'default_notification_channel_id', // This should match the value in AndroidManifest
//   'Default Notifications',
//   description: 'This channel is used for default notifications.',
//   importance: Importance.high,
// );

// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('app_icon');
//   final InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
// }

// Future<void> createNotificationChannel() async {
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
// }

// Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
//   // Handle background notification
//   print(
//       "Background message: ${message.notification?.title}, ${message.notification?.body}");
//   await showNotification(message); // Show notification in the background
// }

// Future<void> showNotification(RemoteMessage message) async {
//   const androidDetails = AndroidNotificationDetails(
//     'your_channel_id',
//     'your_channel_name',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const notificationDetails = NotificationDetails(android: androidDetails);

//   await flutterLocalNotificationsPlugin.show(
//     0,
//     message.notification?.title,
//     message.notification?.body,
//     notificationDetails,
//   );
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Firebase and notifications
//   await Firebase.initializeApp();
//   initializeNotifications();

//   // Initialize Firebase Messaging for background notifications
//   FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);

//   // Create the notification channel (important for Android)
//   createNotificationChannel();

//   // Request notification permissions on iOS
//   FirebaseMessaging.instance.requestPermission();

//   // Configure the foreground message handler
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('Foreground message: ${message.notification?.title}');
//     showNotification(
//         message); // Show notification when app is in the foreground
//   });

//   runApp(const MyApp());
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
// // }
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:smart_event_frontend/pages/add_event.dart';
// import 'package:smart_event_frontend/pages/event_search_page.dart';
// import 'package:smart_event_frontend/pages/login.dart';
// import 'package:smart_event_frontend/pages/main_screen.dart';
// import 'package:smart_event_frontend/pages/notification.dart';
// import 'package:smart_event_frontend/pages/shareApp.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'default_notification_channel_id',
//   'Default Notifications',
//   description: 'This channel is used for default notifications.',
//   importance: Importance.high,
// );

// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings androidSettings =
//       AndroidInitializationSettings('app_icon');

//   const InitializationSettings settings =
//       InitializationSettings(android: androidSettings);
//   await flutterLocalNotificationsPlugin.initialize(
//     settings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) async {
//       // Handle notification tap (optional)
//       final String? payload = response.payload;
//       if (payload != null) {
//         print('Notification payload: $payload');
//         // Navigate to a specific screen or perform action based on the payload
//     }
//   });
// }

// Future<void> createNotificationChannel() async {
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
// }

// // ✅ Only use data payload to prevent duplicates
// Future<void> showNotificationFromData(RemoteMessage message) async {
//   final title = message.data['title'] ?? 'No Title';
//   final body = message.data['body'] ?? 'No Body';

//   const androidDetails = AndroidNotificationDetails(
//     'default_notification_channel_id',
//     'Default Notifications',
//     importance: Importance.max,
//     priority: Priority.high,
//   );

//   const notificationDetails = NotificationDetails(android: androidDetails);

//   await flutterLocalNotificationsPlugin.show(
//     0,
//     title,
//     body,
//     notificationDetails,
//   );
// }

// // ✅ Background message handler
// Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   await showNotificationFromData(message);
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await initializeNotifications();
//   await createNotificationChannel();

//   // Background message handler setup
//   FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);

//   await FirebaseMessaging.instance.requestPermission();

//   // Foreground message handler setup
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('Foreground message received: ${message.data}');
//     // Show notification only if the app is in the foreground
//     showNotificationFromData(message);
//   });

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   MyApp({super.key});
//   final storage = FlutterSecureStorage();

//   Future<bool> isLoggedIn() async {
//     final token = await storage.read(key: 'auth_token');
//     return token != null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
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




import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_event_frontend/pages/add_event.dart';
import 'package:smart_event_frontend/pages/event_search_page.dart';
import 'package:smart_event_frontend/pages/login.dart';
import 'package:smart_event_frontend/pages/main_screen.dart';
import 'package:smart_event_frontend/pages/notification.dart';
import 'package:smart_event_frontend/pages/shareApp.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'default_notification_channel_id',
  'Default Notifications',
  description: 'This channel is used for default notifications.',
  importance: Importance.high,
);

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('app_icon');

  const InitializationSettings settings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      final String? payload = response.payload;
      if (payload != null) {
        print('Notification payload: $payload');
        // TODO: Navigate based on payload
      }
    },
  );
}

Future<void> createNotificationChannel() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

// ✅ Used to show notification only when manually needed (foreground + data-only)
Future<void> showNotificationFromData(RemoteMessage message) async {
  final title = message.data['title'] ?? 'No Title';
  final body = message.data['body'] ?? 'No Body';

  const androidDetails = AndroidNotificationDetails(
    'default_notification_channel_id',
    'Default Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    notificationDetails,
  );
}

// ✅ Handle data-only messages in background
Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.notification == null && message.data.isNotEmpty) {
    await showNotificationFromData(message);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeNotifications();
  await createNotificationChannel();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);

  await FirebaseMessaging.instance.requestPermission();

  // ✅ Foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Foreground message received: ${message.data}');

    // ✅ Only show notification manually if it's data-only
    if (message.notification == null && message.data.isNotEmpty) {
      showNotificationFromData(message);
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final storage = FlutterSecureStorage();

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
