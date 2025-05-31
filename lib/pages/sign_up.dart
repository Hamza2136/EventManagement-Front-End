import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_event_frontend/pages/login.dart';
import 'package:smart_event_frontend/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Color myColor = HexColor('#5669ff');
  final _formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  final AuthService _authService = AuthService();

  // Add variables for image and selected role
  File? _profileImage;
  String _selectedRole = 'User';

  Future<void> _signup(
    String usernameText,
    String emailText,
    String passText,
    File? profilePicture,
    String role,
  ) async {
    final username = usernameText;
    final email = emailText;
    final password = passText;

    if (profilePicture == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a profile picture.')),
      );
      return;
    }

    final success = await _authService.signup(
      username,
      email,
      password,
      profilePicture,
      role,
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup failed. Try again.')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

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
                    controller: usernameController,
                    validator: (value) => value != null && value.isEmpty
                        ? 'Username is Required'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: fieldStyle,
                      hintText: 'Enter Your Username...',
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
                      labelText: 'Email',
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
                // Role Dropdown
                SizedBox(
                  width: screenWidth * 0.9,
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue!;
                      });
                    },
                    items: <String>['User', 'Organizer']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Select Role',
                      labelStyle: fieldStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                // Image Picker Button
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: HexColor('#f0f0f0'),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: myColor),
                    ),
                    child: _profileImage == null
                        ? Icon(Icons.camera_alt, color: myColor)
                        : Image.file(_profileImage!),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                // Sign Up Button
                SizedBox(
                  width: screenWidth * 0.9,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        String username = usernameController.text;
                        String email = emailController.text;
                        String password = passwordController.text;

                        // Use _profileImage instead of _profilePicture
                        File? profilePicture =
                            _profileImage; // Corrected variable name
                        String role =
                            _selectedRole; // Reference the selected role

                        // Call the signup function with the required parameters
                        await _signup(
                            username, email, password, profilePicture, role);
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
}
