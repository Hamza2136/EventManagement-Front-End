// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_event_frontend/pages/forgot_password.dart';
import 'package:smart_event_frontend/pages/homepage.dart';
import 'package:smart_event_frontend/pages/sign_up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  void goToPage(BuildContext context, pageName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pageName,
      ),
    );
  }

  int userid = 0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Color myColor = HexColor('#5669ff');
  bool _obscureText = true;
  final _formkey = GlobalKey<FormState>();
  String? userNotFoundError;
  String? incorrectPasswordError;

  TextStyle fieldStyle = const TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
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
        backgroundColor: HexColor("#ffffff"),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.07,
                  ),
                  Image.asset('images/logo.png'),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) => value != null && value.isEmpty
                          ? 'Email is Required'
                          : null,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        labelStyle: fieldStyle,
                        hintText: 'Enter Your Email...',
                        hintStyle: fieldStyle,
                        errorText: userNotFoundError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      style: fieldStyle,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  SizedBox(
                    width: screenWidth * 0.9, // Set the desired width
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) => value != null && value.isEmpty
                          ? 'Password is Required'
                          : null,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: fieldStyle,
                        hintText: 'Enter Your Password...',
                        hintStyle: fieldStyle,
                        errorText: incorrectPasswordError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      style: fieldStyle,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          String email = emailController.text;
                          String password = passwordController.text;
                          // login(context, email, password);
                          goToPage(context, const HomePage());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor("#5669ff"),
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      goToPage(context, const ForgotPass());
                    },
                    child: Text(
                      'Forgot your password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // decoration: TextDecoration.underline,
                        // decorationColor: HexColor('#1A237E'),
                        color: HexColor('#5669ff'),
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.07,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\' have an account?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: HexColor('#5669ff'),
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          )),
                      GestureDetector(
                        onTap: () {
                          goToPage(context, const SignUp());
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: HexColor("#00f8ff"),
                            decoration: TextDecoration.underline,
                            decorationColor: HexColor("#00f8ff"),
                            fontFamily: 'Montserrat',
                            fontSize: 16,
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
        ),
      ),
    );
  }

  // Future<void> login(
  //     BuildContext context, String email, String password) async {
  //   userNotFoundError = null;
  //   incorrectPasswordError = null;
  //   try {
  //     var response = await http.get(
  //       Uri.parse('$url/Accounts/email/$email'),
  //     );
  //     if (response.statusCode == 200) {
  //       var userData = jsonDecode(response.body);
  //       userid = userData['UserId'];
  //       if (userData['Password'] == password) {
  //         goToPage(context, Home(userId: userid));
  //       } else {
  //         setState(() {
  //           incorrectPasswordError = "Password is incorrect";
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         userNotFoundError = "User not found Please Register";
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint('$e');
  //   }
  // }
}
