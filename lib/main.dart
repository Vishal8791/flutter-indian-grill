import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:indiangrill/project/routes/app_routes_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';

// Web-only import (guarded)
import 'package:flutter_web_plugins/url_strategy.dart' as web_plugins;

// Create a single global instance of MyAppRouter
final myAppRouter = MyAppRouter();

Future<void> main() async {
  await dotenv.load(fileName: 'assets/woocommerce.env');

  // ✅ Only apply URL strategy on web
  if (kIsWeb) {
    web_plugins.usePathUrlStrategy();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Load cart data after build context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Cart>(context, listen: false).loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          surface: Colors.white,
        ),
      ),
      routeInformationParser: myAppRouter.router.routeInformationParser,
      routerDelegate: myAppRouter.router.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: 'Indian Grill',
    );
  }
}
