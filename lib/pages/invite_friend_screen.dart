import 'package:flutter/material.dart';

class InviteFriendPage extends StatefulWidget {
  const InviteFriendPage({super.key});

  @override
  InviteFriendPageState createState() => InviteFriendPageState();
}

class InviteFriendPageState extends State<InviteFriendPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  List<bool> selectedFriends = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
      backgroundColor: Colors.black,
      body: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Invite Friend",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.9,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedFriends.length,
                  itemBuilder: (context, index) {
                    return buildFriendTile(
                      "images/profile.jpg",
                      "Friend ${index + 1}",
                      "${(index + 1) * 100} Followers",
                      selectedFriends[index],
                      index,
                    );
                  },
                ),
              ),
              SizedBox(
                width: screenWidth * 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: selectedFriends.contains(true) ? () {} : null,
                    child: const Text("INVITE"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFriendTile(String imageUrl, String name, String followers,
      bool isSelected, int index) {
    return ListTile(
      minTileHeight: 50,
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        backgroundImage: AssetImage(imageUrl),
      ),
      title: Text(name),
      subtitle: Text(followers),
      trailing: Transform.scale(
        scale: 1,
        child: Checkbox(
          shape: const CircleBorder(),
          value: isSelected,
          checkColor: Colors.white,
          activeColor: Colors.blue,
          onChanged: (bool? value) {
            setState(() {
              selectedFriends[index] = value ?? false;
            });
          },
        ),
      ),
    );
  }
}
