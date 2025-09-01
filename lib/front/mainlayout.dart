import 'package:flutter/material.dart';
import 'package:indiangrill/front/footer.dart';
import 'package:indiangrill/front/header.dart';

class MainLayout extends StatelessWidget {
  final Widget child; // Child page that will be rendered

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(), // The header remains the same
            child, // Render the child passed by the router
            const Footer(), // The footer remains the same
          ],
        ),
      ),
    );
  }
}
