import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LostPassword extends StatefulWidget {
  const LostPassword({super.key});

  @override
  State<LostPassword> createState() => _LostPasswordPageState();
}

class _LostPasswordPageState extends State<LostPassword> {
  final TextEditingController emailController = TextEditingController();
  String msg = '';

  /* ───────────────────── Password‑reset stub ───────────────────── */

  Future<void> _resetPassword() async {
  final email = emailController.text.trim();

  if (email.isEmpty) {
    setState(() => msg = 'Please enter your email or username.');
    return;
  }

  final url = Uri.parse(
    'https://dev.indian-grill.com/wp-json/custom/v1/lost-password',
  );

  try {
    final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json", // REQUIRED
          },
          body: jsonEncode({
            "email": email,
          }),
        );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() => msg = data['message']);
    } else {
      setState(() => msg = data['message'] ?? 'Something went wrong.');
    }
  } catch (e) {
    setState(() => msg = 'Error: ${e.toString()}');
  }
}


  /* ───────────────────── Shared form widget ───────────────────── */
  Widget _buildForm(double maxWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lost your password? Please enter your username or email address. '
            'You will receive a link to create a new password via email.',
            style: GoogleFonts.raleway(fontSize: 14, color: Colors.grey[800]),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Username or email',
              hintStyle: GoogleFonts.raleway(),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffe2001a),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: Text(
                'Reset Password',
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (msg.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              msg,
              style: GoogleFonts.raleway(
                color: Colors.green[700],
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /* ───────────────────── 3 distinct layouts ───────────────────── */
  Widget buildMobileLayout() {
    // Single‑column, centered form
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: _buildForm(330),
    ));
  }

  Widget buildTabletLayout() {
    // Slightly wider form with more side padding
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: _buildForm(500),
    ));
  }

  Widget buildDesktopLayout() {
    // Two‑column feel: empty left space, form on right
    return Row(
      children: [
        Expanded(child: Container()), // left spacer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
          child: _buildForm(400),
        ),
        Expanded(child: Container()), // right spacer
      ],
    );
  }

  /* ───────────────────── Main build ───────────────────── */
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;

          // Same break‑points for both web & mobile apps
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
}
