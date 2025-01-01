import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_event_frontend/pages/reset_password.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<StatefulWidget> createState() {
    return ForgotPassState();
  }
}

class ForgotPassState extends State<ForgotPass> {
  TextEditingController emailController = TextEditingController();
  TextStyle fieldStyle = const TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    fontSize: 14,
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
            color: HexColor('#5669ff'),
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
                'Forgot Password',
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
                'Enter email address which recieve a 4 digit verification code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HexColor('#82222280'),
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              SizedBox(
                width: screenWidth * 0.9,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: fieldStyle,
                    hintText: 'Enter Your Email...',
                    hintStyle: fieldStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  style: fieldStyle,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              SizedBox(
                width: screenWidth * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPassword(),
                      ),
                    );
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
                    'Submit',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
