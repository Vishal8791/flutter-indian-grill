import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool isAllVisible = true;
  bool isCakeVisible = false;
  bool isFoodVisible = false;
  String selectedButton = 'All'; // Track selected button for styling

  final List<String> imageAll = <String>[
    'assets/images/uploads/2017/05/noodle.jpg',
    'assets/images/uploads/2017/05/Thali.jpg',
    'assets/images/uploads/2017/05/chkn-Biryani.jpg',
    'assets/images/uploads/2017/01/noodles-and-veg-manchurian.jpg',
    'assets/images/uploads/2017/01/vada-pav.jpg',
    'assets/images/uploads/2017/01/jalebi.jpg',
    'assets/images/uploads/2017/01/IMG_0190.jpg',
    'assets/images/uploads/2017/01/IMG_0166.jpg',
    'assets/images/uploads/2017/01/IMG_0163.jpg',
    'assets/images/uploads/2017/01/IMG_0135.jpg',
    'assets/images/uploads/2017/01/garlic-naan.jpg',
    'assets/images/uploads/2017/01/gallery_04.jpg'
  ];

  final List<String> imageCake = <String>[
    'assets/images/uploads/2017/01/Cakes19.jpg',
    'assets/images/uploads/2017/01/Cakes18.jpg',
    'assets/images/uploads/2017/01/Cakes17-1.jpg',
    'assets/images/uploads/2017/01/Cakes16.jpg'
  ];

  List<Row> buildImageRows(List<String> images, int itemsPerRow) {
    List<Row> rows = [];
    for (var i = 0; i < images.length; i += itemsPerRow) {
      List<Widget> rowImages = [];
      for (var j = i; j < i + itemsPerRow && j < images.length; j++) {
        rowImages.add(
          Padding(
            padding: const EdgeInsets.all(0), // No spacing between images
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0), // square corners
              child: Image.asset(
                images[j],
                fit: BoxFit.cover,
                width: 300,
                height: 200,
              ),
            ),
          ),
        );
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center, // Even spacing between images
        children: rowImages,
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Buttons
          Padding(padding: const EdgeInsets.only(top:30,bottom: 20),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Adjusts buttons alignment
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
          ),
          
          const SizedBox(height: 50), // Space between buttons and images

          // Image Sections
          if (isAllVisible)
            Column(
              children: buildImageRows(imageAll, 4), // Build rows with 4 images per row
            ),

          if (isCakeVisible)
            Column(
              children: buildImageRows(imageCake, 4), // Build rows with 4 images per row
            ),

          if (isFoodVisible)
            Column(
              children: buildImageRows(imageAll, 4), // Build rows with 4 images per row
            ),
          const SizedBox(height: 100,)
        ],
      ),
    );
  }

  // Helper function to create buttons with styles
  Widget buildButton(String title, VoidCallback onPressed) {
    bool isSelected = selectedButton == title;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        backgroundColor: isSelected ? const Color(0xffE2001A) : Colors.white,
        side: const BorderSide(color: Color(0XFFE2001A),width: 0.5),
         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: Text(
        title,
        style: GoogleFonts.raleway(
          color: isSelected ? Colors.white : const Color(0xffE2001A),
        
        ),
      ),
    );
  }
}
