import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

class BanquetMenu extends StatelessWidget {
  final List<String> appetizers = const <String>[
    'Veg Pakora',
    'Batata Vada',
    'Allu Tiki Chaat',
    'Samosa Chaat',
    'Bhel',
    'Allu Papari Chaat',
    'Veg Cutlet',
    'Idli Sambhar',
    'Gobi Manchurian',
    'Veg Manchurian',
    'Medu Vada Sambhar',
    'Baby Corn Manchurian'
  ];

  final List<String> nonvegappetizers = const <String>[
    'Chicken Tikka',
    'Chicken Seekh Kabab',
    'Chicken Malai Kabab',
    'Tandoori Chicken',
    'Chicken Manchurian',
    'Chilli Chicken',
    'Assorted Kabab',
    'Fish Tikka',
    'Shrimp Pakora',
    'Fish Pakora',
  ];

  final List<String> vegentree = const <String>[
    'Mutter Paneer',
    'Malai Kofta',
    'Saag Paneer',
    'Paneer Tikka Masala',
    'Paneer Makhani',
    'Chana Pindi',
    'Allu Mattar',
    'Allu Gobi Masala',
    'Chana Masala',
    'Dal Tadka',
    'Dal Makhani',
    'Veg Korma',
    'Karahi Vegetable',
    'Mix Vegetables',
    'Veg Jalfreizi',
    'Bhindi Masala',
    'Allu Saag',
    'Veg Fried Rice',
    'Veg Noodles',
    'Veg Manchurian',
    'Veg Biryani',
    'Veg Pulav',
    'Allu Bangain'
  ];

  final List<String> nonvegentree = const <String>[
    'Chicken tikka masala',
    'Chicken Makhani',
    'Chilli Chicken Curry',
    'Chicken Korma',
    'Karahi Chicken',
    'Chicken Manchurian Curry',
    'Chicken Biryani',
    'Chicken Vindallo',
    'Chicken Pepper Fry',
    'Chicken Chettinad',
    'Rogan Josh',
    'Lamb Saag',
    'Lamb Vindaloo',
    'Goat/ Fish Curry',
    'Shrimp Masala',
    'Karahi Goat',
    'Goat Biryani',
    'Shrimp Biryani'
  ];

  final List<String> desserts = const <String>[
    'Fruit Custard',
    'Kheer',
    'Gulab Jamun',
    'Rasmalai',
    'Gajar Halwa',
    'Mango Pudding',
    'Assorted Pastries'
  ];

  const BanquetMenu({super.key});

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
        ));
  }

  Widget buildDesktopLayout() {
    return Container(
      color: Colors.white,
      // Adjusted padding for better alignment
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
                // margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage(imageUrl), // Load images from assets
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 500.0, // Height of the carousel
              enlargeCenterPage: false,
              autoPlay: true,
              // aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.25, // Shows part of adjacent images
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Banquet Menu',
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
          LabeledList(
            title: 'Veg Appetizers',
            items: appetizers,
          ),
          LabeledList(
            title: 'Non Veg Appetizers',
            items: nonvegappetizers,
          ),
          LabeledList(
            title: 'Veg Entree',
            items: vegentree,
          ),
          LabeledList(
            title: 'Non Veg Entree',
            items: nonvegentree,
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: LabeledList(
                title: 'Desserts',
                items: desserts,
              )),
        ],
      ),
    );
  }

  Widget buildMobileLayout() {
    return SingleChildScrollView(
    child:Container(
      color: Colors.white,
      // Adjusted padding for better alignment
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
                // margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage(imageUrl), // Load images from assets
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 450.0, // Height of the carousel
              enlargeCenterPage: false,
              autoPlay: true,
              // aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 1, // Shows part of adjacent images
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Banquet Menu',
              style: GoogleFonts.raleway(
                fontSize: 16,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
              padding: const EdgeInsets.only(left: 15, top: 20),
              child: Column(children: [
                LabeledList(
                  title: 'Veg Appetizers',
                  items: appetizers,
                ),
                LabeledList(
                  title: 'Non Veg Appetizers',
                  items: nonvegappetizers,
                ),
                LabeledList(
                  title: 'Veg Entree',
                  items: vegentree,
                ),
                LabeledList(
                  title: 'Non Veg Entree',
                  items: nonvegentree,
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: LabeledList(
                      title: 'Desserts',
                      items: desserts,
                    )),
              ])),
        ],
      ),
    )
    );
  }

  Widget buildTabletLayout() {
    return Container(
      color: Colors.white,
      // Adjusted padding for better alignment
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
                // margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage(imageUrl), // Load images from assets
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 500.0, // Height of the carousel
              enlargeCenterPage: false,
              autoPlay: true,
              // aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.5, // Shows part of adjacent images
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Banquet Menu',
              style: GoogleFonts.raleway(
                fontSize: 16,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
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
            padding: const EdgeInsets.only(left: 15, top: 20),
            child: Column(
              children: [
                LabeledList(
                  title: 'Veg Appetizers',
                  items: appetizers,
                ),
                LabeledList(
                  title: 'Non Veg Appetizers',
                  items: nonvegappetizers,
                ),
                LabeledList(
                  title: 'Veg Entree',
                  items: vegentree,
                ),
                LabeledList(
                  title: 'Non Veg Entree',
                  items: nonvegentree,
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: LabeledList(
                      title: 'Desserts',
                      items: desserts,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LabeledList extends StatefulWidget {
  final String title;
  final List<String> items;

  const LabeledList({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  _LabeledListState createState() => _LabeledListState();
}

class _LabeledListState extends State<LabeledList> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // 🔹 Use large padding for desktop, small padding for mobile
    final horizontalPadding = screenWidth > 800 ? 190.0 : 6.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 4),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          onExpansionChanged: (expanded) {
            setState(() => _isExpanded = expanded);
          },
          title: Container(
            width: double.infinity,
            color: const Color(0xffe2001a),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  _isExpanded ? '– ' : '+ ',
                  style: GoogleFonts.raleway(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: GoogleFonts.raleway(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          trailing: const SizedBox.shrink(),
          childrenPadding: EdgeInsets.zero,

          // 🔹 Child items
          children: widget.items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff666666),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: const Color(0xff666666),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
