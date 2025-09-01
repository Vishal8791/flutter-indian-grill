import 'package:flutter/material.dart';
import 'package:indiangrill/project/routes/app_routes_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';

// Create a single global instance of MyAppRouter
final myAppRouter = MyAppRouter();

Future<void> main() async {
  await dotenv.load(fileName: "woocommerce.env");
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
        scaffoldBackgroundColor: Colors.white, // all Scaffold backgrounds white
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red, // your brand color
          surface: Colors.white, // global background
        ),
      ),
      routeInformationParser: myAppRouter.router.routeInformationParser,
      routerDelegate: myAppRouter.router.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: 'Indian Grill',
    );
  }
}
