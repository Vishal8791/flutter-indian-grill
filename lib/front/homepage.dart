// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart'; // Correct import for CarouselSlider
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Current index of the carousel

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Enable scrolling
      child: Column(
        children: [
          SizedBox(
            height: 475,

            // Remove any additional padding
            child: CarouselSlider(
              items: [
                ClipRRect(
                  // Use ClipRRect to apply border radius
                  borderRadius: BorderRadius
                      .zero, // Set radius to zero if no rounding is desired
                  child: Container(
                    decoration:const BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/images/slider/big_slider01.jpg"),
                        fit: BoxFit
                            .cover, // Ensure the image covers the container without padding
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/images/slider/big_slider02.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/images/slider/big_slider03.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/images/slider/big_slider04.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/images/slider/big_slider05.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/images/slider/big_slider06.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
              options: CarouselOptions(
                height: MediaQuery.of(context)
                    .size
                    .height, // Set height to full screen
                autoPlay: true,
                enlargeCenterPage: false,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(seconds: 2),
                viewportFraction: 1.0, // Take full width of the screen
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index; // Update current index
                  });
                },
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                // Adjust the number of dots based on the number of images
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 2.0, vertical: 25),
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.black // Active dot color
                        : Colors.grey, // Inactive dot color
                  ),
                );
              }),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 190),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 262,
                        height: 165,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                12.0), // Apply border radius from all sides
                          ),
                          color: Color(0xffe2001a),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.cartShopping,
                              color: Colors.white,
                              size: 22,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Order Online',
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          ],
                        )),
                    Container(
                        width: 262,
                        height: 165,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                12.0), // Apply border radius from all sides
                          ),
                          color: Color(0xffe2001a),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.cartShopping,
                              color: Colors.white,
                              size: 22,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Catering Enquiry',
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          ],
                        )),
                    Container(
                        width: 262,
                        height: 165,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                12.0), // Apply border radius from all sides
                          ),
                          color: Color(0xffe2001a),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.cartShopping,
                              color: Colors.white,
                              size: 22,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Banquet',
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          ],
                        )),
                    Container(
                        width: 262,
                        height: 165,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                12.0), // Apply border radius from all sides
                          ),
                          color: Color(0xffe2001a),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.cartShopping,
                              color: Colors.white,
                              size: 22,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Our Cakes',
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          ],
                        )),
                  ],
                )
              ],
            ),
          ),
          Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(190, 40, 190, 60),
              child: Row(
                children: <Widget>[
                  // Left line
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                          right: 10.0), // Add spacing between line and text
                      height: 2,
                      color: Color(0xffe2001a), // Use red color for the line
                    ),
                  ),
                  // Center text
                  Text(
                    "WE SERVE HALAL MEAT",
                    style: GoogleFonts.seaweedScript(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Color(0xff333333), // Dark gray color
                    ),
                  ),
                  // Right line
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 10.0), // Add spacing between text and line
                      height: 2,
                      color: Color(0xffe2001a), // Use red color for the line
                    ),
                  ),
                ],
              )),
          Container(
              color: Color(0xffe0e0e0),
              padding: const EdgeInsets.fromLTRB(190, 40, 190, 100),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/uploads/2020/04/IMG_0118.jpg',
                                // fit: BoxFit.cover,
                                // height: 300,
                              ),
                            ]),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About Us',
                                style: GoogleFonts.raleway(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    'We are Located in the Heart of Montgomery County on RT 309 . We are Just two blocks away from the Montgomery mall. We invite you to come and enjoy the authentic taste of our time-honored Indian cooking. Inside, you’ll find fast-food dining that provides you a comfortable and friendly environment.',
                                    style: GoogleFonts.raleway(
                                      fontSize: 13,
                                      color: const Color(0xff000000),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Text(
                                    'Our Testimonial',
                                    style: GoogleFonts.raleway(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: CarouselSlider(
                                        options: CarouselOptions(
                                          // enableInfiniteScroll: true,
                                          autoPlay: true,
                                          viewportFraction: 0.9,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _currentIndex =
                                                  index; // Update current index
                                            });
                                          },
                                        ),
                                        items: [
                                          // First Carousel Item
                                          _buildCarouselItem(
                                            icon: FontAwesomeIcons.quoteRight,
                                            middleText:
                                                'The only limit to our realization of tomorrow is our doubts of today.',
                                            bottomText: 'Franklin D. Roosevelt',
                                          ),
                                          // Second Carousel Item
                                          _buildCarouselItem(
                                            icon: FontAwesomeIcons.quoteRight,
                                            middleText:
                                                'Life is 10% what happens to us and 90% how we react to it.',
                                            bottomText: 'Charles R. Swindoll',
                                          ),
                                          // Third Carousel Item
                                          _buildCarouselItem(
                                            icon: FontAwesomeIcons.quoteRight,
                                            middleText:
                                                'The purpose of our lives is to be happy.',
                                            bottomText: 'Dalai Lama',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(3, (index) {
                                        // Adjust the number of dots based on the number of images
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2.0, vertical: 25),
                                          width: 8.0,
                                          height: 8.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _currentIndex == index
                                                ? Colors
                                                    .black // Active dot color
                                                : Colors
                                                    .grey, // Inactive dot color
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ))),
                    ],
                  ),
                ],
              )),
          Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(190, 20, 190, 20),
              child: Text(
                'We are following all the CDC guidelines to ensure the safety of our customers and out staff members in this COVID situation',
                style: GoogleFonts.raleway(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              )),
        ],
      ),
    );
  }
}

Widget _buildCarouselItem(
    {required IconData icon,
    required String middleText,
    required String bottomText}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Top Icon
        Icon(
          icon,
          size: 30,
          color: Colors.red, // Customize color as needed
        ),

        Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text(
            middleText,
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            bottomText,
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              fontSize: 14,
              color: Color(0xff666666),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}
