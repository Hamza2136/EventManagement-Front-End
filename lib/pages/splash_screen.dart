// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_event_frontend/pages/walkthrough.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('images/logo@2x.png')),
      backgroundColor: HexColor("#ffffff"),
    );
  }
}

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _navigateToWalkthrough(context);
  }

  void _navigateToWalkthrough(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2)); // Adjust the duration
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WalkThrough(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen(); // Display your splash screen widget
  }
}
