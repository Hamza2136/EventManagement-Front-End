// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_event_frontend/pages/email_verification.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Color myColor = HexColor('#5669ff');
  final _formkey = GlobalKey<FormState>();
  bool _obscureText = true;

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
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Image.asset('images/logo.png'),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) => value != null && value.isEmpty
                        ? 'Name is Required'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Name', // Changed label to labelText
                      labelStyle: fieldStyle,
                      hintText: 'Enter Your Name...',
                      hintStyle: fieldStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    style: fieldStyle,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) => value != null && value.isEmpty
                        ? 'Email is Required'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Email', // Changed label to labelText
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
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.9,
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
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        String name = nameController.text;
                        String email = emailController.text;
                        String password = passwordController.text;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VerifyEmail(),
                          ),
                        );
                        // signup(context, name, email, password);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myColor,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Sign up',
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
                    debugPrint('Terms and Policies');
                  },
                  child: Text('Terms and Conditions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: myColor,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                        decorationColor: HexColor("#5669ff"),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> signup(
  //     BuildContext context, String name, String email, String password) async {
  //   try {
  //     var response = await http.post(
  //       Uri.parse('$url/Accounts/create'),
  //       body: jsonEncode({'Name': name, 'Email': email, 'Password': password}),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //     if (response.statusCode == 201) {
  //       debugPrint('user created successfully');
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const Signin(),
  //         ),
  //       );
  //     } else {
  //       debugPrint('Failed to create user: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('$e');
  //   }
  // }
}
