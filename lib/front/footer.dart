import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff1f1f1), // Background color of the footer
      // Set a fixed height for the footer
      child: Column(
        children: [
          Container(
             padding: const EdgeInsets.fromLTRB(190, 80, 190, 10),
          child:Row(
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
                    Text(
                      'Indian Grill',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff444444),
                      ),
                    ),
                    Text(
                      'HotBreads Cake & Curries',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff444444),
                      ),
                    ),
                    Text(
                      '969 Bethleham Pike',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff444444),
                      ),
                    ),
                    Text(
                      'Montgomeryville PA 18936',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff444444),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.phone,
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
                        Icon(
                          FontAwesomeIcons.envelope,
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
                      child: Text(
                        'Privacy Policy',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: const Color(0xff444444),
                          fontWeight: FontWeight.w700,
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
                      color: Color(0xff888888),
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
                    ' © 2016-2024 ',
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: Color(0xff888888),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
