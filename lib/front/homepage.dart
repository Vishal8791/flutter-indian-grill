// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart'; // Correct import for CarouselSlider
import 'package:go_router/go_router.dart';
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
    return SingleChildScrollView(child: LayoutBuilder(
      builder: (context, Constraints) {
        double screenWidth = Constraints.maxWidth;
        // print("Current Width: $screenWidth");

        if (kIsWeb) {
          // For web: apply responsive layout based on screen size
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
          // For web: apply responsive layout based on screen size
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
      },
    )
        // Enable scrolling
        );
  }

  Widget buildDesktopLayout() {
    return Column(
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
                  decoration: const BoxDecoration(
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
              autoPlayAnimationDuration: const Duration(seconds: 2),
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
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).pushNamed('order-online');
                      },
                      child: Container(
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
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 22,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
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
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).pushNamed('category-enquiry');
                      },
                      child: Container(
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
                              Icons.restaurant,
                              color: Colors.white,
                              size: 22,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
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
                        ),
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).pushNamed('banquet');
                      },
                      child: Container(
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
                                Icons.restaurant_menu,
                                color: Colors.white,
                                size: 22,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
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
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).pushNamed('ourcakes');
                      },
                      child: Container(
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
                                Icons.cake,
                                color: Colors.white,
                                size: 22,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
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
                    ),
                  ),
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
                    color:
                        const Color(0xffe2001a), // Use red color for the line
                  ),
                ),
                // Center text
                Text(
                  "WE SERVE HALAL MEAT",
                  style: GoogleFonts.seaweedScript(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xff333333), // Dark gray color
                  ),
                ),
                // Right line
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 10.0), // Add spacing between text and line
                    height: 2,
                    color:
                        const Color(0xffe2001a), // Use red color for the line
                  ),
                ),
              ],
            )),
        Container(
            color: const Color(0xffe0e0e0),
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
                        padding: const EdgeInsets.only(top: 10),
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
                                padding: const EdgeInsets.only(top: 10),
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
                            padding: const EdgeInsets.only(top: 10),
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
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                          icon: Icons.format_quote,
                                          middleText:
                                              'The only limit to our realization of tomorrow is our doubts of today.',
                                          bottomText: 'Franklin D. Roosevelt',
                                        ),
                                        // Second Carousel Item
                                        _buildCarouselItem(
                                          icon: Icons.format_quote,
                                          middleText:
                                              'Life is 10% what happens to us and 90% how we react to it.',
                                          bottomText: 'Charles R. Swindoll',
                                        ),
                                        // Third Carousel Item
                                        _buildCarouselItem(
                                          icon: Icons.format_quote,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                              ? Colors.black // Active dot color
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
    );
  }

  Widget buildMobileLayout() {
    return Column(
      children: [
        SizedBox(
          height: 125,
          // width: 390,

          // Remove any additional padding
          child: CarouselSlider(
            items: [
              ClipRRect(
                // Use ClipRRect to apply border radius
                borderRadius: BorderRadius
                    .zero, // Set radius to zero if no rounding is desired
                child: Container(
                  decoration: const BoxDecoration(
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
              // aspectRatio: 16 / 9,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(seconds: 2),
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
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 20),
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
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ServiceCard(
                    title: 'Order Online',
                    icon: Icons.shopping_cart,
                    width: 330, // Custom width for the first card
                    height: 150, // Custom height for the first card
                    onTap: () => context.pushNamed('order-online'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ServiceCard(
                    title: 'Catering Enquiry',
                    icon: Icons.local_dining,
                    width: 330, // Custom width for the first card
                    height: 150, // Custom height for the first card
                    onTap: () => context.pushNamed('category-enquiry'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ServiceCard(
                    title: 'Banquet',
                    icon: Icons.restaurant,
                    width: 330, // Custom width for the first card
                    height: 150, // Custom height for the first card
                    onTap: () => context.pushNamed('banquet'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ServiceCard(
                    title: 'Our Cakes',
                    icon: Icons.cake,
                    width: 330, // Custom width for the first card
                    height: 150, // Custom height for the first card\
                    onTap: () => context.pushNamed('ourcakes'),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                ],
              )
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 60),
          child: Center(
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center content horizontally
              children: <Widget>[
                Expanded(
                  // Make the text take the available space
                  child: Text(
                    "WE SERVE HALAL MEAT",
                    textAlign: TextAlign.center, // Center the text
                    style: GoogleFonts.seaweedScript(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xff333333), // Dark gray color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
            color: const Color(0xffe0e0e0),
            padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/uploads/2020/04/IMG_0118.jpg',
                            // fit: BoxFit.cover,
                            // height: 300,
                          ),
                        ]),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
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
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'We are Located in the Heart of Montgomery County on RT 309 . We are Just two blocks away from the Montgomery mall. We invite you to come and enjoy the authentic taste of our time-honored Indian cooking. Inside, you’ll find fast-food dining that provides you a comfortable and friendly environment.',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              )),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 40),
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
                                height: 200,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    // enableInfiniteScroll: true,
                                    autoPlay: true,
                                    viewportFraction: 1.0,
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
                                      icon: Icons.format_quote,
                                      middleText:
                                          'The only limit to our realization of tomorrow is our doubts of today.',
                                      bottomText: 'Franklin D. Roosevelt',
                                    ),
                                    // Second Carousel Item
                                    _buildCarouselItem(
                                      icon: Icons.format_quote,
                                      middleText:
                                          'Life is 10% what happens to us and 90% how we react to it.',
                                      bottomText: 'Charles R. Swindoll',
                                    ),
                                    // Third Carousel Item
                                    _buildCarouselItem(
                                      icon: Icons.format_quote,
                                      middleText:
                                          'The purpose of our lives is to be happy.',
                                      bottomText: 'Dalai Lama',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                // Adjust the number of dots based on the number of images
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 2.0, vertical: 15),
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
                          ],
                        )),
                  ],
                ),
              ],
            )),
        Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Text(
              'We are following all the CDC guidelines to ensure the safety of our customers and out staff members in this COVID situation',
              style: GoogleFonts.raleway(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0XFFE2001A),
              ),
            )),
      ],
    );
  }

  Widget buildTabletLayout() {
    return Column(
      children: [
        SizedBox(
          height: 350,

          // Remove any additional padding
          child: CarouselSlider(
            items: [
              ClipRRect(
                // Use ClipRRect to apply border radius
                borderRadius: BorderRadius
                    .zero, // Set radius to zero if no rounding is desired
                child: Container(
                  decoration: const BoxDecoration(
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
              autoPlayAnimationDuration: const Duration(seconds: 2),
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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          color: Colors.white,
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                ServiceCard(
                  title: 'Order Online',
                  icon: FontAwesomeIcons.cartShopping,
                  onTap: () => context.pushNamed('order-online'),
                ),
                const SizedBox(height: 20),
                ServiceCard(
                  title: 'Catering Enquiry',
                  icon: Icons.local_dining,
                  onTap: () => context.pushNamed('category-enquiry'),
                ),
                const SizedBox(height: 20),
                ServiceCard(
                  title: 'Banquet',
                  icon: Icons.restaurant_menu,
                  onTap: () => context.pushNamed('banquet'),
                ),
                const SizedBox(height: 20),
                ServiceCard(
                  title: 'Our Cakes',
                  icon: FontAwesomeIcons.cakeCandles,
                  onTap: () => context.pushNamed('ourcakes'),
                ),
              ])
            ],
          ),
        ),
        Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Row(
              children: <Widget>[
                // Left line
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 10.0), // Add spacing between line and text
                    height: 2,
                    color:
                        const Color(0xffe2001a), // Use red color for the line
                  ),
                ),
                // Center text
                Text(
                  "WE SERVE HALAL MEAT",
                  style: GoogleFonts.seaweedScript(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xff333333), // Dark gray color
                  ),
                ),
                // Right line
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 10.0), // Add spacing between text and line
                    height: 2,
                    color:
                        const Color(0xffe2001a), // Use red color for the line
                  ),
                ),
              ],
            )),
        Container(
            color: const Color(0xffe0e0e0),
            padding: const EdgeInsets.fromLTRB(40, 50, 40, 50),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        padding: const EdgeInsets.only(top: 10, left: 20),
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
                                padding: const EdgeInsets.only(top: 10),
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
                            padding: const EdgeInsets.only(top: 10),
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
                                    height: 250,
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                              ? Colors.black // Active dot color
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
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
            child: Text(
              'We are following all the CDC guidelines to ensure the safety of our customers and out staff members in this COVID situation',
              style: GoogleFonts.raleway(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            )),
      ],
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
          padding: const EdgeInsets.only(top: 50),
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
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            bottomText,
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              fontSize: 14,
              color: const Color(0xff666666),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

// class ServiceCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final double width;
//   final double height;

//   const ServiceCard({
//     super.key,
//     required this.title,
//     required this.icon,
//     this.width = 180, // default width
//     this.height = 150, // default height
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(
//           Radius.circular(8.0), // Apply border radius to all sides
//         ),
//         color: Color(0xffe2001a), // Red color for background
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             color: Colors.white,
//             size: 22,
//           ),
//           const SizedBox(height: 10), // Space between icon and text
//           Text(
//             title,
//             style: GoogleFonts.raleway(
//               fontSize: 16,
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double width;
  final double height;
  final VoidCallback? onTap; // <-- new

  const ServiceCard({
    super.key,
    required this.title,
    required this.icon,
    this.width = 180,
    this.height = 150,
    this.onTap, // <-- new
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap, // <-- triggers navigation
          child: Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              color: Color(0xffe2001a),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: GoogleFonts.raleway(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
