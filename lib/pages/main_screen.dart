// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_event_frontend/pages/events.dart';
import 'package:smart_event_frontend/pages/homepage.dart';
import 'package:smart_event_frontend/pages/profile.dart';
import 'package:smart_event_frontend/pages/session_expired.dart';
import 'package:smart_event_frontend/pages/user_search_page.dart';
import 'package:smart_event_frontend/pages/users_list_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_event_frontend/url.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final storage = const FlutterSecureStorage();
  late int _selectedIndex;
  String userRole = "";
  Future<void> loadRole() async {
    final role = await storage.read(key: 'role');
    setState(() {
      userRole = role!;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkTokenValidity();
    loadRole();
    _selectedIndex = widget.initialIndex;
  }

  Future<void> _checkTokenValidity() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'auth_token');

    if (token != null) {
      final response = await http.post(
        Uri.parse("$url/UserAccount/verify-token"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(token),
      );

      if (response.statusCode == 401) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SessionExpiredScreen()),
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              exit(0);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  final List<Widget> _pages = [
    const HomePage(),
    const UserSearchScreen(),
    const Events(),
    UsersListScreen(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _pages[_selectedIndex],
        floatingActionButton: (_selectedIndex == 0 &&
                (userRole == 'Admin' || userRole == 'Organizer'))
            ? SizedBox(
                height: 40,
                width: 40,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_event');
                  },
                  backgroundColor: HexColor("#4a43ec"),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.add, size: 20),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: SizedBox(
          height: screenHeight * 0.140,
          child: BottomAppBar(
            color: Colors.grey[300],
            shape: const CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, Icons.home, 'Home'),
                _buildNavItem(1, Icons.explore, 'Explore'),
                _buildNavItem(2, Icons.event, 'Events'),
                _buildNavItem(3, Icons.map, 'Chat'),
                _buildNavItem(4, Icons.person, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          onPressed: () => _onItemTapped(index),
          icon: Icon(icon),
          color: _selectedIndex == index ? HexColor("#4a43ec") : Colors.grey,
          iconSize: 30,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _selectedIndex == index ? HexColor("#4a43ec") : Colors.grey,
          ),
        ),
      ],
    );
  }
}
