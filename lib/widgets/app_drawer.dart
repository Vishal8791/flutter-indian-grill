import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indiangrill/style/style.dart' show AppColors, AppTextStyle;
import 'package:provider/provider.dart';
import 'package:indiangrill/session/user_session.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with TickerProviderStateMixin {
  late AnimationController _controller;

  // For collapsible menu
  bool isBanquetExpanded = false;
  late AnimationController _banquetController;
  late Animation<double> _banquetExpandAnimation;
  String? activeSubmenuGroup;
  bool isRouteInGroup(String groupKey, String currentRoute) {
  return currentRoute.startsWith(groupKey);
}

  @override
  void initState() {
    super.initState();

    // Drawer main animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _controller.forward();
    });

    // Submenu expand animation
    _banquetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _banquetExpandAnimation = CurvedAnimation(
      parent: _banquetController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _banquetController.dispose();
    super.dispose();
  }

  void toggleBanquetMenu() {
    setState(() {
      isBanquetExpanded = !isBanquetExpanded;
      isBanquetExpanded
          ? _banquetController.forward()
          : _banquetController.reverse();
    });
  }

  // Reusable single item
Widget _drawerItem(
  IconData icon,
  String label,
  VoidCallback onTap, {
  required bool isActive,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 0),
    child: ListTile(
      minLeadingWidth: 32,
      leading: Icon(
        icon,
        color: isActive ? Colors.red : AppColors.sideMenuIcon,
        size: 23,
      ),
      title: Text(
        label,
        style: AppTextStyle.poppinsDrawer(isActive),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: Colors.grey.withOpacity(0.12),
      onTap: onTap,
    ),
  );
}


  // Reusable submenu item
Widget _subMenuItem(
  IconData icon,
  String label,
  VoidCallback onTap, {
  required String currentRoute,
  required String group,
}) {
   final bool isActive = currentRoute == group;
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.only(left: 65, top: 6, bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: currentRoute == group ? Colors.red : AppColors.sideMenuSubIcon,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            // style: TextStyle(
            //   fontSize: 15,
            //   fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            //   color: isActive ? Colors.red : AppColors.sideMenuSubText,
            // ),
            style: AppTextStyle.poppinssubmenuDrawer(isActive), 
          ),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouter.of(context).location;
    final isBanquetGroupActive = isRouteInGroup('/banquet', currentRoute);
    if (isBanquetGroupActive && !_banquetController.isCompleted) {
        isBanquetExpanded = true;      // keep state consistent
        _banquetController.forward();  // animate open
      }
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
      child: Drawer(
        width: 292,
        backgroundColor: AppColors.sideMenuBg,
        child: SafeArea(
          child: Consumer<UserSession>(
            builder: (context, session, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- TOP PROFILE ----
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 5, top: 0, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Text(
                                  //   "Hello,",
                                  //   style: const TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 20,
                                  //     color: Colors.black,
                                  //   ),
                                  // ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 22,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    tooltip: "Close",
                                  ),
                                ],
                              ),

                              // // Username Line
                              // Text(
                              //   session.name ?? "Guest",
                              //   style: const TextStyle(
                              //     fontSize: 15,
                              //     color: Colors.grey,
                              //   ),
                              //   maxLines: 1,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

//                  const Divider(thickness: 1),

                  // ---- MENU ITEMS ----
          

Expanded(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      // HOME
      _drawerItem(
        Icons.home_outlined,
        "Home",
        () {
          Navigator.pop(context);
          context.go('/');
        },
        isActive: currentRoute == '/',
      ),

      // ACCOUNT
      if (session.isLoggedIn)
        _drawerItem(
          Icons.person_outline,
          "My Account",
          () {
            Navigator.pop(context);
            context.go('/my-account');
          },
          isActive: currentRoute == '/my-account',
        ),

      // BANQUETS HEADER — auto expand if submenu active

      _expandableDrawerHeader(
        icon: Icons.restaurant_outlined,
        label: "Banquets",
        expanded: isBanquetExpanded || isBanquetGroupActive,
        onTap: toggleBanquetMenu,
      ),

SizeTransition(
  sizeFactor: _banquetExpandAnimation,
  child: Column(
    children: [
      _subMenuItem(
        Icons.person_outline,
        "Banquet",
        () {
          Navigator.pop(context);
          context.go('/banquet');
        },
        group: '/banquet',
        currentRoute: currentRoute,
      ),
      _subMenuItem(
        Icons.menu_book_outlined,
        "Banquet Menu",
        () {
          Navigator.pop(context);
          context.go('/banquet-menu');
        },
        group: '/banquet-menu',
        currentRoute: currentRoute,
      ),
    ],
  ),
),

      // OTHER MENU ITEMS
      _drawerItem(
        Icons.edit_note_outlined,
        "Gallery",
        () {
          Navigator.pop(context);
          context.go('/gallery');
        },
        isActive: currentRoute == '/gallery',
      ),

      _drawerItem(
        Icons.notifications_none,
        "Contact Us",
        () {
          Navigator.pop(context);
          context.go('/contactus');
        },
        isActive: currentRoute == '/contactus',
      ),

      _drawerItem(
        Icons.help_outline,
        "About us",
        () {
          Navigator.pop(context);
          context.go('/about-us');
        },
        isActive: currentRoute == '/about-us',
      ),

      _drawerItem(
        Icons.settings_outlined,
        "Career",
        () {
          Navigator.pop(context);
          context.go('/career');
        },
        isActive: currentRoute == '/career',
      ),

      _drawerItem(
        Icons.settings_outlined,
        "Privacy policy",
        () {
          Navigator.pop(context);
          context.go('/privacy-policy');
        },
        isActive: currentRoute == '/privacy-policy',
      ),
    ],
  ),
),


                  // ---- LOGIN / LOGOUT ----
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    child: session.isLoggedIn
                        ? GestureDetector(
                            onTap: () async {
                              // Show confirmation dialog
                              final shouldLogout = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.logout,
                                            size: 40,
                                            color: Colors.red.shade400),
                                        const SizedBox(height: 12),
                                        Text(
                                          "Confirm Logout",
                                          style: GoogleFonts.raleway(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Are you sure you want to log out?",
                                          style: GoogleFonts.raleway(
                                            fontSize: 14,
                                            color: Colors.grey.shade700,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () =>
                                                    Navigator.of(ctx)
                                                        .pop(false),
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  side: BorderSide(
                                                      color:
                                                          Colors.grey.shade400),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 14),
                                                ),
                                                child: Text(
                                                  "Cancel",
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(ctx).pop(true),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.red.shade400,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 14),
                                                ),
                                                child: Text(
                                                  "Logout",
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );

                              // If confirmed, log out
                              if (shouldLogout == true) {
                                await session.logOut();
                                Navigator.pop(context);
                              }
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.logout,
                                    color: Colors.black87, size: 24),
                                SizedBox(width: 14),
                                Text("Logout",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              context.go('/login');
                            },
                            child: Row(
                              children: [
                                Icon(Icons.login,
                                    color: Colors.black87, size: 24),
                                SizedBox(width: 14),
                                Text("Login / Register",
                                    style: AppTextStyle.drawerexpandableHeading),
                              ],
                            ),
                          ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _expandableDrawerHeader({
  required IconData icon,
  required String label,
  required bool expanded,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 10),
    child: ListTile(
      minLeadingWidth: 32,
      leading: Icon(icon, color: AppColors.sideMenuIcon, size: 21),
      title: Text(label,
          style: AppTextStyle.drawerexpandableHeading),
      trailing: Icon(
        expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
        color: AppColors.sideMenuArrow,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: Colors.grey.withOpacity(0.12),
      onTap: onTap,
    ),
  );
}
