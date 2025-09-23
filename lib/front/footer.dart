import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  bool _addressClicked = false;
  bool _isHovering = false;
  void openMap(String address) async {
    final query = Uri.encodeComponent(address);
    final googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$query";

    final uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      setState(() {
        _addressClicked = true; // mark as clicked
      });
    } else {
      throw 'Could not open the map for $address';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    final addressColor = _addressClicked
        ? Colors.red
        : (_isHovering && isDesktop ? Colors.red : const Color(0xff444444));

    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          if (screenWidth > 1024) {
            return buildDesktopLayout(context, addressColor);
          } else if (screenWidth > 600) {
            return buildTabletLayout(context, addressColor);
          } else {
            return buildMobileLayout(context, addressColor);
          }
        },
      ),
    );
  }

  Widget buildDesktopLayout(BuildContext context, Color addressColor) {
    return Container(
      color: const Color(0xfff1f1f1),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(190, 80, 190, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CONTACT SECTION
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Center vertically
                    children: [
                      Text(
                        'CONTACT',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            _isHovering = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _isHovering = false;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            openMap(
                                'Indian Grill, HotBreads Cake & Curries, 969 Bethleham Pike, Montgomeryville PA 18936');
                            setState(() {
                              _addressClicked = true;
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Indian Grill',
                                style: GoogleFonts.raleway(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: addressColor,
                                ),
                              ),
                              Text(
                                'HotBreads Cake & Curries',
                                style: GoogleFonts.raleway(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: addressColor,
                                ),
                              ),
                              Text(
                                '969 Bethleham Pike',
                                style: GoogleFonts.raleway(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: addressColor,
                                ),
                              ),
                              Text(
                                'Montgomeryville PA 18936',
                                style: GoogleFonts.raleway(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: addressColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          FaIcon(
                            Icons.phone,
                            size: 18,
                            color: Color(0xff444444),
                          ),
                          SizedBox(width: 5),
                          Text(
                            '215-855-4900',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff444444),
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          FaIcon(
                            Icons.email,
                            size: 18,
                            color: Color(0xff444444),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'contact@indian-grill.com',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff444444),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // RESTAURANT TIMING SECTION
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Center vertically
                    children: [
                      Text(
                        'RESTAURANT TIMING',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Open 7 days Week',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Monday to Thursday',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          '11:30 AM to 9:30 PM',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Friday & Saturday',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          '11:30 AM to 10:30 PM',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Sunday',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 30),
                        child: Text(
                          '11:30 AM to 9:30 PM',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // COUPONS SECTION
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Center vertically
                    children: [
                      Text(
                        'COUPONS',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 5),
                        child: Text(
                          'COMING SOON',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: const Color(0xff666666),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          'Career',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: const Color(0xff444444),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).pushNamed('privacy-policy');
                            },
                            child: Text(
                              'Privacy Policy',
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                color: const Color(0xff444444),
                                fontWeight: FontWeight.w700,
                              ),
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
          Container(
              padding: const EdgeInsets.fromLTRB(190, 20, 190, 20),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white, // Set the top border color to white
                    width: 1.0, // Adjust the border width as needed
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Design and Developed by - ',
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: const Color(0xff888888),
                    ),
                  ),
                  Text(
                    ' OpenSource Technologies ',
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    ' © 2016-2025 ',
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: const Color(0xff888888),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget buildTabletLayout(BuildContext context, Color addressColor) {
    return Container(
      color: const Color(0XFFF1F1F1),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(50, 50, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CONTACT SECTION
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Center vertically
                    children: [
                      Text(
                        'CONTACT',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => openMap(
                          'Indian Grill, HotBreads Cake & Curries, 969 Bethleham Pike, Montgomeryville PA 18936',
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Indian Grill',
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _addressClicked
                                    ? Colors.red
                                    : const Color(0xff444444),
                              ),
                            ),
                            Text(
                              'HotBreads Cake & Curries',
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _addressClicked
                                    ? Colors.red
                                    : const Color(0xff444444),
                              ),
                            ),
                            Text(
                              '969 Bethleham Pike',
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _addressClicked
                                    ? Colors.red
                                    : const Color(0xff444444),
                              ),
                            ),
                            Text(
                              'Montgomeryville PA 18936',
                              style: GoogleFonts.raleway(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _addressClicked
                                    ? Colors.red
                                    : const Color(0xff444444),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          FaIcon(
                            Icons.phone,
                            size: 18,
                            color: Color(0xff444444),
                          ),
                          SizedBox(width: 5),
                          Text(
                            '215-855-4900',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff444444),
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          FaIcon(
                            Icons.email,
                            size: 18,
                            color: Color(0xff444444),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'contact@indian-grill.com',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff444444),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // RESTAURANT TIMING SECTION
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Center vertically
                    children: [
                      Text(
                        'RESTAURANT TIMING',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Open 7 days Week',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Monday to Thursday',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          '11:30 AM to 9:30 PM',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Friday & Saturday',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          '11:30 AM to 10:30 PM',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Sunday',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 30),
                        child: Text(
                          '11:30 AM to 9:30 PM',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // COUPONS SECTION
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Center vertically
                    children: [
                      Text(
                        'COUPONS',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 5),
                        child: Text(
                          'COMING SOON',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: const Color(0xff666666),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: GestureDetector(
                          onTap: () {
                            GoRouter.of(context).pushNamed('career');
                          },
                          child: Text(
                            'Career',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: const Color(0xff444444),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: GestureDetector(
                          onTap: () {
                            GoRouter.of(context).pushNamed('privacy-policy');
                          },
                          child: Text(
                            'Privacy Policy',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: const Color(0xff444444),
                              fontWeight: FontWeight.w700,
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
          Container(
              padding: const EdgeInsets.fromLTRB(50, 30, 80, 30),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white, // Set the top border color to white
                    width: 1.0, // Adjust the border width as needed
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Design and Developed by - ',
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: const Color(0xff888888),
                    ),
                  ),
                  Text(
                    ' OpenSource Technologies ',
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    ' © 2016-2025 ',
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: const Color(0xff888888),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget buildMobileLayout(BuildContext context, Color addressColor) {
    return Container(
      color: const Color(0XFFF1F1F1),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // CONTACT SECTION
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Center vertically
                  children: [
                    Text(
                      'CONTACT',
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => openMap(
                        'Indian Grill, HotBreads Cake & Curries, 969 Bethleham Pike, Montgomeryville PA 18936',
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Indian Grill',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _addressClicked
                                  ? Colors.red
                                  : const Color(0xff444444),
                            ),
                          ),
                          Text(
                            'HotBreads Cake & Curries',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _addressClicked
                                  ? Colors.red
                                  : const Color(0xff444444),
                            ),
                          ),
                          Text(
                            '969 Bethleham Pike',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _addressClicked
                                  ? Colors.red
                                  : const Color(0xff444444),
                            ),
                          ),
                          Text(
                            'Montgomeryville PA 18936',
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _addressClicked
                                  ? Colors.red
                                  : const Color(0xff444444),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          Icons.phone,
                          size: 18,
                          color: Color(0xff444444),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '215-855-4900',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff444444),
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          Icons.email,
                          size: 18,
                          color: Color(0xff444444),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'contact@indian-grill.com',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff444444),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center vertically
                  children: [
                    Text(
                      'RESTAURANT TIMING',
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'Open 7 days Week',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'Monday to Thursday',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        '11:30 AM to 9:30 PM',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'Friday & Saturday',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        '11:30 AM to 10:30 PM',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'Sunday',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 30),
                      child: Text(
                        '11:30 AM to 9:30 PM',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center vertically
                  children: [
                    Text(
                      'COUPONS',
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 5),
                      child: Text(
                        'COMING SOON',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: const Color(0xff666666),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).pushNamed('career');
                        },
                        child: Text(
                          'Career',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: const Color(0xff444444),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).pushNamed('privacy-policy');
                        },
                        child: Text(
                          'Privacy Policy',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: const Color(0xff444444),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white, // Set the top border color to white
                  width: 1.0, // Adjust the border width as needed
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Design and Developed by - ',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: const Color(0xff888888),
                      ),
                    ),
                    Text(
                      ' OpenSource Technologies ',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4), // Optional space between lines
                Text(
                  ' © 2016-2025 ',
                  style: GoogleFonts.raleway(
                    fontSize: 12,
                    color: const Color(0xff888888),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
