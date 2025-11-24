import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:indiangrill/project/routes/app_routes_config.dart';
import 'package:indiangrill/session/user_session.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';

// Web-only import
import 'package:flutter_web_plugins/url_strategy.dart' as web_plugins;

// Create a single global instance of MyAppRouter
// final myAppRouter = MyAppRouter();

Future<void> main() async {
  // ✅ Required for async setup before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Load environment variables
  await dotenv.load(fileName: 'assets/woocommerce.env');

  // ✅ Use clean URLs on web
  if (kIsWeb) {
    web_plugins.usePathUrlStrategy();
  }

  // ✅ Initialize Cart and load saved data (items + tip)
  final cart = Cart();
  await cart.loadCart();
  await userSession.loadSession();
  final myAppRouter = MyAppRouter(); 
  // ✅ Run app with preloaded cart
 runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: userSession), // ✅ add this
      ChangeNotifierProvider.value(value: cart),
    ],
    child: MyApp(router: myAppRouter), // ✅ pass router to MyApp
  ),
);

}

class MyApp extends StatelessWidget {
  final MyAppRouter router; // ✅ accept router
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router.router,
      debugShowCheckedModeBanner: false,
      title: 'Indian Grill',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          surface: Colors.white,
        ),
      ),
    );
  }
}

