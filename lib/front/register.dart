import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:indiangrill/front/my_account.dart';
import 'package:indiangrill/session/user_session.dart';
import 'package:indiangrill/style/style.dart' show AppColors;
import 'package:indiangrill/services/api_config.dart';

class Register extends StatefulWidget {
  final Map<String, dynamic>? args;
  final String registration;
  
  const Register({super.key, this.args, required this.registration});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  late String displayText;

  String? emailError;
  String? passwordError;
  String? loginEmailError;
  String? loginPasswordError;

  String msg = ''; // Declare a message variable

  void validateAndLogin() {
  setState(() {
    loginEmailError = null;
    loginPasswordError = null;
  });

  String email = emailController.text.trim();
  String password = passwordController.text.trim();
  bool isValid = true;

  if (email.isEmpty) {
    loginEmailError = "Email cannot be empty";
    isValid = false;
  } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)) {
    loginEmailError = "Enter a valid email";
    isValid = false;
  }

  if (password.isEmpty) {
    loginPasswordError = "Password cannot be empty";
    isValid = false;
  } else if (password.length < 6) {
    loginPasswordError = "Password must be at least 6 characters";
    isValid = false;
  }

  setState(() {});

  if (!isValid) return;

  loginUser();
}

  void validateAndRegister() {
  setState(() {
    emailError = null;
    passwordError = null;
  });

  String email = emailController.text.trim();
  String password = passwordController.text.trim();
  bool isValid = true;

 if (email.isEmpty) {
  emailError = "Email cannot be empty";
  isValid = false;
} else if (!RegExp(
  r'^[a-zA-Z0-9]+([._-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$',
).hasMatch(email.trim())) {
  emailError = "Enter a valid email";
  isValid = false;
}

  if (password.isEmpty) {
    passwordError = "Password cannot be empty";
    isValid = false;
  } else if (password.length < 6) {
    passwordError = "Password must be at least 6 characters";
    isValid = false;
  }

  setState(() {});

  if (!isValid) return;

  registerUser();
}


  Future<void> registerUser() async {
    final String registerapiUrl =
        ApiConfig.registerUser; // Centralized API URL

    try {
      final response = await http.post(
        Uri.parse(registerapiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
          'role': 'customer',
        }),
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        // Handle success
        setState(() {
          userSession.logIn(
              email: emailController.text
                  .trim()); // Set session to logged in after registration
        });
        // Optionally, navigate to another page or display a success message
      } else {
        // Handle error
        setState(() {
          msg = 'Registration failed'; // Set the error message
        });
      }
    } catch (e) {
      // print('Error: $e');
      setState(() {
        msg = 'An error occurred: $e'; // Set error message on exception
      });
    }
  }

  Future<void> loginUser() async {
    final String loginApiUrl =
        ApiConfig.loginUser; // Centralized API endpoint

    try {
      final response = await http.post(
        Uri.parse(loginApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        //   // print('login done');
        // Assuming success if status code is 200
        //  print(userSession.isLoggedIn);
        await userSession.logIn(email: emailController.text.trim());
        // Mark user as logged in
        if (!mounted) return;
        context.go('/my_account');

        // Navigate to next screen or update UI accordingly
      } else {
        // print(response);
        // Decode error message if the API provides one
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          msg = responseBody['message'] ?? 'Login failed. Please try again.';
        });
        // print(msg);
      }
    } catch (e) {
      // print('Login error: $e');
      setState(() {
        msg = 'An error occurred: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    displayText = widget.registration == 'yes' ? 'register' : 'login';
  }

  void switchTo(String value) {
    setState(() {
      displayText = value;
    });
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          if (screenWidth > 1024) {
            return buildDesktopLayout();
          } else if (screenWidth > 600) {
            return buildTabletLayout();
          } else {
            return buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget buildDesktopLayout() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: userSession.isLoggedIn
            ? const MyAccount()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 6, // Setting flex to 1 for equal division
                    child: Image.asset(
                      'assets/images/uploads/head-chef-2.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (displayText == 'register')
                    Flexible(
                      flex: 4, // Setting flex to 1 for equal division
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(50, 50, 50, 30),
                            color: const Color(0XFFF1F1F1),
                            child: Column(
                              children: [
                                Text(
                                  'Join with us',
                                  style: GoogleFonts.raleway(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                // Check if msg is not null
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    msg,
                                    style: TextStyle(
                                      color: msg == 'Registration successful'
                                          ? Colors.green
                                          : AppColors.primary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                LabeledTextField(
                                  labelText: '',
                                  controller: emailController,
                                  hintText: 'Email address',
                                ),
                                LabeledTextField(
                                  labelText: '',
                                  controller: passwordController,
                                  hintText: 'Password',
                                  obscureText: true,
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Add your onPressed code here!
                                            registerUser();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: const Color(
                                                0xffe2001a), // Text color
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 20),
                                            textStyle: GoogleFonts.raleway(
                                                fontSize: 12),
                                          ).copyWith(
                                            shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        0), // No border radius
                                              ),
                                            ),
                                          ),
                                          child: const Text('Register'),
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Text(
                                              'Need any help?',
                                              style: GoogleFonts.raleway(
                                                fontSize: 12,
                                                color: const Color(0xffe2001a),
                                              ),
                                            )),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            color: const Color(0xffe5e5e5),
                            padding: const EdgeInsets.fromLTRB(50, 30, 50, 30),
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Already member? ',
                                    style: GoogleFonts.raleway(
                                        color: const Color(
                                            0xff666666)), // Default style for the text
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Sign In',
                                        style: GoogleFonts.raleway(
                                          color: const Color(
                                              0xffe2001a), // Set color to red for "SIGN IN"
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            switchTo('login');
                                          },
                                      ),
                                      TextSpan(
                                        text:
                                            ' now or connect with social account',
                                        style: GoogleFonts.raleway(
                                            color: const Color(0xff666666)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        20), // Space between text and buttons

                                // Facebook button
                                _buildSocialButton(
                                  color: const Color(0xff3b5998),
                                  icon: Icons.facebook,
                                  label: 'Like on ',
                                  boldLabel: 'facebook',
                                  onTap: () {
                                    // print('Facebook tapped');
                                  },
                                ),

                                const SizedBox(
                                    height: 10), // Space between buttons

                                // Google+ button
                                _buildSocialButton(
                                  color: const Color(0xffdb4a39),
                                  icon: Icons
                                      .g_mobiledata, // Example icon, customize as needed
                                  label: 'Like on ',
                                  boldLabel: 'google+',
                                  onTap: () {
                                    // print('Google+ tapped');
                                  },
                                ),

                                const SizedBox(
                                    height: 10), // Space between buttons

                                // Twitter button
                                _buildSocialButton(
                                  color: const Color(0xff1DA1F2),
                                  icon: Icons
                                      .alternate_email, // Example icon, customize as needed
                                  label: 'Like on ',
                                  boldLabel: 'twitter',
                                  onTap: () {
                                    // print('Twitter tapped');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (displayText == 'login')
                    Flexible(
                      flex: 4, // Setting flex to 1 for equal division
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(50, 50, 50, 30),
                            color: const Color(0XFFF1F1F1),
                            child: Column(
                              children: [
                                Text(
                                  'Account Sign In',
                                  style: GoogleFonts.raleway(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                LabeledTextField(
                                  labelText: '',
                                  controller: emailController,
                                  hintText: 'Username or email address',
                                ),
                                LabeledTextField(
                                  labelText: '',
                                  controller: passwordController,
                                  hintText: 'Password',
                                  obscureText: true,
                                ),
                                if (msg.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0),
                                    child: Text(
                                      msg,
                                      style: GoogleFonts.raleway(
                                        color: AppColors.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Add your onPressed code here!
                                            loginUser();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: const Color(
                                                0xffe2001a), // Text color
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 20),
                                            textStyle: GoogleFonts.raleway(
                                                fontSize: 12),
                                          ).copyWith(
                                            shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        0), // No border radius
                                              ),
                                            ),
                                          ),
                                          child: const Text('Login'),
                                        ),
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          onEnter: (_) {},
                                          onExit: (_) {},
                                          child: GestureDetector(
                                            onTap: () {
                                              GoRouter.of(context).pushNamed(
                                                  'lost-password'); // Adjust route name if needed
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 0, 0),
                                              child: Text(
                                                'Lost your password?',
                                                style: GoogleFonts.raleway(
                                                  fontSize: 12,
                                                  color:
                                                      const Color(0xffe2001a),
                                                  decoration: TextDecoration
                                                      .underline, // Optional, for link-style appearance
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            color: const Color(0xffe5e5e5),
                            padding: const EdgeInsets.fromLTRB(50, 30, 50, 30),
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Not Member yet? ',
                                    style: GoogleFonts.raleway(
                                        color: const Color(
                                            0xff666666)), // Default style for the text
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Sign Up',
                                        style: GoogleFonts.raleway(
                                          color: const Color(
                                              0xffe2001a), // Set color to red for "SIGN IN"
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            switchTo('register');
                                          },
                                      ),
                                      TextSpan(
                                        text:
                                            ' now or connect with social account',
                                        style: GoogleFonts.raleway(
                                            color: const Color(0xff666666)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        20), // Space between text and buttons

                                // Facebook button
                                _buildSocialButton(
                                  color: const Color(0xff3b5998),
                                  icon: Icons.facebook,
                                  label: 'Like on ',
                                  boldLabel: 'facebook',
                                  onTap: () {
                                    // print('Facebook tapped');
                                  },
                                ),

                                const SizedBox(
                                    height: 10), // Space between buttons

                                // Google+ button
                                _buildSocialButton(
                                  color: const Color(0xffdb4a39),
                                  icon: Icons
                                      .g_mobiledata, // Example icon, customize as needed
                                  label: 'Like on ',
                                  boldLabel: 'google+',
                                  onTap: () {
                                    // print('Google+ tapped');
                                  },
                                ),

                                const SizedBox(
                                    height: 10), // Space between buttons

                                // Twitter button
                                _buildSocialButton(
                                  color: const Color(0xff1DA1F2),
                                  icon: Icons
                                      .alternate_email, // Example icon, customize as needed
                                  label: 'Like on ',
                                  boldLabel: 'twitter',
                                  onTap: () {
                                    // print('Twitter tapped');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required Color color,
    required IconData icon,
    required String label,
    required String boldLabel,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: boldLabel,
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabletLayout() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      height: 700,
      // padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 5, // Setting flex to 1 for equal division
            child: Image.asset(
              'assets/images/uploads/head-chef-2.webp',
              fit: BoxFit.cover,
            ),
          ),
          if (displayText == 'register')
            Flexible(
              flex: 5, // Setting flex to 1 for equal division
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(50, 50, 50, 30),
                    color: const Color(0XFFF1F1F1),
                    child: Column(
                      children: [
                        Text(
                          'Join with us',
                          style: GoogleFonts.raleway(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        LabeledTextField(
                          labelText: '',
                          controller: emailController,
                          hintText: 'Email address',
                        ),
                        LabeledTextField(
                          labelText: '',
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: true,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    registerUser();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color(0xffe2001a), // Text color
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 20),
                                    textStyle:
                                        GoogleFonts.raleway(fontSize: 12),
                                  ).copyWith(
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            0), // No border radius
                                      ),
                                    ),
                                  ),
                                  child: const Text('Register'),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Need any help?',
                                      style: GoogleFonts.raleway(
                                        fontSize: 12,
                                        color: const Color(0xffe2001a),
                                      ),
                                    )),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color(0xffe5e5e5),
                    padding: const EdgeInsets.fromLTRB(50, 30, 50, 30),
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Already member? ',
                            style: GoogleFonts.raleway(
                                color: const Color(
                                    0xff666666)), // Default style for the text
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign In',
                                style: GoogleFonts.raleway(
                                  color: const Color(
                                      0xffe2001a), // Set color to red for "SIGN IN"
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    switchTo('login');
                                  },
                              ),
                              TextSpan(
                                text: ' now or connect with social account',
                                style: GoogleFonts.raleway(
                                    color: const Color(0xff666666)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                            height: 20), // Space between text and buttons

                        // Facebook button
                        _buildSocialButton(
                          color: const Color(0xff3b5998),
                          icon: Icons.facebook,
                          label: 'Like on ',
                          boldLabel: 'facebook',
                          onTap: () {
                            // print('Facebook tapped');
                          },
                        ),

                        const SizedBox(height: 10), // Space between buttons

                        // Google+ button
                        _buildSocialButton(
                          color: const Color(0xffdb4a39),
                          icon: Icons
                              .g_mobiledata, // Example icon, customize as needed
                          label: 'Like on ',
                          boldLabel: 'google+',
                          onTap: () {
                            // print('Google+ tapped');
                          },
                        ),

                        const SizedBox(height: 10), // Space between buttons

                        // Twitter button
                        _buildSocialButton(
                          color: const Color(0xff1DA1F2),
                          icon: Icons
                              .alternate_email, // Example icon, customize as needed
                          label: 'Like on ',
                          boldLabel: 'twitter',
                          onTap: () {
                            // print('Twitter tapped');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (displayText == 'login')
            Flexible(
              flex: 4, // Setting flex to 1 for equal division
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(50, 50, 50, 30),
                    color: const Color(0XFFF1F1F1),
                    child: Column(
                      children: [
                        Text(
                          'Account Sign In',
                          style: GoogleFonts.raleway(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        LabeledTextField(
                          labelText: '',
                          controller: emailController,
                          hintText: 'Username or email address',
                        ),
                        LabeledTextField(
                          labelText: '',
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: true,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Add your onPressed code here!
                                    // print('Login button pressed!');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color(0xffe2001a), // Text color
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 20),
                                    textStyle:
                                        GoogleFonts.raleway(fontSize: 12),
                                  ).copyWith(
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            0), // No border radius
                                      ),
                                    ),
                                  ),
                                  child: const Text('Login'),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Lost your password?',
                                      style: GoogleFonts.raleway(
                                        fontSize: 12,
                                        color: const Color(0xffe2001a),
                                      ),
                                    )),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color(0xffe5e5e5),
                    padding: const EdgeInsets.fromLTRB(50, 30, 50, 30),
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Not Member yet? ',
                            style: GoogleFonts.raleway(
                                color: const Color(
                                    0xff666666)), // Default style for the text
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign Up',
                                style: GoogleFonts.raleway(
                                  color: const Color(
                                      0xffe2001a), // Set color to red for "SIGN IN"
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    switchTo('register');
                                  },
                              ),
                              TextSpan(
                                text: ' now or connect with social account',
                                style: GoogleFonts.raleway(
                                    color: const Color(0xff666666)),
                              ),
                            ],
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget buildMobileLayout() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: AuthToggleBar(
                selected: displayText, // use displayText here
                onSelect: (value) {
                  switchTo(value); // switchTo already uses setState
                },
              ),
            ),

            // ---------------- Register Form ----------------
            if (displayText == 'register')
              Container(
                decoration: BoxDecoration(
                  color: Color(0XFFF1F1F1),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Text
                    Text(
                      'Getting started',
                      style: GoogleFonts.raleway(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create an account to continue. ',
                      style: GoogleFonts.raleway(
                          fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height:40),
                 

                    // Email input
                    _buildRoundedInput(
                      controller: emailController,
                      hint: 'Email',
                      icon: Icons.person_outline,
                      errorText: emailError,
                    ),
                    const SizedBox(height: 25),

                    // Password input
                    _buildRoundedInput(
                      controller: passwordController,
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      errorText: passwordError,
                    ),
                    const SizedBox(height: 25),

                    // Register button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          validateAndRegister();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xffe2001a),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 16),
                          textStyle: GoogleFonts.raleway(fontSize: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Register'),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sign In link
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: 'Already member? ',
                          style: GoogleFonts.raleway(
                              color: const Color(0xff666666), fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: GoogleFonts.raleway(
                                  color: const Color(0xffe2001a),
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  switchTo('login');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // ---------------- Login Form ----------------
            if (displayText == 'login')
              Container(
                decoration: BoxDecoration(
                  color: Color(0XFFF1F1F1),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Text
                      Text(
                      'Let\'s get Something',
                      style: GoogleFonts.raleway(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Good to see you back.',
                      style: GoogleFonts.raleway(
                          fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 25),

                    // Email input
                    _buildRoundedInput(
                      controller: emailController,
                      hint: 'Email',
                      icon: Icons.person_outline,
                      errorText: loginEmailError,
                    ),
                    const SizedBox(height: 25),

                    // Password input
                    _buildRoundedInput(
                      controller: passwordController,
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      errorText: loginPasswordError,
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) {},
                      onExit: (_) {},
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).pushNamed(
                              'lost-password'); // Adjust route name if needed
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 2),
                          child: Text(
                            'Forgot password?',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: const Color(0xffe2001a),
                              // Optional, for link-style appearance
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Error message
                    if (msg.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          msg,
                          style: GoogleFonts.raleway(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),

                    const SizedBox(height: 25),

                    // Login button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          validateAndLogin();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xffe2001a),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 16),
                          textStyle: GoogleFonts.raleway(fontSize: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Sign Up link
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: 'Not Member yet? ',
                          style: GoogleFonts.raleway(
                              color: const Color(0xff666666), fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: GoogleFonts.raleway(
                                  color: const Color(0xffe2001a),
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  switchTo('register');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _obscurePassword = true; // in your State class

 Widget _buildRoundedInput({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool isPassword = false,
  String? errorText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: isPassword ? _obscurePassword : false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: GoogleFonts.raleway(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
                style: GoogleFonts.raleway(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
            if (isPassword)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                child: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: Colors.black87,
                ),
              ),
          ],
        ),
      ),

      // ✔ error text displayed BELOW the input
      if (errorText != null)
        Padding(
          padding: const EdgeInsets.only(left: 6, top: 6),
          child: Text(
            errorText!,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              height: 1.2,
            ),
          ),
        ),
    ],
  );
}
}

// Custom widget for Label with TextField
class LabeledTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const LabeledTextField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText.isNotEmpty)
            Text(
              labelText,
              style: GoogleFonts.raleway(
                fontSize: 13,
                color: const Color(0xff666666),
              ),
            ),
          // Space between label and text field
          SizedBox(
              height: 35,
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                cursorColor: const Color(0xffe2001a),
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff666666)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffE2001A)),
                  ),
                  hintText: hintText,
                  hintStyle: GoogleFonts.raleway(
                    fontSize: 12,
                    color: const Color(0xff999999),
                  ),
                ),
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ))
        ],
      ),
    );
  }
}

class AuthToggleBar extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const AuthToggleBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _tab("login"),
          _tab("register"),
        ],
      ),
    );
  }

  Expanded _tab(String type) {
    final bool active = selected == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: active ? const Color(0xffe2001a) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            type == "login" ? "Login" : "Register",
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              color: active ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
