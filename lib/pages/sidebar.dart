import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event_frontend/pages/all_events.dart';
import 'package:smart_event_frontend/pages/bookmark_page.dart';
import 'package:smart_event_frontend/pages/calender.dart';
import 'package:smart_event_frontend/pages/contactus_page.dart';
import 'package:smart_event_frontend/pages/login.dart';
import 'package:smart_event_frontend/pages/my_events.dart';
import 'package:smart_event_frontend/services/user_storage_service.dart';

class CustomSidebar extends StatefulWidget {
  const CustomSidebar({super.key});

  @override
  State<StatefulWidget> createState() {
    return CustomSidebarState();
  }
}

class CustomSidebarState extends State<CustomSidebar> {
  final storage = const FlutterSecureStorage();
  String email = "";
  String base64Image = '';
  String username = '';
  Uint8List? imageBytes;
  String? userRole = '';
  String currentUserId = '';
  Future<void> getUserData() async {
    final role = await storage.read(key: 'role');
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');

    if (userData != null) {
      final Map<String, dynamic> json = jsonDecode(userData);
      setState(() {
        base64Image = json['profilePicture'] ?? '';
        username = json['userName'] ?? '';
        email = json['email'] ?? '';
        currentUserId = json['id'];
        userRole = role;

        if (base64Image.isNotEmpty) {
          imageBytes = base64Decode(base64Image);
        }
      });
    }
  }

  String accountType(role) {
    if (role == "User") {
      return "(User)";
    } else if (role == "Admin") {
      return "(Admin)";
    } else if (role == "Organizer") {
      return "(Organizer)";
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> logout(BuildContext context) async {
    final userStorageService = UserStorageService();

    await storage.deleteAll();
    await userStorageService.clearUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  TextStyle labelStyle = const TextStyle(
    fontWeight: FontWeight.w300,
  );
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      backgroundColor: Colors.white.withOpacity(0.9),
      width: screenWidth * 0.6,
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.3,
            child: UserAccountsDrawerHeader(
              accountName: Text(
                "$username ${accountType(userRole)}",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: Text(
                email,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: imageBytes != null
                    ? MemoryImage(imageBytes!)
                    : const AssetImage('images/logo.png') as ImageProvider,
              ),
              decoration: BoxDecoration(
                color: HexColor("#fff"),
              ),
            ),
          ),
          if (userRole == 'Organizer')
            SidebarItem(
              icon: Icons.event_available_sharp,
              label: 'My Events',
              labelStyle: labelStyle,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyEventsPage()));
              },
            ),

          if (userRole == 'Admin')
            SidebarItem(
              icon: Icons.event_available_sharp,
              label: 'All Events',
              labelStyle: labelStyle,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AllEventsPage()));
              },
            ),

          SidebarItem(
            icon: Icons.message,
            label: 'Messages',
            labelStyle: labelStyle,
            onTap: () {},
          ),
          SidebarItem(
              icon: Icons.calendar_today,
              label: 'Calendar',
              labelStyle: labelStyle,
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarPage(),
                    ),
                  )),
          SidebarItem(
              icon: Icons.bookmark,
              label: 'Bookmark',
              labelStyle: labelStyle,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookmarksPage(userId: currentUserId),
                  ),
                );
              }),
          SidebarItem(
            icon: Icons.contact_mail,
            label: 'Contact Us',
            labelStyle: labelStyle,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ContactUsPage()));
            }
          ),
         
          SidebarItem(
            icon: Icons.logout,
            label: 'Sign Out',
            labelStyle: labelStyle,
            onTap: () {
              logout(context);
            },
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextStyle labelStyle;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.labelStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            Icon(icon, size: 30),
            SizedBox(width: screenWidth * 0.03),
            Text(label, style: labelStyle),
          ],
        ),
      ),
    );
  }
}
