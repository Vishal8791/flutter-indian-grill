import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// ImageWithTextOverlay widget
class ImageWithTextOverlay extends StatefulWidget {
  final String imagePath;
  final String overlayText;
  final double? width; // Optional width parameter
  final double? height; // Optional height parameter

  const ImageWithTextOverlay({
    super.key,
    required this.imagePath,
    required this.overlayText,
    this.width, // Accept width as an optional argument
    this.height, // Accept height as an optional argument
  });

  @override
  _ImageWithTextOverlayState createState() => _ImageWithTextOverlayState();
}

class _ImageWithTextOverlayState extends State<ImageWithTextOverlay> {
  double _scale = 1.0; // Initial scale of the image

  @override
  Widget build(BuildContext context) {
    // Use passed width and height, or default to 200 if not provided
    final double width = widget.width ?? 200;
    final double height = widget.height ?? 200;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _scale = 1.1; // Scale up on hover
        });
      },
      onExit: (_) {
        setState(() {
          _scale = 1.0; // Scale back to original
        });
      },
      child: Stack(
        children: [
          // Background image with scale effect
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: AnimatedContainer(
                duration: const Duration(
                    milliseconds: 200), // Smooth transition duration
                curve: Curves.easeInOut, // Smooth curve for the animation
                transform: Matrix4.identity()
                  ..translate(
                      width / 2, height / 2) // Center image before scaling
                  ..scale(_scale) // Apply scale transformation
                  ..translate(
                      -width / 2, -height / 2), // Re-center image after scaling
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Black overlay with opacity
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.black
                  .withOpacity(0.4), // Adjust opacity for the overlay
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          // Overlay text
          SizedBox(
            width: width,
            height: height,
            child: Center(
              child: Text(
                widget.overlayText.toUpperCase(),
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(2.0, 2.0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Main Banquet widget
class Banquet extends StatelessWidget {
  const Banquet({super.key});

  @override
  Widget build(BuildContext context) {
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
                return buildDesktopLayout(context); // Desktop layout for web
              } else if (screenWidth > 600) {
                // print("Web/Tablet layout is being used");
                return buildTabletLayout(context); // Tablet layout for web
              } else {
                // print("Web/Mobile layout is being used");
                return buildMobileLayout(context); // Mobile layout for web
              }
            } else {
              // For web: apply responsive layout based on screen size
              if (screenWidth > 1024) {
                // print("Web/Desktop layout is being used");
                return buildDesktopLayout(context); // Desktop layout for web
              } else if (screenWidth > 600) {
                // print("Web/Tablet layout is being used");
                return buildTabletLayout(context); // Tablet layout for web
              } else {
                // print("Web/Mobile layout is being used");
                return buildMobileLayout(context); // Mobile layout for web
              }
            }
          },
        ));
  }

  Widget buildDesktopLayout(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider(
            items: [
              'assets/images/uploads/2019/03/image5-768x1024.jpeg',
              'assets/images/uploads/2019/03/image7-768x1024.jpeg',
              'assets/images/uploads/2019/03/image4-768x1024.jpeg',
              'assets/images/uploads/2019/03/image3-768x1024.jpeg',
              'assets/images/uploads/2019/03/image2-768x1024.jpeg',
            ].map((imageUrl) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 500.0,
              enlargeCenterPage: false,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.25,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Banquet',
              style: GoogleFonts.raleway(
                fontSize: 16,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(190, 20, 190, 20),
            child: Text(
              'For any type of special event, our professional staff serves best-in-class facilities and services. Our goal is to make your moment memorable. Indian Grill helps you to bring your dream plan into reality. We make sure to serve you with world-class event planning services. So, if you want to make your dream event memorable, Indian Grill is the best option to achieve that with utmost elegance.',
              style: GoogleFonts.raleway(
                fontSize: 18,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(190, 20, 190, 20),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Use the ImageWithTextOverlay widget here
                    ImageWithTextOverlay(
                      imagePath:
                          'assets/images/uploads/2019/03/birthday-e1551877081621.jpeg',
                      overlayText: 'Birthday Party',
                    ),
                    ImageWithTextOverlay(
                      imagePath: 'assets/images/uploads/2019/03/image1.jpeg',
                      overlayText: 'Wedding',
                    ),
                    ImageWithTextOverlay(
                      imagePath: 'assets/images/uploads/2019/03/image6.jpeg',
                      overlayText: 'Anniversary',
                    ),
                    ImageWithTextOverlay(
                      imagePath: 'assets/images/uploads/2019/03/image3.jpeg',
                      overlayText: 'Engagement',
                    ),
                    ImageWithTextOverlay(
                      imagePath: 'assets/images/uploads/2019/03/baby.jpeg',
                      overlayText: 'Baby Shower',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 30, bottom: 50),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    print('Send button pressed!');
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {
                          return const Color(
                              0xff42BCE2); // Text color when hovered
                        }
                        return Colors.white; // Default text color
                      },
                    ),
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0xffe2001a)),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 22),
                    ),
                    textStyle: WidgetStateProperty.all(
                      GoogleFonts.raleway(fontSize: 14),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0), // No border radius
                        side: const BorderSide(
                            color: Color(0xff42BCE2),
                            width: 2.0), // Red border with 2px width
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed('banquet-contact-page');
                    },
                    child: const Text(
                      'CHECK BANQUET AVAILABILITY',
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth * 0.9;
    final imageHeight = imageWidth * 0.7;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider(
            items: [
              'assets/images/uploads/2019/03/image5-768x1024.jpeg',
              'assets/images/uploads/2019/03/image7-768x1024.jpeg',
              'assets/images/uploads/2019/03/image4-768x1024.jpeg',
              'assets/images/uploads/2019/03/image3-768x1024.jpeg',
              'assets/images/uploads/2019/03/image2-768x1024.jpeg',
            ].map((imageUrl) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 450.0,
              enlargeCenterPage: false,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Banquet',
              style: GoogleFonts.raleway(
                fontSize: 16,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Text(
              'For any type of special event, our professional staff serves best-in-class facilities and services. Our goal is to make your moment memorable. Indian Grill helps you to bring your dream plan into reality. We make sure to serve you with world-class event planning services. So, if you want to make your dream event memorable, Indian Grill is the best option to achieve that with utmost elegance.',
              style: GoogleFonts.raleway(
                fontSize: 18,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Use the ImageWithTextOverlay widget here
                    buildImageTile(
                      context,
                      'assets/images/uploads/2019/03/birthday-e1551877081621.jpeg',
                      'Birthday Party',
                      imageWidth,
                      imageHeight,
                    ),
                    const SizedBox(height: 20),
                    buildImageTile(
                      context,
                      'assets/images/uploads/2019/03/image1.jpeg',
                      'Wedding',
                      imageWidth,
                      imageHeight,
                    ),
                    const SizedBox(height: 20),
                    buildImageTile(
                      context,
                      'assets/images/uploads/2019/03/image6.jpeg',
                      'Anniversary',
                      imageWidth,
                      imageHeight,
                    ),
                    const SizedBox(height: 20),
                    buildImageTile(
                      context,
                      'assets/images/uploads/2019/03/image3.jpeg',
                      'Engagement',
                      imageWidth,
                      imageHeight,
                    ),
                    const SizedBox(height: 20),
                    buildImageTile(
                      context,
                      'assets/images/uploads/2019/03/baby.jpeg',
                      'Baby Shower',
                      imageWidth,
                      imageHeight,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 30, bottom: 50),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    print('Send button pressed!');
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {
                          return const Color(
                              0xff42BCE2); // Text color when hovered
                        }
                        return Colors.white; // Default text color
                      },
                    ),
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0xffe2001a)),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 22),
                    ),
                    textStyle: WidgetStateProperty.all(
                      GoogleFonts.raleway(fontSize: 14),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0), // No border radius
                        side: const BorderSide(
                            color: Color(0xff42BCE2),
                            width: 2.0), // Red border with 2px width
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed('banquet-contact-page');
                    },
                    child: const Text(
                      'CHECK BANQUET AVAILABILITY',
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildTabletLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    final imageSize = isTablet ? 200.0 : 130.0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider(
            items: [
              'assets/images/uploads/2019/03/image5-768x1024.jpeg',
              'assets/images/uploads/2019/03/image7-768x1024.jpeg',
              'assets/images/uploads/2019/03/image4-768x1024.jpeg',
              'assets/images/uploads/2019/03/image3-768x1024.jpeg',
              'assets/images/uploads/2019/03/image2-768x1024.jpeg',
            ].map((imageUrl) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 500.0,
              enlargeCenterPage: false,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Banquet',
              style: GoogleFonts.raleway(
                fontSize: 16,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // padding: const EdgeInsets.fromLTRB(190, 20, 190, 20),
          Text(
            'For any type of special event, our professional staff serves best-in-class facilities and services. Our goal is to make your moment memorable. Indian Grill helps you to bring your dream plan into reality. We make sure to serve you with world-class event planning services. So, if you want to make your dream event memorable, Indian Grill is the best option to achieve that with utmost elegance.',
            style: GoogleFonts.raleway(
              fontSize: 18,
              color: const Color(0xff000000),
              fontWeight: FontWeight.w300,
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Use the ImageWithTextOverlay widget here
                    ImageWithTextOverlay(
                      imagePath:
                          'assets/images/uploads/2019/03/birthday-e1551877081621.jpeg',
                      overlayText: 'Birthday Party',
                      width: imageSize,
                      height: imageSize,
                    ),
                    ImageWithTextOverlay(
                      imagePath: 'assets/images/uploads/2019/03/image1.jpeg',
                      overlayText: 'Wedding',
                      width: imageSize,
                      height: imageSize,
                    ),
                    ImageWithTextOverlay(
                      imagePath: 'assets/images/uploads/2019/03/image6.jpeg',
                      overlayText: 'Anniversary',
                      width: imageSize,
                      height: imageSize,
                    ),
                    ImageWithTextOverlay(
                      imagePath: 'assets/images/uploads/2019/03/image3.jpeg',
                      overlayText: 'Engagement',
                      width: imageSize,
                      height: imageSize,
                    ),
                    ImageWithTextOverlay(
                      imagePath: 'assets/images/uploads/2019/03/baby.jpeg',
                      overlayText: 'Baby Shower',
                      width: imageSize,
                      height: imageSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 30, bottom: 50),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    print('Send button pressed!');
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {
                          return const Color(
                              0xff42BCE2); // Text color when hovered
                        }
                        return Colors.white; // Default text color
                      },
                    ),
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0xffe2001a)),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 22),
                    ),
                    textStyle: WidgetStateProperty.all(
                      GoogleFonts.raleway(fontSize: 14),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0), // No border radius
                        side: const BorderSide(
                            color: Color(0xff42BCE2),
                            width: 2.0), // Red border with 2px width
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed('banquet-contact-page');
                    },
                    child: const Text(
                      'CHECK BANQUET AVAILABILITY',
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget buildImageTile(BuildContext context, String imagePath,
    String overlayText, double width, double height) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          insetPadding: EdgeInsets.zero,
          child: InteractiveViewer(
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    },
    child: ImageWithTextOverlay(
      imagePath: imagePath,
      overlayText: overlayText,
      width: width,
      height: height,
    ),
  );
}
