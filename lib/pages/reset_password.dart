import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<StatefulWidget> createState() {
    return ResetPasswordState();
  }
}

class ResetPasswordState extends State<ResetPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
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
                'Reset Password',
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
                'Enter a new Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HexColor('#82222280'),
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: screenWidth * 0.9,
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Enter-Password',
                    labelStyle: fieldStyle,
                    hintText: 'Enter a new Password...',
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
                child: TextField(
                  controller: cpasswordController,
                  decoration: InputDecoration(
                    labelText: 'Re-Enter Password',
                    labelStyle: fieldStyle,
                    hintText: 'Enter new Password again...',
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
                    setState(() {
                      if (passwordController.text == cpasswordController.text) {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const Home(
                        //               userId: 0,
                        //             )));
                        showSnackbar(context, 'Password Change Successfully');
                      } else {
                        showSnackbar(context, 'Password does not match');
                      }
                    });
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
                    'Change Password',
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

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
