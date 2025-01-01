import 'package:flutter/material.dart';
import 'package:smart_event_frontend/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Smart Event',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const SplashScreenPage(),

      // routes: {
      //   '/walkthrough': (context) => const WalkThrough(),
      //   '/login': (context) => const Login(),
      // },
    );
  }
}
