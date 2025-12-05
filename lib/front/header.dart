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
  HeaderState createState() => HeaderState();
}

class HeaderState extends State<Header> with SingleTickerProviderStateMixin {

  bool _isVisible = true;
  bool _isHovering = false;
  Timer? _timer;

  OverlayEntry? _overlayEntry;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller and slide animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

  

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
                      'assets/images/logo/indian-grill-logo.webp', // Replace with the actual path of the logo
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
                  'assets/images/logo/Indian-Grill-Logo.webp',
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
                      'assets/images/logo/Indian-Grill-Logo.webp', // Replace with the actual path of the logo
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
                                        .pushNamed('my_account');
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
    super.key,
    required this.label,
    required this.onTap,
    this.baseStyle,
    this.hoverColor = Colors.yellow, // or any hover color you want
  });

  @override
  HoverTextTabState createState() => HoverTextTabState();
}

class HoverTextTabState extends State<HoverTextTab> {
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
