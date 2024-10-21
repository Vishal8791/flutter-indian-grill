import 'package:flutter/material.dart';
import 'package:indiangrill/project/routes/app_routes_config.dart'; // Ensure this import is correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: MyAppRouter().router.routeInformationParser,
      routerDelegate: MyAppRouter().router.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: 'Indian Grill',
    );
  }
}
