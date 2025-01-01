import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_event_frontend/pages/others_profile.dart';

class CustomSidebar extends StatefulWidget {
  const CustomSidebar({super.key});

  @override
  State<StatefulWidget> createState() {
    return CustomSidebarState();
  }
}

class CustomSidebarState extends State<CustomSidebar> {
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
              accountName: const Text(
                'Hamza Abid',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: const Text(
                'hamzaabid@test.com',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('images/profile.jpg'),
              ),
              decoration: BoxDecoration(
                color: HexColor("#fff"),
              ),
            ),
          ),
          SidebarItem(
            icon: Icons.person,
            label: 'My Profile',
            labelStyle: labelStyle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OthersProfile(),
                ),
              );
            },
          ),
          SidebarItem(
            icon: Icons.message,
            label: 'Messages',
            labelStyle: labelStyle,
            onTap: () => Navigator.pop(context),
          ),
          SidebarItem(
            icon: Icons.calendar_today,
            label: 'Calendar',
            labelStyle: labelStyle,
            onTap: () => Navigator.pop(context),
          ),
          SidebarItem(
            icon: Icons.bookmark,
            label: 'Bookmark',
            labelStyle: labelStyle,
            onTap: () => Navigator.pop(context),
          ),
          SidebarItem(
            icon: Icons.contact_mail,
            label: 'Contact Us',
            labelStyle: labelStyle,
            onTap: () => Navigator.pop(context),
          ),
          SidebarItem(
            icon: Icons.settings,
            label: 'Settings',
            labelStyle: labelStyle,
            onTap: () => Navigator.pop(context),
          ),
          SidebarItem(
            icon: Icons.help,
            label: 'Helps & FAQs',
            labelStyle: labelStyle,
            onTap: () => Navigator.pop(context),
          ),
          SidebarItem(
            icon: Icons.logout,
            label: 'Sign Out',
            labelStyle: labelStyle,
            onTap: () => Navigator.pop(context),
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
