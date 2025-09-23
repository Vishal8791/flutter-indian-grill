import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding:
          const EdgeInsets.only(top: 25, left: 100, right: 100, bottom: 25),
      child: Row(
        children: [
          const SizedBox(
            width: 100,
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: Color(0xfff1f1f1),
                  thickness: 0.5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                  child: Text(
                    'BILLING & SHIPPING',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff666666),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const Divider(
                  color: Color(0xfff1f1f1),
                  thickness: 0.5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "First Name",
                          labelStyle: GoogleFonts.raleway(
                            // Grey label with custom font
                            color: Colors.grey,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red), // Red underline on focus
                          ),
                        ),
                        style: GoogleFonts.raleway(), // Font for input text
                      ),
                    ),
                    const SizedBox(width: 20), // spacing between the fields
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          labelStyle: GoogleFonts.raleway(
                            // Grey label with custom font
                            color: Colors.grey,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red), // Red underline on focus
                          ),
                        ),
                        style: GoogleFonts.raleway(), // Font for input text
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "First Name",
                          labelStyle: GoogleFonts.raleway(
                            // Grey label with custom font
                            color: Colors.grey,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red), // Red underline on focus
                          ),
                        ),
                        style: GoogleFonts.raleway(), // Font for input text
                      ),
                    ),
                    const SizedBox(width: 20), // spacing between the fields
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          labelStyle: GoogleFonts.raleway(
                            // Grey label with custom font
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red), // Red underline on focus
                          ),
                        ),
                        style: GoogleFonts.raleway(
                            fontSize: 12), // Font for input text
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "First Name",
                          labelStyle: GoogleFonts.raleway(
                            // Grey label with custom font
                            color: Colors.grey,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red), // Red underline on focus
                          ),
                        ),
                        style: GoogleFonts.raleway(), // Font for input text
                      ),
                    ),
                    const SizedBox(width: 20), // spacing between the fields
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          labelStyle: GoogleFonts.raleway(
                            // Grey label with custom font
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red), // Red underline on focus
                          ),
                        ),
                        style: GoogleFonts.raleway(
                            fontSize: 12), // Font for input text
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 50,
          ),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Information',
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff3a0d0d),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              )),
          const SizedBox(
            width: 100,
          )
        ],
      ),
    );
  }
}
