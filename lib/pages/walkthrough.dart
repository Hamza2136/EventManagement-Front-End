// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_event_frontend/pages/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WalkThrough extends StatefulWidget {
  const WalkThrough({super.key});

  @override
  State<WalkThrough> createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  final pageController = PageController();
  bool isLastPage = false;
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subtitle,
    required double height,
    required double width,
  }) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            urlImage,
            fit: BoxFit.fill,
            height: height,
            width: width,
          ),
          const SizedBox(
            height: 64,
          ),
          Text(
            title,
            style: TextStyle(
              color: HexColor('#5669ff'),
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              subtitle,
              style: TextStyle(
                color: HexColor('#5669ff'),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // Show a dialog to confirm exit or return true to allow back navigation.
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 6);
            },
            children: [
              buildPage(
                color: Colors.white,
                urlImage: 'images/walkthrough/bg1.jpeg',
                title: 'Jeeps',
                subtitle:
                    'We deals in all kinds of parts of jeeps and other vehicle so contact us as soon as possible.',
                height: screenHeight * 0.5,
                width: screenWidth * 0.9,
              ),
              buildPage(
                color: Colors.white,
                urlImage: 'images/walkthrough/bg2.jpeg',
                title: 'Jeeps',
                subtitle:
                    'We deals in all kinds of parts of jeeps and other vehicle so contact us as soon as possible.',
                height: screenHeight * 0.5,
                width: screenWidth * 0.9,
              ),
              buildPage(
                color: Colors.white,
                urlImage: 'images/walkthrough/bg3.jpeg',
                title: 'Jeeps',
                subtitle:
                    'We deals in all kinds of parts of jeeps and other vehicle so contact us as soon as possible.',
                height: screenHeight * 0.5,
                width: screenWidth * 0.9,
              ),
              buildPage(
                color: Colors.white,
                urlImage: 'images/walkthrough/bg4.jpeg',
                title: 'Jeeps',
                subtitle:
                    'We deals in all kinds of parts of jeeps and other vehicle so contact us as soon as possible.',
                height: screenHeight * 0.5,
                width: screenWidth * 0.9,
              ),
              buildPage(
                color: Colors.white,
                urlImage: 'images/walkthrough/bg5.jpeg',
                title: 'Jeeps',
                subtitle:
                    'We deals in all kinds of parts of jeeps and other vehicle so contact us as soon as possible.',
                height: screenHeight * 0.5,
                width: screenWidth * 0.9,
              ),
              buildPage(
                color: Colors.white,
                urlImage: 'images/walkthrough/bg6.jpeg',
                title: 'Jeeps',
                subtitle:
                    'We deals in all kinds of parts of jeeps and other vehicle so contact us as soon as possible.',
                height: screenHeight * 0.5,
                width: screenWidth * 0.9,
              ),
              buildPage(
                color: Colors.white,
                urlImage: 'images/walkthrough/bg7.jpeg',
                title: 'Jeeps',
                subtitle:
                    'We deals in all kinds of parts of jeeps and other vehicle so contact us as soon as possible.',
                height: screenHeight * 0.5,
                width: screenWidth * 0.9,
              ),
            ],
          ),
        ),
        bottomSheet: isLastPage
            ? SizedBox(
                width: screenWidth * 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: HexColor('#5669ff'),
                    minimumSize: const Size.fromHeight(80),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: 80,
                width: screenWidth * 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        pageController.jumpToPage(6);
                      },
                      child: const Text('SKIP'),
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: 7,
                        effect: WormEffect(
                          spacing: 16,
                          dotColor: Colors.black26,
                          activeDotColor: HexColor('#5669ff'),
                        ),
                        onDotClicked: (index) => pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('NEXT'),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
