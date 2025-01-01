import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShareApp extends StatefulWidget {
  const ShareApp({super.key});

  @override
  ShareAppState createState() => ShareAppState();
}

class ShareAppState extends State<ShareApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Share with friends",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: const [
                  _ShareIcon(icon: FontAwesomeIcons.link, label: "Copy Link"),
                  _ShareIcon(
                      icon: FontAwesomeIcons.whatsapp, label: "WhatsApp"),
                  _ShareIcon(
                      icon: FontAwesomeIcons.facebook, label: "Facebook"),
                  _ShareIcon(
                      icon: FontAwesomeIcons.facebookMessenger,
                      label: "Messenger"),
                  _ShareIcon(icon: FontAwesomeIcons.xTwitter, label: "Twitter"),
                  _ShareIcon(icon: FontAwesomeIcons.camera, label: "Instagram"),
                  _ShareIcon(icon: FontAwesomeIcons.skype, label: "Skype"),
                  _ShareIcon(icon: FontAwesomeIcons.message, label: "Message"),
                ],
              ),
              SizedBox(height: screenHeight * 0.06),
              SizedBox(
                width: screenWidth * 0.8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("CANCEL"),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(
                  height: 1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ShareIcon({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(
            icon,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
