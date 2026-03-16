import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indiangrill/front/footer.dart';
import 'package:indiangrill/front/header.dart';
import 'package:indiangrill/widgets/app_drawer.dart';
class MainLayout extends StatefulWidget {
  final Widget child;
  final bool hideHeader;
  const MainLayout({super.key, required this.child,this.hideHeader = false,});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // -----------------------------------------------------------
  // MAP ROUTES TO BOTTOM NAV INDEX (ACTIVE TAB SYNC)
  // -----------------------------------------------------------
  int _getIndexFromRoute(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location == "/") return 0;
    if (location.startsWith("/order-online")) return 1;
    if (location.startsWith("/catering-enquiry")) return 2;
    if (location.startsWith("/ourcakes")) return 3;

    return 0; // default
  }

  // -----------------------------------------------------------
  // NAVIGATION ON TAP
  // -----------------------------------------------------------
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/order-online');
        break;
      case 2:
        context.go('/catering-enquiry');
        break;
      case 3:
        context.go('/ourcakes');
        break;
    }
  }

  // -----------------------------------------------------------
  // BOTTOM NAV BAR
  // -----------------------------------------------------------
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFFE23744),
      unselectedItemColor: Colors.grey.shade600,
      elevation: 20,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fastfood_outlined),
          label: "Order Here",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping_outlined),
          label: "Catering",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cake_outlined),
          label: "Our Cakes",
        ),
      ],
    );
  }

@override
Widget build(BuildContext context) {
  final isMobile = MediaQuery.of(context).size.width < 600;

  // Sync active tab with current route
  _selectedIndex = _getIndexFromRoute(context);

  return Scaffold(
    drawer: const AppDrawer(),

    body: SafeArea(
      child: isMobile
          // ---------------- MOBILE ----------------
          ? Column(
              children: [
                if (!widget.hideHeader) const Header(),

                Expanded(
                  child: widget.child,
                ),

                if (!isMobile) const Footer(),
              ],
            )

          // ---------------- DESKTOP / TABLET ----------------
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (!widget.hideHeader) const Header(),

                  widget.child,

                  const Footer(),
                ],
              ),
            ),
    ),

    bottomNavigationBar: isMobile &&
            !_hideBottomNav(GoRouterState.of(context).uri.toString())
        ? _buildBottomNavBar()
        : null,
  );
}

bool _hideBottomNav(String route) {
  return route.contains('/cart') || route.contains('/checkout');
}

}
