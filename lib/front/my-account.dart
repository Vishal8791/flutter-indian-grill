import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiangrill/session/user_session.dart';

class MyAccount extends StatefulWidget {
  final Map<String, dynamic>? args;

  const MyAccount({super.key, this.args});

  @override
  _MyAccountState createState() => _MyAccountState();
}


class _MyAccountState extends State<MyAccount> {
  late String displayText;

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  final args = widget.args;
  displayText = (args != null && args['registration'] == 'yes') ? 'register' : 'login';
}
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          if (kIsWeb) {
            // For web: apply responsive layout based on screen size
            if (screenWidth > 1024) {
              // print("Web/Desktop layout is being used");
              return buildDesktopLayout(); // Desktop layout for web
            } else if (screenWidth > 600) {
              // print("Web/Tablet layout is being used");
              return buildTabletLayout(); // Tablet layout for web
            } else {
              // print("Web/Mobile layout is being used");
              return buildMobileLayout(); // Mobile layout for web
            }
          } else {
            // For web: apply responsive layout based on screen size
            if (screenWidth > 1024) {
              // print("Web/Desktop layout is being used");
              return buildDesktopLayout(); // Desktop layout for web
            } else if (screenWidth > 600) {
              // print("Web/Tablet layout is being used");
              return buildTabletLayout(); // Tablet layout for web
            } else {
              // print("Web/Mobile layout is being used");
              return buildMobileLayout(); // Mobile layout for web
            }
          }
        },
      ),
    );
  }

  Widget buildDesktopLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(190, 40, 190, 40),
      child:Column(
        children: [
         Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Expanded(
            flex: 2,
           child:SidebarWidget(
                  items: const [
                    {'text': 'Dashboard', 'route': '/dashboard'},
                    {'text': 'Orders', 'route': '/orders'},
                    {'text': 'Downloads', 'route': '/downloads'},
                    {'text': 'Addresses', 'route': '/address'},
                    {'text': 'Account Details', 'route': '/account-details'},
                    {'text':'logout','route':'/logout'},
                  ],
                  selectedRoute: '/dashboard',
               onRouteSelected: (route) async {
  if (route == '/logout') {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      userSession.logOut();

       GoRouter.of(context).pushNamed('logout');
    }
  } else {
    if (context.mounted) {
      Navigator.pushNamed(context, route);
    }
  }
},



                )
          ),
          Expanded(
            flex: 7,
            child:Center(
            child: Text(
              displayText == 'register' ? 'Register Page' : 'Login Page',
              style: GoogleFonts.raleway(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: displayText == 'register' ? Colors.red : Colors.blue,
              ),
            ),

            ),
            )
        ],
      ),
      ],
      ),
    );
  }

  Widget buildTabletLayout() {
    return buildDesktopLayout();
  }

  Widget buildMobileLayout() {
    return buildDesktopLayout();
  }
}

class SidebarWidget extends StatelessWidget {
  final List<Map<String, String>> items;
  final String selectedRoute;
  final ValueChanged<String> onRouteSelected;

  const SidebarWidget({
    super.key,
    required this.items,
    required this.selectedRoute,
    required this.onRouteSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffdddddd), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items.map((item) {
          final bool isSelected = item['route'] == selectedRoute;

          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => onRouteSelected(item['route']!),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.grey[300] : Colors.white,
                  border: const Border(
                    bottom: BorderSide(color: Color(0xffdddddd), width: 0.5),
                  ),
                ),
                child: Text(
                  item['text'] ?? '',
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.black : const Color(0xff666666),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Custom widget for Label with TextField
