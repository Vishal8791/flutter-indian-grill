// aboutus.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(builder: (context, Constraints) {
        double screenWidth = Constraints.maxWidth;

        if (kIsWeb) {
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
      }),
    );
  }

  Widget buildDesktopLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(190, 30, 190, 50),
      child: Align(
        child: Column(
          children: [
            Container(
              color: const Color(0xfff1f1f1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/uploads/2016/11/IMG_0118.jpg',
                            width: 570,
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(50),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Who we are',
                                    style: GoogleFonts.raleway(
                                      fontSize: 22,
                                      color: const Color(0xffe2001a),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'We are Located in the Heart of Montgomery County on RT 309 . We are Just two blocks away from the Montgomery mall. We invite you to come and enjoy the authentic taste of our time-honored Indian cooking. Inside, you’ll find fast-food dining that provides you a comfortable and friendly environment. Indian Grill takes pride in preparing your meals exactly the way you like it: hot, fresh, and made from scratch everyday. Our team of professional, quality chefs use only the best herbs and spices, putting together a feast for your senses. The variety in our menu is filled with flavorful meals fit for children, adults, and seniors. We are ready to serve when you’re ready to eat.',
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      color: const Color(0xff666666),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Our Goal is to provide you fresh and healthy food as quick as possible.'
                                        .toUpperCase(),
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      color: const Color(0xff666666),
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ]),
                          )
                        ],
                      )),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 100),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Business Info'.toUpperCase(),
                                  style: GoogleFonts.raleway(
                                    fontSize: 22,
                                    color: const Color(0xffe2001a),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Divider(
                                    color: Color(0xffe5e5e5), // Divider color
                                    thickness: 1, // Divider thickness
                                    height: 20, // Space around the divider
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Business Details',
                                  style: GoogleFonts.raleway(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            'Cuisine',
                                            style: GoogleFonts.raleway(
                                              color: const Color(0xff666666),
                                              fontSize: 13,
                                            ),
                                          )),
                                      Expanded(
                                          flex: 8,
                                          child: Text(
                                            'buffets, fast food and indian/pakistani',
                                            style: GoogleFonts.raleway(
                                              color: const Color(0xff666666),
                                              fontSize: 13,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Parking',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                    Expanded(
                                        flex: 8,
                                        child: Text(
                                          'Parking Lot Parking',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Price Range',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                    Expanded(
                                        flex: 8,
                                        child: Text(
                                          '\$',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Specialties Serves',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                    Expanded(
                                        flex: 8,
                                        child: Text(
                                          'lunch and dinner',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Services',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                    Expanded(
                                        flex: 8,
                                        child: Text(
                                          'Walk-Ins Welcome\nGood For Groups\nGood For Kids\nTake Out\nDelivery\nCatering\nWaiter Service',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                  ],
                                ),
                              ]),
                        ],
                      )),
                  Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/uploads/2016/11/dine-in-area.jpg',
                            width: 570,
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Column(
              children: [
                // Main Container with testimonials
                Container(
                  padding: const EdgeInsets.only(top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Ensure alignment from the start
                    children: [
                      // First Testimonial
                      SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Align icon and text centrally
                          children: [
                            const Icon(
                              FontAwesomeIcons.quoteRight,
                              color: Colors.red,
                              size: 40,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Great food! come here regularly and have yet to have a bad experience!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Pat Gehman",
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Second Testimonial
                      SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.quoteRight,
                              color: Colors.red,
                              size: 40,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Spent New Years in Goa, and their chicken chettinad brought back some brilliant memories!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Ryan Mills",
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Third Testimonial
                      SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.quoteRight,
                              color: Colors.red,
                              size: 40,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "A favorite restaurant for my son, my boyfriend & I! We love the chicken makhani, pav baji, & chicken chettinad!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Stephanie Wilson",
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Red bullet below the testimonials
                const SizedBox(
                    height: 20), // Space between container and bullet
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildMobileLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Align(
        child: Column(
          children: [
            Container(
              color: const Color(0xfff1f1f1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/images/uploads/2016/11/IMG_0118.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Who we are',
                                style: GoogleFonts.raleway(
                                  fontSize: 22,
                                  color: const Color(0xffe2001a),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'We are Located in the Heart of Montgomery County on RT 309 . We are Just two blocks away from the Montgomery mall. We invite you to come and enjoy the authentic taste of our time-honored Indian cooking. Inside, you’ll find fast-food dining that provides you a comfortable and friendly environment. Indian Grill takes pride in preparing your meals exactly the way you like it: hot, fresh, and made from scratch everyday. Our team of professional, quality chefs use only the best herbs and spices, putting together a feast for your senses. The variety in our menu is filled with flavorful meals fit for children, adults, and seniors. We are ready to serve when you’re ready to eat.',
                                style: GoogleFonts.raleway(
                                  fontSize: 14,
                                  color: const Color(0xff666666),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Text(
                                'Our Goal is to provide you fresh and healthy food as quick as possible.'
                                    .toUpperCase(),
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ]),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Image.asset(
                              'assets/images/uploads/2016/11/dine-in-area.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Business Info'.toUpperCase(),
                              style: GoogleFonts.raleway(
                                fontSize: 22,
                                color: const Color(0xffe2001a),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Divider(
                                color: Color(0xffe5e5e5), // Divider color
                                thickness: 1, // Divider thickness
                                height: 20, // Space around the divider
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Business Details',
                              style: GoogleFonts.raleway(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Cuisine',
                                        style: GoogleFonts.raleway(
                                          color: const Color(0xff666666),
                                          fontSize: 13,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 8,
                                      child: Text(
                                        'buffets, fast food and indian/pakistani',
                                        style: GoogleFonts.raleway(
                                          color: const Color(0xff666666),
                                          fontSize: 13,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Parking',
                                      style: GoogleFonts.raleway(
                                        color: const Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )),
                                Expanded(
                                    flex: 8,
                                    child: Text(
                                      'Parking Lot Parking',
                                      style: GoogleFonts.raleway(
                                        color: const Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Price Range',
                                      style: GoogleFonts.raleway(
                                        color: const Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )),
                                Expanded(
                                    flex: 8,
                                    child: Text(
                                      '\$',
                                      style: GoogleFonts.raleway(
                                        color: const Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Specialties Serves',
                                      style: GoogleFonts.raleway(
                                        color: const Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )),
                                Expanded(
                                    flex: 8,
                                    child: Text(
                                      'lunch and dinner',
                                      style: GoogleFonts.raleway(
                                        color: const Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Services',
                                      style: GoogleFonts.raleway(
                                        color: const Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )),
                                Expanded(
                                    flex: 8,
                                    child: Text(
                                      'Walk-Ins Welcome\nGood For Groups\nGood For Kids\nTake Out\nDelivery\nCatering\nWaiter Service',
                                      style: GoogleFonts.raleway(
                                        color: const Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )),
                              ],
                            ),
                          ]),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Ensure alignment from the start
                children: [
                  // First Testimonial
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Align icon and text centrally
                      children: [
                        const Icon(
                          FontAwesomeIcons.quoteRight,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Great food! come here regularly and have yet to have a bad experience!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Pat Gehman",
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Second Testimonial
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.quoteRight,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Spent New Years in Goa, and their chicken chettinad brought back some brilliant memories!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Ryan Mills",
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Third Testimonial
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.quoteRight,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "A favorite restaurant for my son, my boyfriend & I! We love the chicken makhani, pav baji, & chicken chettinad!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Stephanie Wilson",
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Red bullet below the testimonials
            const SizedBox(height: 20), // Space between container and bullet
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabletLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Align(
        child: Column(
          children: [
            Container(
                color: const Color(0xfff1f1f1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Side with the Image
                    Expanded(
                      flex: 5,
                      child: Image.asset(
                        'assets/images/uploads/2016/11/IMG_0118.jpg',
                        fit: BoxFit.cover, // Ensures the image covers the area
                        height: 600,
                      ),
                    ),
                    // Right Side with the Text
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Who we are',
                                  style: GoogleFonts.raleway(
                                    fontSize: 22,
                                    color: const Color(0xffe2001a),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'We are Located in the Heart of Montgomery County on RT 309. We are just two blocks away from the Montgomery mall. We invite you to come and enjoy the authentic taste of our time-honored Indian cooking. Inside, you’ll find fast-food dining that provides you a comfortable and friendly environment. Indian Grill takes pride in preparing your meals exactly the way you like it: hot, fresh, and made from scratch everyday. Our team of professional, quality chefs use only the best herbs and spices, putting together a feast for your senses. The variety in our menu is filled with flavorful meals fit for children, adults, and seniors. We are ready to serve when you’re ready to eat.',
                                  style: GoogleFonts.raleway(
                                    fontSize: 14,
                                    color: const Color(0xff666666),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Our Goal is to provide you fresh and healthy food as quick as possible.'
                                      .toUpperCase(),
                                  style: GoogleFonts.raleway(
                                    fontSize: 14,
                                    color: const Color(0xff666666),
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            Container(
              padding: const EdgeInsets.only(top: 100),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Business Info'.toUpperCase(),
                                  style: GoogleFonts.raleway(
                                    fontSize: 22,
                                    color: const Color(0xffe2001a),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Divider(
                                    color: Color(0xffe5e5e5), // Divider color
                                    thickness: 1, // Divider thickness
                                    height: 20, // Space around the divider
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Business Details',
                                  style: GoogleFonts.raleway(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            'Cuisine',
                                            style: GoogleFonts.raleway(
                                              color: const Color(0xff666666),
                                              fontSize: 13,
                                            ),
                                          )),
                                      Expanded(
                                          flex: 8,
                                          child: Text(
                                            'buffets, fast food and indian/pakistani',
                                            style: GoogleFonts.raleway(
                                              color: const Color(0xff666666),
                                              fontSize: 13,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Parking',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                    Expanded(
                                        flex: 8,
                                        child: Text(
                                          'Parking Lot Parking',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Price Range',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                    Expanded(
                                        flex: 8,
                                        child: Text(
                                          '\$',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Specialties Serves',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                    Expanded(
                                        flex: 8,
                                        child: Text(
                                          'lunch and dinner',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Services',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                    Expanded(
                                        flex: 8,
                                        child: Text(
                                          'Walk-Ins Welcome\nGood For Groups\nGood For Kids\nTake Out\nDelivery\nCatering\nWaiter Service',
                                          style: GoogleFonts.raleway(
                                            color: const Color(0xff666666),
                                            fontSize: 13,
                                          ),
                                        )),
                                  ],
                                ),
                              ]),
                        ],
                      )),
                  Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Expanded(
                            child: Image.asset(
                              'assets/images/uploads/2016/11/dine-in-area.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Ensure alignment from the start
                children: [
                  // First Testimonial
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Align icon and text centrally
                      children: [
                        const Icon(
                          FontAwesomeIcons.quoteRight,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Great food! come here regularly and have yet to have a bad experience!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Pat Gehman",
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Second Testimonial
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.quoteRight,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Spent New Years in Goa, and their chicken chettinad brought back some brilliant memories!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Ryan Mills",
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Third Testimonial
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.quoteRight,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "A favorite restaurant for my son, my boyfriend & I! We love the chicken makhani, pav baji, & chicken chettinad!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Stephanie Wilson",
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Red bullet below the testimonials
            const SizedBox(height: 20), // Space between container and bullet
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
