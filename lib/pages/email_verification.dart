// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<StatefulWidget> createState() {
    return VerifyEmailState();
  }
}

class VerifyEmailState extends State<VerifyEmail> {
  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();
  TextEditingController thirdController = TextEditingController();
  TextEditingController fourthController = TextEditingController();
  TextStyle numStyle = TextStyle(
    color: HexColor('#82222280'),
    fontFamily: 'Montserrat',
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: HexColor('#1A237E'),
            size: 30,
          ),
        ),
      ),
      backgroundColor: HexColor("#ffffff"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.asset('images/logo.png'),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Text(
                'Enter Code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HexColor('#5669ff'),
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Text(
                'Enter a verification code we sent on your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HexColor('#82222280'),
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Space evenly
                children: [
                  Container(
                    color: HexColor('#e6e2ff'),
                    width: 50.0,
                    height: 50.0,
                    child: Center(
                      child: TextField(
                        controller: firstController,
                        style: numStyle,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        maxLength: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Container(
                    color: HexColor('#e6e2ff'),
                    width: 50.0,
                    height: 50.0,
                    child: Center(
                        child: TextField(
                      controller: secondController,
                      style: numStyle,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      maxLength: 1,
                      textAlign: TextAlign.center,
                    )),
                  ),
                  const SizedBox(width: 10.0),
                  Container(
                    color: HexColor('#e6e2ff'),
                    width: 50.0,
                    height: 50.0,
                    child: Center(
                        child: TextField(
                      controller: thirdController,
                      style: numStyle,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      maxLength: 1,
                      textAlign: TextAlign.center,
                    )),
                  ),
                  const SizedBox(width: 10.0),
                  Container(
                    color: HexColor('#e6e2ff'),
                    width: 50.0,
                    height: 50.0,
                    child: Center(
                        child: TextField(
                      controller: fourthController,
                      style: numStyle,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      maxLength: 1,
                      textAlign: TextAlign.center,
                    )),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              SizedBox(
                width: screenWidth * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    print(firstController.text +
                        secondController.text +
                        thirdController.text +
                        fourthController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor('#5669ff'),
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not Recieved Code?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: HexColor('#5669ff'),
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      )),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Resend Code',
                      style: TextStyle(
                        color: HexColor("#00f8ff"),
                        decoration: TextDecoration.underline,
                        decorationColor: HexColor("#00f8ff"),
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
