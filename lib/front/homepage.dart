// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:carousel_slider_plus/carousel_slider_plus.dart'; // Correct import for CarouselSlider
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:indiangrill/style/style.dart' show AppColors, AppTextStyle;
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarouselSliderController _controller = CarouselSliderController();
  final CarouselSliderController _testimonialController =
      CarouselSliderController();
  int _mainSliderIndex = 0;
  int _testimonialIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
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
                          AssetImage("assets/images/slider/big_slider01.webp"),
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
                          AssetImage("assets/images/slider/big_slider02.webp"),
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
                          AssetImage("assets/images/slider/big_slider03.webp"),
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
                          AssetImage("assets/images/slider/big_slider04.webp"),
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
                          AssetImage("assets/images/slider/big_slider05.webp"),
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
                          AssetImage("assets/images/slider/big_slider06.webp"),
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
                  _mainSliderIndex = index; // Update current index
                });
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 190),
          color: Colors.black,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT SIDE
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/home/food_02.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        "assets/images/home/food_03.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 30),

              // RIGHT SIDE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Order Online',
                      style: GoogleFonts.raleway(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Order your favorite dishes online and enjoy fresh, authentic flavors from the comfort of your home. Our easy online ordering makes it quick and convenient to get delicious meals prepared with care using quality ingredients and traditional recipes. Choose fast pickup or reliable delivery, perfect for lunch, dinner, or any occasion. Whether you’re ordering for yourself, your family, or a group, we ensure every meal is freshly made and packed with flavor. Skip the wait, customize your order with ease, and enjoy a seamless online experience from start to finish. Just a few clicks and your favorite dishes are ready to enjoy, hot and delicious.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/order-online');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // 👈 sharp corners
                        ),
                      ),
                      child: Text(
                        'Order Now',
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
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
          padding: AppTextStyle.sectionPadding,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RIGHT SIDE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Catering Enquiry',
                      style: GoogleFonts.raleway(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Planning an event or special gathering? Our catering services bring fresh, authentic flavors to your celebration with dishes prepared using quality ingredients and traditional recipes. Whether it’s a small get-together, corporate event, or large celebration, we offer flexible menu options to suit your needs. From setup to service, our team ensures a smooth and delicious catering experience—contact us today to start planning your event",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/catering-enquiry');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // 👈 sharp corners
                        ),
                      ),
                      child: Text(
                        'Enquiry Now',
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              // LEFT SIDE
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/home/food_02.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        "assets/images/home/food_03.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/home/big_slider02.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: AppTextStyle.bannerPadding,
            color: Colors.black.withOpacity(0.8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Banquets",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Our banquet facilities provide the perfect setting for weddings, receptions, corporate events, and special celebrations. With an elegant space, customizable menu options, and attentive service, we ensure every event is memorable and seamless. Whether you’re hosting an intimate gathering or a large celebration, our team is here to make your banquet experience exceptional from start to finish.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    context.go('/banquet');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // 👈 sharp corners
                    ),
                  ),
                  child: Text(
                    'Book Now',
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
              // 👈 CENTER the content
              // ignore: deprecated_member_use
            ),
          ),
        ),
        Container(
          padding: AppTextStyle.sectionPadding,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RIGHT SIDE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Our Cakes',
                      style: GoogleFonts.raleway(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Discover our delicious selection of freshly baked cakes, made with quality ingredients and crafted with care. From classic favorites to custom designs for birthdays, weddings, and special occasions, each cake is created to look beautiful and taste even better. Whether you’re celebrating a milestone or simply treating yourself, our cakes add the perfect sweet touch to any moment.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/ourcakes');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // 👈 sharp corners
                        ),
                      ),
                      child: Text(
                        'Order Now',
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              // LEFT SIDE
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/cakes/cake_1.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        "assets/images/cakes/cake_2.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: AppTextStyle.sectionPadding,
          color: Colors.white,
          child: Row(
            children: [
              /// LEFT COLUMN (IMAGE)
              Expanded(
                child: Image.asset(
                  'assets/images/uploads/home_about_banner.jpg',
                  fit: BoxFit.cover,
                  height: 420,
                ),
              ),

              /// RIGHT COLUMN (CARD AREA)
              Expanded(
                child: Transform.translate(
                  offset: const Offset(-50, 0), // move card over image
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 40,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'About Us',
                            style: GoogleFonts.raleway(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Located in the heart of Montgomery County on RT 309, just minutes from Montgomery Mall, Indian Grill – Cakes & Curries offers authentic Indian cuisine made with traditional spices and fresh ingredients. Enjoy rich flavors, fast service, and a welcoming environment perfect for dine-in or take-out.',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          color: Colors.white,
          padding: AppTextStyle.sectionPadding,
          child: Center(
            child: SizedBox(
              // width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// SLIDER
                  CarouselSlider(
                    carouselController: _testimonialController,
                    options: CarouselOptions(
                      height: 220,
                      autoPlay: true,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _testimonialIndex = index;
                        });
                      },
                    ),
                    items: [
                      _buildCarouselItem(
                        icon: Icons.format_quote,
                        middleText:
                            "A favorite restaurant for my son, my boyfriend & I! We love the chicken makhani, pav baji, & chicken chettinad!",
                        bottomText: "Stephanie Wilson",
                      ),
                      _buildCarouselItem(
                        icon: Icons.format_quote,
                        middleText:
                            "Amazing food and great service. The flavors are authentic and the staff is very friendly.",
                        bottomText: "Michael Brown",
                      ),
                      _buildCarouselItem(
                        icon: Icons.format_quote,
                        middleText:
                            "Best Indian food in town! Highly recommend the butter chicken and naan.",
                        bottomText: "Emily Davis",
                      ),
                    ],
                  ),

                  /// LEFT ARROW
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 28,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _testimonialController.previousPage();
                      },
                    ),
                  ),

                  /// RIGHT ARROW
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 28,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _testimonialController.nextPage();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // About Us Section
      ],
    );
  }

  Widget buildMobileLayout() {
    final List<String> sliderImages = [
      "assets/images/slider/big_slider01.webp",
      "assets/images/slider/big_slider02.webp",
      "assets/images/slider/big_slider03.webp",
      "assets/images/slider/big_slider04.webp",
      "assets/images/slider/big_slider05.webp",
      "assets/images/slider/big_slider06.webp",
    ];

    return Column(
      children: [
        // Carousel with arrows overlay
        Stack(
          children: [
            // Carousel
            CarouselSlider.builder(
              carouselController: _controller, // Use state-level controller
              itemCount: sliderImages.length,
              itemBuilder: (context, index, realIndex) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      sliderImages[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 160,
                autoPlay: true,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(seconds: 3),
                onPageChanged: (index, reason) {
                  setState(() {
                    _mainSliderIndex = index; // Use state-level variable
                  });
                },
              ),
            ),
          ],
        ),
        Container(
          color: Colors.black,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/home/food_02.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        "assets/images/home/food_03.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Online',
                        style: GoogleFonts.raleway(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Order your favorite dishes online and enjoy fresh, authentic flavors from the comfort of your home. Our easy online ordering makes it quick and convenient to get delicious meals prepared with care using quality ingredients and traditional recipes. Choose fast pickup or reliable delivery, perfect for lunch, dinner, or any occasion. Whether you’re ordering for yourself, your family, or a group, we ensure every meal is freshly made and packed with flavor. Skip the wait, customize your order with ease, and enjoy a seamless online experience from start to finish. Just a few clicks and your favorite dishes are ready to enjoy, hot and delicious.',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.go('/order-online');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // 👈 sharp corners
                          ),
                        ),
                        child: Text(
                          'Order Now',
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          color: Colors.white,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catering Enquiry',
                        style: GoogleFonts.raleway(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Planning an event or special gathering? Our catering services bring fresh, authentic flavors to your celebration with dishes prepared using quality ingredients and traditional recipes. Whether it’s a small get-together, corporate event, or large celebration, we offer flexible menu options to suit your needs. From setup to service, our team ensures a smooth and delicious catering experience—contact us today to start planning your event.',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.go('/catering-enquiry');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // 👈 sharp corners
                          ),
                        ),
                        child: Text(
                          'Enquiry Now',
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/home/food_02.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        "assets/images/home/food_03.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/home/big_slider02.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            // ignore: deprecated_member_use
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            color: Colors.black.withOpacity(0.8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Banquets",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Our banquet facilities provide the perfect setting for weddings, receptions, corporate events, and special celebrations. With an elegant space, customizable menu options, and attentive service, we ensure every event is memorable and seamless. Whether you’re hosting an intimate gathering or a large celebration, our team is here to make your banquet experience exceptional from start to finish.",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    context.go('/banquet');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // 👈 sharp corners
                    ),
                  ),
                  child: Text(
                    'Book Now',
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
              // 👈 CENTER the content
              // ignore: deprecated_member_use
            ),
          ),
        ),

        Container(
          color: Colors.white,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Our Cake',
                        style: GoogleFonts.raleway(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Discover our delicious selection of freshly baked cakes, made with quality ingredients and crafted with care. From classic favorites to custom designs for birthdays, weddings, and special occasions, each cake is created to look beautiful and taste even better. Whether you’re celebrating a milestone or simply treating yourself, our cakes add the perfect sweet touch to any moment.',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.go('/ourcakes');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // 👈 sharp corners
                          ),
                        ),
                        child: Text(
                          'Order Now',
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/home/food_02.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        "assets/images/home/food_03.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Container(
          child: Image.asset(
            "assets/images/uploads/home_about_banner.jpg",
            fit: BoxFit.cover,
          ),
        ),

        Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              children: [
                Text(
                  "About Us",
                  style: GoogleFonts.raleway(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Text(
                    "Located in the heart of Montgomery County on RT 309, just minutes from Montgomery Mall, Indian Grill – Cakes & Curries offers authentic Indian cuisine made with traditional spices and fresh ingredients. Enjoy rich flavors, fast service, and a welcoming environment perfect for dine-in or take-out.",
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )),

        // Testimonial section
        Container(
          // color: const Color(0xffe0e0e0),
          padding: const EdgeInsets.all(10),
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
              const SizedBox(height: 20),
              Stack(
                children: [
                  CarouselSlider(
                    carouselController: _testimonialController,
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _testimonialIndex = index;
                        });
                      },
                    ),
                    items: [
                      _buildMobileCarouselItem(
                        icon: Icons.format_quote,
                        middleText:
                            'The only limit to our realization of tomorrow is our doubts of today.',
                        bottomText: 'Franklin D. Roosevelt',
                      ),
                      _buildMobileCarouselItem(
                        icon: Icons.format_quote,
                        middleText:
                            'Life is 10% what happens to us and 90% how we react to it.',
                        bottomText: 'Charles R. Swindoll',
                      ),
                      _buildMobileCarouselItem(
                        icon: Icons.format_quote,
                        middleText: 'The purpose of our lives is to be happy.',
                        bottomText: 'Dalai Lama',
                      ),
                    ],
                  ),
                  Positioned(
                    left: -10,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.black54, size: 18),
                        onPressed: () {
                          _testimonialController.previousPage();
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: -10,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,
                            color: Colors.black54, size: 18),
                        onPressed: () {
                          _testimonialController.nextPage();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // CDC Guideline Text
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red.shade50,
                Colors.red.shade100,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: const Color(0xFFE2001A), size: 40),
              const SizedBox(height: 10),
              Text(
                'We follow all CDC COVID-19 safety guidelines for our customers and staff.',
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: const Color(0XFFE2001A),
                ),
              ),
            ],
          ),
        ),
        buildRestaurantTimingCard(),
        // Image.asset(
        //   'assets/images/timing.webp',
        //   // fit: BoxFit.cover,
        //   // height: 300,
        // ),
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
                          AssetImage("assets/images/slider/big_slider01.webp"),
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
                          AssetImage("assets/images/slider/big_slider02.webp"),
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
                          AssetImage("assets/images/slider/big_slider03.webp"),
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
                          AssetImage("assets/images/slider/big_slider04.webp"),
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
                          AssetImage("assets/images/slider/big_slider05.webp"),
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
                          AssetImage("assets/images/slider/big_slider06.webp"),
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
                  _mainSliderIndex = index; // Update current index
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
                  color: _mainSliderIndex == index
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
                              'assets/images/uploads/2020/04/IMG_0118.webp',
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
                                    child: Stack(
                                      children: [
                                        CarouselSlider(
                                          carouselController:
                                              _testimonialController,
                                          options: CarouselOptions(
                                            // enableInfiniteScroll: true,
                                            autoPlay: true,
                                            viewportFraction: 0.9,
                                            onPageChanged: (index, reason) {
                                              setState(() {
                                                _testimonialIndex =
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
                                              bottomText:
                                                  'Franklin D. Roosevelt',
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
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Center(
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Colors.black54,
                                                  size: 20),
                                              onPressed: () {
                                                _testimonialController
                                                    .previousPage();
                                              },
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Center(
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.black54,
                                                  size: 20),
                                              onPressed: () {
                                                _testimonialController
                                                    .nextPage();
                                              },
                                            ),
                                          ),
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
                                          horizontal: 2.0, vertical: 25),
                                      width: 8.0,
                                      height: 8.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _testimonialIndex == index
                                            ? Colors.black // Active dot color
                                            : Colors.grey, // Inactive dot color
                                      ),
                                    );
                                  }),
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

Widget buildRestaurantTimingCard() {
  return Container(
    // color: AppColors.appBg,
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
    decoration: BoxDecoration(
      color: AppColors.appBg,
      borderRadius: BorderRadius.circular(16),
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.black.withOpacity(0.08),
      //     blurRadius: 12,
      //     offset: const Offset(0, 6),
      //   ),
      // ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // HEADLINE WITH LINES
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: AppColors.primary,
                thickness: 1,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Restaurant Timing",
              style: GoogleFonts.raleway(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Divider(
                color: AppColors.primary,
                thickness: 1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // OPEN STATUS PILL
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "OPEN 7 DAYS WEEK",
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              color: Colors.red.shade800,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        ),

        const SizedBox(height: 22),

        // TIMINGS SECTION
        Column(
          children: const [
            _TimingRow(
              dayText: "Monday to Thursday",
              timeText: "11:30 AM - 9:30 PM",
            ),
            SizedBox(height: 12),
            _TimingRow(
              dayText: "Friday & Saturday",
              timeText: "11:30 AM - 10:30 PM",
            ),
            SizedBox(height: 12),
            _TimingRow(
              dayText: "Sunday",
              timeText: "11:30 AM - 9:30 PM",
            ),
          ],
        ),

        const SizedBox(height: 22),

        // CONTACT PHONE
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.phone, color: Colors.red, size: 20),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () async {
                final Uri phoneUri = Uri(scheme: 'tel', path: '2158554900');

                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                }
              },
              child: Text(
                "215-855-4900",
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),

        const SizedBox(height: 10),

        // CONTACT EMAIL
        GestureDetector(
          onTap: () async {
            final Uri emailUri = Uri(
              scheme: 'mailto',
              path: 'contact@indian-grill.com',
              query: 'subject=Inquiry',
            );

            await launchUrl(
              emailUri,
              mode: LaunchMode.externalApplication,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.email, color: Colors.red, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                "contact@indian-grill.com",
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

class _TimingRow extends StatelessWidget {
  final String dayText;
  final String timeText;

  const _TimingRow({
    required this.dayText,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          dayText,
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          timeText,
          style: GoogleFonts.raleway(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Helper widget for timing rows

Widget _buildCarouselItem({
  required IconData icon,
  required String middleText,
  required String bottomText,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Our Testimonials",
        style: GoogleFonts.raleway(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Icon(
        icon,
        size: 30,
        color: Colors.red,
      ),
      const SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          middleText,
          textAlign: TextAlign.center,
          style: GoogleFonts.raleway(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ),
      const SizedBox(height: 20),
      Text(
        bottomText,
        style: GoogleFonts.raleway(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    ],
  );
}

Widget _buildMobileCarouselItem(
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
          padding: const EdgeInsets.only(top: 10),
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
