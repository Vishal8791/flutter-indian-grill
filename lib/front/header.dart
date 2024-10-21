import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool _isVisible = true; // Visibility toggle for blinking effect

  @override
  void initState() {
    super.initState();
    // Create a timer that toggles the visibility every second (1 second)
    Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        _isVisible = !_isVisible; // Toggle the visibility
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set background color to white
      child: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(
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
                child: Center(
                  // Ensures the logo is centered in its section
                  child: Image.asset(
                    'assets/images/logo/indian-grill-logo.png', // Replace with the actual path of the logo
                    height: 90,
                    width: 150, // Adjust logo size
                  ),
                ),
              ),

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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Text(
                          ' | LOGIN',
                          style: GoogleFonts.raleway(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff666666),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        height: 10), // Space between the text and cart row
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          FontAwesomeIcons.basketShopping,
                          color: Colors.red,
                          size: 14,
                        ),
                         SizedBox(width: 5),
                         Text(
                          '0 Items',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff444444),
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
        IntrinsicHeight(
  child: Container(
    color: Color(0xffE2001A),
    padding: EdgeInsets.symmetric(horizontal: 400), // Horizontal padding for the whole row
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch, // Makes sure vertical divider takes full height
      children: [
        // Icon with padding

        GestureDetector(
          onTap: () {
            GoRouter.of(context).pushNamed('home');
   
              },
       child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 18,horizontal: 10),
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
          width: 10, // Adds space around the divider if needed
        ),
        
        // 'Order Online' Text
        GestureDetector(
          onTap: () {
            GoRouter.of(context).pushNamed('order_online');
                 },
       child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18,horizontal: 10),
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
        VerticalDivider(
          color: Colors.white,
          thickness: 1,
        ),

        // 'Catering Enquiry' Text
        GestureDetector(
          onTap: () {
            GoRouter.of(context).pushNamed('category_enquiry');
   
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
        VerticalDivider(
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
        VerticalDivider(
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
        VerticalDivider(
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
        VerticalDivider(
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
}
