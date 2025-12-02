import 'dart:async'; // Import for Timer
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:indiangrill/front/dropdown_header/hover_dropdown_menu.dart';
import 'package:indiangrill/session/user_session.dart';
import 'package:provider/provider.dart';
import 'package:indiangrill/providers/cart_provider.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with SingleTickerProviderStateMixin {
  bool _isNavbarOpen = false;
  bool _isVisible = true;
  bool _isHovering = false;
  Timer? _timer;
  final GlobalKey _headerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();

    // Initialize animation controller and slide animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // slide from above
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _startBlinking();
  }

  @override
  void dispose() {
    _stopBlinking();
    _controller.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  bool _isCartHovering = false;
  bool _isBanquetExpanded = false;
  bool _isContactExpanded = false;

  // Add this helper to close the navbar reliably
  void _closeNavbar({bool immediate = false}) {
    if (!mounted || !_isNavbarOpen) return;

    if (immediate) {
      // Remove instantly (useful when tapping a menu item before navigation)
      _overlayEntry?.remove();
      _overlayEntry = null;

      setState(() {
        _isNavbarOpen = false;
        _controller.reset();
      });
      return;
    }

    // Animated close (for close button)
    _controller.reverse().whenCompleteOrCancel(() {
      if (!mounted) return;

      _overlayEntry?.remove();
      _overlayEntry = null;

      setState(() {
        _isNavbarOpen = false;
        _controller.reset();
      });
    });
  }

  void _toggleNavbar() {
    if (!mounted) return;

    if (_isNavbarOpen) {
      _closeNavbar();
    } else {
      final overlay = Overlay.of(context);
      if (overlay == null) return;

      _overlayEntry = _createOverlayEntry();
      overlay.insert(_overlayEntry!);

      _controller.forward(from: 0.0); // start clean each time
      setState(() {
        _isNavbarOpen = true;
      });
    }
  }

  String? _clickedRoute;
  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox =
        _headerKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final double top = position.dy + renderBox.size.height;

    final String currentRoute = GoRouter.of(context).location.split('/').last;

    return OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setOverlayState) => Stack(
            children: [
              // Backdrop
              GestureDetector(
                onTap: _closeNavbar,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                ),
              ),

              // Navbar
              Positioned(
                top: top,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizeTransition(
                    axisAlignment: -1.0,
                    sizeFactor: _controller,
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 🔹 Home
                          _buildNavItem(
                            label: "Home",
                            route: "home",
                            currentRoute: currentRoute,
                            onTap: () {
                              setState(() => _clickedRoute = "home");
                              _closeNavbar(immediate: true);
                              GoRouter.of(context).pushNamed("home");
                            },
                          ),

                          // 🔹 Other direct items
                          ...[
                            {"label": "Order Online", "route": "order-online"},
                            {
                              "label": "Catering Enquiry",
                              "route": "category-enquiry"
                            },
                            {"label": "Gallery", "route": "gallery"},
                            {"label": "Our Cakes", "route": "ourcakes"},
                          ].map((item) {
                            return _buildNavItem(
                              label: item["label"]!,
                              route: item["route"]!,
                              currentRoute: currentRoute,
                              onTap: () {
                                setState(() => _clickedRoute = item["route"]!);
                                _closeNavbar(immediate: true);
                                GoRouter.of(context).pushNamed(item["route"]!);
                              },
                            );
                          }),

                          // 🔹 Banquet expandable
                          _buildExpandableNav(
                            title: "Banquet",
                            isExpanded: _isBanquetExpanded,
                            onToggle: () {
                              setOverlayState(() {
                                _isBanquetExpanded = !_isBanquetExpanded;
                              });
                            },
                            items: [
                              {"label": "Banquets", "route": "banquet"},
                              {"label": "Menu", "route": "banquet-menu"},
                            ],
                            currentRoute: currentRoute,
                          ),

                          // 🔹 Contact expandable
                          _buildExpandableNav(
                            title: "Contact Us",
                            isExpanded: _isContactExpanded,
                            onToggle: () {
                              setOverlayState(() {
                                _isContactExpanded = !_isContactExpanded;
                              });
                            },
                            items: [
                              {"label": "Contact Us", "route": "contactus"},
                              {"label": "About Us", "route": "about-us"},
                              {"label": "Career", "route": "career"},
                            ],
                            currentRoute: currentRoute,
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔹 Single item
  Widget _buildNavItem({
    required String label,
    required String route,
    required String currentRoute,
    required VoidCallback onTap,
  }) {
    final bool isActive = _clickedRoute == route || currentRoute == route;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE2001A) : Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  /// 🔹 Expandable group (Banquet / Contact Us)
  Widget _buildExpandableNav({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Map<String, String>> items,
    required String currentRoute,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      // fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade800,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            ...items.map((item) {
              final bool isActive = _clickedRoute == item["route"] ||
                  currentRoute == item["route"];
              return GestureDetector(
                onTap: () {
                  setState(() => _clickedRoute = item["route"]!);
                  _closeNavbar(immediate: true);
                  GoRouter.of(context).pushNamed(item["route"]!);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  color: isActive ? Colors.grey.shade300 : Colors.white,
                  child: Text(
                    item["label"]!,
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isActive ? Colors.red : Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  void _startBlinking() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isHovering) {
        setState(() {
          _isVisible = !_isVisible;
        });
      }
    });
  }

  void _stopBlinking() {
    _timer?.cancel();
  }

  // @override
  // void dispose() {
  //   _stopBlinking();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Container(
        color: Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            // print("Current Width: $screenWidth");

            if (kIsWeb) {
              // For web: apply responsive layout based on screen size
              if (screenWidth > 1024) {
                // print("Web/Desktop layout is being used");
                return buildDesktopLayout(
                    cart.itemCount); // Desktop layout for web
              } else if (screenWidth > 600) {
                // print("Web/Tablet layout is being used");
                return buildTabletLayout(
                    cart.itemCount); // Tablet layout for web
              } else {
                // print("Web/Mobile layout is being used");
                return buildMobileLayout(); // Mobile layout for web
              }
            } else {
              // For web: apply responsive layout based on screen size
              if (screenWidth > 1024) {
                // print("Web/Desktop layout is being used");
                return buildDesktopLayout(
                    cart.itemCount); // Desktop layout for web
              } else if (screenWidth > 600) {
                // print("Web/Tablet layout is being used");
                return buildTabletLayout(
                    cart.itemCount); // Tablet layout for web
              } else {
                // print("Web/Mobile layout is being used");
                return buildMobileLayout(); // Mobile layout for web
              }
            }
          },
        ));
  }

  Widget buildTabletLayout(int cartItemCount) {
    return Container(
      color: Colors.white, // Set background color to white
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 20), // Padding for spacing
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Phone Icon and Number on the left
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      FontAwesomeIcons.phone,
                      color: Colors.red,
                      size: 14,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '215-855-4900',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff666666),
                      ),
                    ),
                  ],
                ),
              ),

              // Center logo
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed('home');
                  },
                  child: Center(
                    // Ensures the logo is centered in its section
                    child: Image.asset(
                      'assets/images/logo/indian-grill-logo.png', // Replace with the actual path of the logo
                      height: 80,
                      width: 135, // Adjust logo size
                    ),
                  ),
                ),
              ),

              // VIP Registration, Login, and Cart on the right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .end, // Aligns the text and cart icon to the end of the section
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) {
                        setState(() {
                          _isHovering = true;
                          _isVisible = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isHovering = false;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Blinking Text using Visibility widget
                          Visibility(
                            visible:
                                _isVisible, // Controls the visibility of the text
                            child: Text(
                              'VIP REGISTRATION',
                              style: GoogleFonts.raleway(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Text(
                            ' | LOGIN',
                            style: GoogleFonts.raleway(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 10), // Space between the text and cart row
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).pushNamed('cart');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(
                              8), // Optional: Adjust as needed
                          color: Colors
                              .transparent, // Ensures the entire area is clickable
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                FontAwesomeIcons.basketShopping,
                                color: Colors.red,
                                size: 14,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '$cartItemCount Items',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff444444),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Container(
            color: const Color(0xffE2001A),
            padding: const EdgeInsets.symmetric(
                horizontal: 50), // Horizontal padding for the whole row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Makes sure vertical divider takes full height
              children: [
                // Icon with padding

                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed('home');
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                    child: Icon(
                      FontAwesomeIcons.houseChimney,
                      color: Color(0xffffd602),
                      size: 18,
                    ),
                  ),
                ),

                // Vertical Divider
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),

                // 'Order Online' Text
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed('order-online');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 10),
                    child: Text(
                      'Order Online',
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Vertical Divider
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),

                // 'Catering Enquiry' Text
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed('category-enquiry');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      'Catering Enquiry',
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Vertical Divider
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),

                // 'Banquet' Text
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed('banquet');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      'Banquet',
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Vertical Divider
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),

                // 'Gallery' Text
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed('gallery');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      'Gallery',
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Vertical Divider
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),

                // 'Contact Us' Text
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed('contactus');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      'Contact Us',
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Vertical Divider
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),

                // 'Our Cakes' Text
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed('ourcakes');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      'Our Cakes',
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  // Widget buildMobileLayout() {
  //   return SafeArea(
  //     // <-- Add this
  //     child: Stack(
  //       children: [
  //         Container(
  //           key: _headerKey,
  //           color: Colors.white,
  //           child: Column(
  //             children: [
  //               // Top bar: Phone + Login
  //               // Top bar: Phone + Login/Register
  //               // Container(
  //               //   padding:
  //               //       const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //               //   child: Row(
  //               //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               //     children: [
  //               //       // Phone number
  //               //       const Row(
  //               //         children: [
  //               //           FaIcon(
  //               //             Icons.phone,
  //               //             color: Colors.red,
  //               //             size: 14,
  //               //           ),
  //               //           SizedBox(width: 8),
  //               //           Text(
  //               //             '215-855-4900',
  //               //             style: TextStyle(
  //               //               fontSize: 11,
  //               //               fontWeight: FontWeight.bold,
  //               //               color: Color(0xff666666),
  //               //             ),
  //               //           ),
  //               //         ],
  //               //       ),

  //               //       // Login/Register logic (mobile version)
  //               //       userSession.isLoggedIn
  //               //           ? Row(
  //               //             mainAxisSize: MainAxisSize.min,
  //               //             children: [
  //               //               // 🔹 "My Account" clickable text
  //               //               MouseRegion(
  //               //                 cursor: SystemMouseCursors.click,
  //               //                 onEnter: (_) =>
  //               //                     setState(() => _isHovering = true),
  //               //                 onExit: (_) =>
  //               //                     setState(() => _isHovering = false),
  //               //                 child: GestureDetector(
  //               //                   onTap: () {
  //               //                     GoRouter.of(context)
  //               //                         .pushNamed('my-account');
  //               //                   },
  //               //                   child: Text(
  //               //                     'My Account',
  //               //                     style: GoogleFonts.raleway(
  //               //                       fontSize: 11,
  //               //                       fontWeight: FontWeight.bold,
  //               //                       color: _isHovering
  //               //                           ? Color(0xffe2001A)
  //               //                           : Colors.black,
  //               //                     ),
  //               //                   ),
  //               //                 ),
  //               //               ),

  //               //               // 🔹 Vertical separator "|"
  //               //               const Padding(
  //               //                 padding: EdgeInsets.symmetric(horizontal: 8.0),
  //               //                 child: Text(
  //               //                   '|',
  //               //                   style: TextStyle(
  //               //                     fontSize: 20,
  //               //                     color: Colors.grey,
  //               //                   ),
  //               //                 ),
  //               //               ),

  //               //               // 🔹 "Logout" clickable text
  //               //               MouseRegion(
  //               //                 cursor: SystemMouseCursors.click,
  //               //                 child: GestureDetector(
  //               //                   onTap: () {
  //               //                     GoRouter.of(context).pushNamed('logout');
  //               //                   },
  //               //                   child: Text(
  //               //                     'Logout',
  //               //                     style: GoogleFonts.raleway(
  //               //                       fontSize: 11,
  //               //                       fontWeight: FontWeight.bold,
  //               //                       color: Colors.red,
  //               //                     ),
  //               //                   ),
  //               //                 ),
  //               //               ),
  //               //             ],
  //               //           )
  //               //           : Row(
  //               //               children: [
  //               //                 Visibility(
  //               //                   visible: _isVisible,
  //               //                   child: GestureDetector(
  //               //                     onTap: () {
  //               //                       GoRouter.of(context).pushNamed('login',
  //               //                           extra: {'registration': 'yes'});
  //               //                     },
  //               //                     child: Text(
  //               //                       'VIP REGISTRATION',
  //               //                       style: GoogleFonts.raleway(
  //               //                         fontSize: 11,
  //               //                         fontWeight: FontWeight.bold,
  //               //                         color: Colors.red,
  //               //                       ),
  //               //                     ),
  //               //                   ),
  //               //                 ),
  //               //                 GestureDetector(
  //               //                   onTap: () {
  //               //                     GoRouter.of(context).pushNamed('login',
  //               //                         extra: {'registration': 'no'});
  //               //                   },
  //               //                   child: Text(
  //               //                     ' | LOGIN',
  //               //                     style: GoogleFonts.raleway(
  //               //                       fontSize: 11,
  //               //                       fontWeight: FontWeight.bold,
  //               //                       color: const Color(0xff666666),
  //               //                     ),
  //               //                   ),
  //               //                 ),
  //               //               ],
  //               //             ),
  //               //     ],
  //               //   ),
  //               // ),
  //               // // Second row: Logo + Hamburger
  //               Container(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                 child: SizedBox(
  //                   height: 60,
  //                   child: Stack(
  //                     alignment: Alignment.center,
  //                     children: [
  //                       // LEFT: Hamburger Menu
  //                       Align(
  //                         alignment: Alignment.centerLeft,
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             border: Border.all(
  //                               color: Color(0XFFE2001A),
  //                               width: 1.0,
  //                             ),
  //                             borderRadius: BorderRadius.circular(4),
  //                           ),
  //                           child: SizedBox(
  //                             width: 34,
  //                             height: 31,
  //                             child: IconButton(
  //                               icon: Icon(Icons.menu),
  //                               onPressed: _toggleNavbar,
  //                               iconSize: 18,
  //                               color: const Color(0XFFE2001A),
  //                             ),
  //                           ),
  //                         ),
  //                       ),

  //                       // CENTER: Logo (Always stays in center)
  //                       Center(
  //                         child: GestureDetector(
  //                           onTap: () => GoRouter.of(context).pushNamed('home'),
  //                           child: SizedBox(
  //                             width: 140,
  //                             child: Image.asset(
  //                               'assets/images/logo/Indian-Grill-Logo.png',
  //                               fit: BoxFit.contain,
  //                             ),
  //                           ),
  //                         ),
  //                       ),

  //                       // RIGHT: Cart Icon
  //                       Align(
  //                         alignment: Alignment.centerRight,
  //                         child: GestureDetector(
  //                           onTap: () {
  //                             GoRouter.of(context).pushNamed('cart');
  //                           },
  //                           child: Stack(
  //                             clipBehavior: Clip.none,
  //                             children: [
  //                               Container(
  //                                 padding: const EdgeInsets.all(8),
  //                                 decoration: BoxDecoration(
  //                                   color: Color(0XFFE2001A),
  //                                   borderRadius: BorderRadius.circular(6),
  //                                 ),
  //                                 child: const Icon(
  //                                   Icons.shopping_cart_outlined,
  //                                   color: Colors.white,
  //                                 ),
  //                               ),

  //                               // Cart badge
  //                               Positioned(
  //                                 right: -4,
  //                                 top: -4,
  //                                 child: Consumer<Cart>(
  //                                   builder: (context, cart, child) {
  //                                     return Container(
  //                                       padding: const EdgeInsets.all(5),
  //                                       decoration: const BoxDecoration(
  //                                         color: Colors.red,
  //                                         shape: BoxShape.circle,
  //                                       ),
  //                                       child: Text(
  //                                         '${cart.itemCount}',
  //                                         style: const TextStyle(
  //                                           color: Colors.white,
  //                                           fontSize: 10,
  //                                           fontWeight: FontWeight.bold,
  //                                         ),
  //                                       ),
  //                                     );
  //                                   },
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildMobileLayout() {
    final cart = Provider.of<Cart>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Drawer icon
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open drawer
            },
          ),

          // Center: Logo
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  context.go('/'); // Navigate to homepage
                },
                child: Image.asset(
                  'assets/images/logo/Indian-Grill-Logo.png',
                  fit: BoxFit.contain,
                  height: 50,
                ),
              ),
            ),
          ),

          // Right: Cart with badge
          Stack(
            clipBehavior: Clip.none, // allow badge to overflow
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  GoRouter.of(context)
                      .pushNamed('cart'); // navigate to cart page
                },
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Center(
                      child: Text(
                        cart.itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNavbar() {
    return Container(
      width: MediaQuery.of(context).size.width, // Full width
      color: const Color(0xffE2001A),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Home
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('home');
              setState(() {
                _isNavbarOpen = false; // close navbar after tap
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'Home123',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Order Online
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('orderOnline');
              setState(() {
                _isNavbarOpen = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'Order Online',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Catering Enquiry
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('cateringEnquiry');
              setState(() {
                _isNavbarOpen = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'Catering Enquiry',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Banquet (Expandable menu)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isBanquetExpanded = !_isBanquetExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Banquet Hello',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        _isBanquetExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),

              // Submenu items (visible only when expanded)
              if (_isBanquetExpanded) ...[
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed('banquetHall1');
                    setState(() {
                      _isNavbarOpen = false;
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Text(
                      'Banquet Hall 1',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed('banquetHall2');
                    setState(() {
                      _isNavbarOpen = false;
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Text(
                      'Banquet Hall 2',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Gallery
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('gallery');
              setState(() {
                _isNavbarOpen = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'Gallery',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Contact Us
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('contactUs');
              setState(() {
                _isNavbarOpen = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'Contact Us',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Our Cakes
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('ourCakes');
              setState(() {
                _isNavbarOpen = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'Our Cakes',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDesktopLayout(int cartItemCount) {
    return Container(
      color: Colors.white, // Set background color to white
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 190), // Padding for spacing
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Phone Icon and Number on the left
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.red,
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '215-855-4900',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff666666),
                      ),
                    ),
                  ],
                ),
              ),

              // Center logo
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed('home');
                  },
                  child: Center(
                    // Ensures the logo is centered in its section
                    child: Image.asset(
                      'assets/images/logo/Indian-Grill-Logo.png', // Replace with the actual path of the logo
                      height: 90,
                      width: 150, // Adjust logo size
                    ),
                  ),
                ),
              ),

              // VIP Registration, Login, and Cart on the right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .end, // Aligns the text and cart icon to the end of the section
                  children: [
                    userSession.isLoggedIn
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 🔹 "My Account" clickable text
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_) =>
                                    setState(() => _isHovering = true),
                                onExit: (_) =>
                                    setState(() => _isHovering = false),
                                child: GestureDetector(
                                  onTap: () {
                                    GoRouter.of(context)
                                        .pushNamed('my-account');
                                  },
                                  child: Text(
                                    'My Account',
                                    style: GoogleFonts.raleway(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _isHovering
                                          ? Color(0xffe2001A)
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),

                              // 🔹 Vertical separator "|"
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '|',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),

                              // 🔹 "Logout" clickable text
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    GoRouter.of(context).pushNamed('logout');
                                  },
                                  child: Text(
                                    'Logout',
                                    style: GoogleFonts.raleway(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        // Don't show anything
                        : MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) {
                              setState(() {
                                _isHovering = true;
                                _isVisible = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                _isHovering = false;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Blinking Text using Visibility widget
                                Visibility(
                                  visible: _isVisible,
                                  child: GestureDetector(
                                    onTap: () {
                                      // print('Register tapped');
                                      GoRouter.of(context).pushNamed('login',
                                          extra: {'registration': 'yes'});
                                    },
                                    child: Text(
                                      'VIP REGISTRATION',
                                      style: GoogleFonts.raleway(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    GoRouter.of(context).pushNamed(
                                      'login',
                                      extra: {'registration': 'no'},
                                    );
                                  },
                                  child: Text(
                                    ' | LOGIN',
                                    style: GoogleFonts.raleway(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff666666),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(
                        height: 10), // Space between the text and cart row
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => _isCartHovering = true),
                      onExit: (_) => setState(() => _isCartHovering = false),
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).pushNamed('cart');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              color: Color(0xffe2001a), // hover color
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '$cartItemCount Items',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _isCartHovering
                                    ? Color(0xffe2001a) // hover color
                                    : const Color(0xff444444),
                              ),
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
        IntrinsicHeight(
          child: Container(
            color: const Color(0xffE2001A),
            padding: const EdgeInsets.symmetric(
                horizontal: 400), // Horizontal padding for the whole row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, // Makes sure vertical divider takes full height
              children: [
                // Icon with padding

                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed('home');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 10),
                      color: Colors.transparent,
                      child: const Icon(
                        Icons.house,
                        color: Color(0xffffd602),
                        size: 22,
                      ),
                    ),
                  ),
                ),

                // Vertical Divider
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                  width: 10, // Adds space around the divider if needed
                ),

                // 'Order Online' Text

                HoverTextTab(
                  label: 'Order Online',
                  onTap: () {
                    GoRouter.of(context).pushNamed('order-online');
                  },
                ),

                // Vertical Divider
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),

                // 'Catering Enquiry' Text
                HoverTextTab(
                  label: 'Catering Enquiry',
                  onTap: () {
                    GoRouter.of(context).pushNamed('category-enquiry');
                  },
                ),

                // Vertical Divider
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),

                // 'Banquet' Text
                HoverDropdownMenu(
                  items: [
                    DropdownMenuItemData(
                        label: 'Banquets',
                        onTap: () => GoRouter.of(context).pushNamed('banquet')),
                    DropdownMenuItemData(
                        label: 'Menu',
                        onTap: () =>
                            GoRouter.of(context).pushNamed('banquet-menu')),
                  ],
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context)
                            .pushNamed('banquet'); // Main page route
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        color: Colors.transparent,
                        child: Text(
                          'Banquet',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Vertical Divider
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),

                // 'Gallery' Text
                HoverTextTab(
                  label: 'Gallery',
                  onTap: () {
                    GoRouter.of(context).pushNamed('gallery');
                  },
                ),

                // Vertical Divider
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),

                // 'Contact Us' Text
                HoverDropdownMenu(
                  items: [
                    DropdownMenuItemData(
                        label: 'Contact Us',
                        onTap: () =>
                            GoRouter.of(context).pushNamed('contactus')),
                    DropdownMenuItemData(
                        label: 'About Us',
                        onTap: () =>
                            GoRouter.of(context).pushNamed('about-us')),
                    DropdownMenuItemData(
                        label: 'Career',
                        onTap: () => GoRouter.of(context).pushNamed('career')),
                  ],
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context)
                            .pushNamed('contactus'); // Main page route
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        color: Colors.transparent,
                        child: Text(
                          'Contact Us',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Vertical Divider
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),

                // 'Our Cakes' Text
                HoverTextTab(
                  label: 'Our Cakes',
                  onTap: () {
                    GoRouter.of(context).pushNamed('ourcakes');
                  },
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class HoverTextTab extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final TextStyle? baseStyle;
  final Color hoverColor;

  const HoverTextTab({
    Key? key,
    required this.label,
    required this.onTap,
    this.baseStyle,
    this.hoverColor = Colors.yellow, // or any hover color you want
  }) : super(key: key);

  @override
  _HoverTextTabState createState() => _HoverTextTabState();
}

class _HoverTextTabState extends State<HoverTextTab> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = widget.baseStyle ??
        GoogleFonts.raleway(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
          color: Colors.transparent,
          child: Text(
            widget.label,
            style: defaultStyle.copyWith(
              color: _isHovering ? widget.hoverColor : defaultStyle.color,
            ),
          ),
        ),
      ),
    );
  }
}
