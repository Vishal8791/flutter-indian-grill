import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  GalleryState createState() => GalleryState();
}

class GalleryState extends State<Gallery> {
  bool isAllVisible = true;
  bool isCakeVisible = false;
  bool isFoodVisible = false;
  String selectedButton = 'All';

  final List<String> imageAll = [
    'assets/images/uploads/2017/05/noodle.webp',
    'assets/images/uploads/2017/05/Thali.webp',
    'assets/images/uploads/2017/05/chkn-Biryani.webp',
    'assets/images/uploads/2017/01/noodles-and-veg-manchurian.webp',
    'assets/images/uploads/2017/01/vada-pav.webp',
    'assets/images/uploads/2017/01/jalebi.webp',
    'assets/images/uploads/2017/01/IMG_0190.webp',
    'assets/images/uploads/2017/01/IMG_0166.webp',
    'assets/images/uploads/2017/01/IMG_0163.webp',
    'assets/images/uploads/2017/01/IMG_0135.webp',
    'assets/images/uploads/2017/01/garlic-naan.webp',
    'assets/images/uploads/2017/01/gallery_04.webp'
  ];

  final List<String> imageCake = [
    'assets/images/uploads/2017/01/Cakes19.webp',
    'assets/images/uploads/2017/01/Cakes18.webp',
    'assets/images/uploads/2017/01/Cakes17-1.webp',
    'assets/images/uploads/2017/01/Cakes16.webp'
  ];

  final List<String> imageFood = [
    'assets/images/uploads/2017/01/food1.webp',
    'assets/images/uploads/2017/01/food2.webp',
    'assets/images/uploads/2017/01/food3.webp',
    'assets/images/uploads/2017/01/food4.webp'
  ];

  @override
  Widget build(BuildContext context) {
    // Determine screen width to adjust grid
    final screenWidth = MediaQuery.of(context).size.width;
    int imagesPerRow;
    if (screenWidth >= 1024) {
      imagesPerRow = 4; // Desktop
    } else if (screenWidth >= 600) {
      imagesPerRow = 3; // Tablet
    } else {
      imagesPerRow = 2; // Mobile
    }

    List<String> currentImages = isAllVisible
        ? imageAll
        : isCakeVisible
            ? imageCake
            : imageFood;

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButton('All', () {
                  setState(() {
                    selectedButton = 'All';
                    isAllVisible = true;
                    isCakeVisible = false;
                    isFoodVisible = false;
                  });
                }),
                const SizedBox(width: 10),
                buildButton('Cakes', () {
                  setState(() {
                    selectedButton = 'Cakes';
                    isAllVisible = false;
                    isCakeVisible = true;
                    isFoodVisible = false;
                  });
                }),
                const SizedBox(width: 10),
                buildButton('Food', () {
                  setState(() {
                    selectedButton = 'Food';
                    isAllVisible = false;
                    isCakeVisible = false;
                    isFoodVisible = true;
                  });
                }),
              ],
            ),

            const SizedBox(height: 30),

            // Responsive Image Grid
            // Wrap the Image.asset with GestureDetector
            Wrap(
              spacing: 0,
              runSpacing: 0,
              children: currentImages.map((image) {
                double width = (screenWidth - ((imagesPerRow - 1) * 10) - 40) /
                    imagesPerRow;
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.transparent,
                      builder: (_) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.all(5),
                        child: Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Image with background and shadow
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white, // background color
                                  //  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 15,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 50), // space around image
                                child: InteractiveViewer(
                                  child: Image.asset(
                                    image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              // Close button above the image
                              Positioned(
                                top: -10, // slightly above
                                right: -10, // slightly outside right
                                child: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.black, size: 30),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: width,
                    child: ClipRRect(
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String title, VoidCallback onPressed) {
    bool isSelected = selectedButton == title;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        backgroundColor: isSelected ? const Color(0xffE2001A) : Colors.white,
        side: const BorderSide(color: Color(0xffE2001A), width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Text(
        title,
        style: GoogleFonts.raleway(
          color: isSelected ? Colors.white : const Color(0xffE2001A),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
