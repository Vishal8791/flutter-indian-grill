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

class _HeaderState extends State<Header> {
  bool _isNavbarOpen = false;
  bool _isVisible = true;
  bool _isHovering = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startBlinking();
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

  @override
  void dispose() {
    _stopBlinking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Container(
        color: Colors.white,
        child: LayoutBuilder(
          builder: (context, Constraints) {
            double screenWidth = Constraints.maxWidth;
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

  Widget buildMobileLayout() {
    return Stack(children: [
      Container(
        color: Colors.white, // Set background color to white
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff666666),
                        ),
                      ),
                    ],
                  ),
                ),

                // Center logo

                // VIP Registration, Login, and Cart on the right
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .end, // Aligns the text and cart icon to the end of the section
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Blinking Text using Visibility widget
                          Visibility(
                            visible:
                                _isVisible, // Controls the visibility of the text
                            child: Text(
                              'VIP REGISTRATION',
                              style: GoogleFonts.raleway(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Text(
                            ' | LOGIN',
                            style: GoogleFonts.raleway(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff666666),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Aligns elements at both ends
                  children: [
                    // Logo aligned to the left
                    Expanded(
                      flex:
                          1, // Optional: Controls how much space the logo takes
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).pushNamed('home');
                        },
                        child: Align(
                          alignment: Alignment
                              .centerLeft, // Ensures logo is aligned left
                          child: Image.asset(
                            'assets/images/logo/indian-grill-logo.png', // Replace with the actual path of the logo
                            height: 60, // Adjust height of the logo
                            width: 120, // Adjust width of the logo
                          ),
                        ),
                      ),
                    ),

                    // Three-line icon (Hamburger Menu) aligned to the right

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0XFFE2001A), // Red border color
                          width: 1.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(
                            4), // Optional: Rounded corners for the border
                      ),
                      child: SizedBox(
                        width:
                            34, // Set a specific width for the rectangular shape
                        height:
                            31, // Set a specific height for the rectangular shape
                        child: IconButton(
                          icon: const Icon(
                              FontAwesomeIcons.bars), // Hamburger menu icon
                          onPressed: () {
                            // Toggle navbar visibility
                            setState(() {
                              _isNavbarOpen = !_isNavbarOpen;
                            });
                            // Add your logic here to open the collapsible navbar
                            print('Menu icon tapped!');
                          },
                          iconSize: 18, // Adjust icon size as needed
                          color:
                              const Color(0XFFE2001A), // Icon color set to red
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
      if (_isNavbarOpen)
        Positioned(
          top:
              100, // Adjust this based on the height of the logo and other elements
          left: MediaQuery.of(context).size.width / 2 - 200, // Centering logic
          child: Container(
            width: 250, // Set the width of the navbar
            color: const Color(0xffE2001A), // Background color of the navbar
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavbar(), // Call the method to build the navbar
              ],
            ),
          ),
        ),
    ]);
  }

  Widget _buildNavbar() {
    return Container(
      width: 400,
      color: const Color(0xffE2001A),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Add your navbar items here
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('home');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              child: Text(
                'Home',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('home');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              child: Text(
                'Home',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('home');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              child: Text(
                'Home',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('home');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              child: Text(
                'Home',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('home');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              child: Text(
                'Home',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Add more items similarly...
          // E.g., 'Order Online', 'Catering Enquiry', etc.
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
                      FontAwesomeIcons.phone,
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
                      'assets/images/logo/indian-grill-logo.png', // Replace with the actual path of the logo
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
                        ? SizedBox(
                          child:MouseRegion(
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
                         child: GestureDetector(
                                    onTap: () {
                                      // print('Register tapped');
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
                        ) // Don't show anything
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
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).pushNamed('cart');
                      },
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
                        FontAwesomeIcons.houseChimney,
                        color: Color(0xffffd602),
                        size: 18,
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
                            .pushNamed('banquet'); // Main page route
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
