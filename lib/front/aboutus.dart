// aboutus.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Aboutus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(190, 30, 190, 50),
      child: Align(
        child: Column(
          children: [
            Container(
              color: Color(0xfff1f1f1),
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
                            padding: EdgeInsets.all(50),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Who we are',
                                    style: GoogleFonts.raleway(
                                      fontSize: 22,
                                      color: Color(0xffe2001a),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'We are Located in the Heart of Montgomery County on RT 309 . We are Just two blocks away from the Montgomery mall. We invite you to come and enjoy the authentic taste of our time-honored Indian cooking. Inside, you’ll find fast-food dining that provides you a comfortable and friendly environment. Indian Grill takes pride in preparing your meals exactly the way you like it: hot, fresh, and made from scratch everyday. Our team of professional, quality chefs use only the best herbs and spices, putting together a feast for your senses. The variety in our menu is filled with flavorful meals fit for children, adults, and seniors. We are ready to serve when you’re ready to eat.',
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      color: Color(0xff666666),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Our Goal is to provide you fresh and healthy food as quick as possible.'
                                        .toUpperCase(),
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      color: Color(0xff666666),
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
              padding: EdgeInsets.only(top: 100),
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
                                    color: Color(0xffe2001a),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 20),
                               child:Divider(
                        color: Color(0xffe5e5e5), // Divider color
                        thickness: 1, // Divider thickness
                        height: 20, // Space around the divider
                      ),
                                ),
                                const SizedBox(height: 20),

                                Text('Business Details',
                                style: GoogleFonts.raleway(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,

                                ),),
                                
                                Padding(padding: EdgeInsets.only(top: 20),
                                child:Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child:Text(
                                      'Cuisine',
                                      style: GoogleFonts.raleway(
                                        color: Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child:Text(
                                      'buffets, fast food and indian/pakistani',
                                       style: GoogleFonts.raleway(
                                        color: Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )
                                    ),
                                    
                                  ],
                                ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child:Text(
                                      'Parking',
                                       style: GoogleFonts.raleway(
                                        color: Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child:Text(
                                      'Parking Lot Parking',
                                       style: GoogleFonts.raleway(
                                        color: Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )
                                    ),
                                    
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child:Text(
                                      'Price Range',
                                       style: GoogleFonts.raleway(
                                        color: Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child:Text(
                                      '\$',
                                       style: GoogleFonts.raleway(
                                        color: Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )
                                    ),
                                    
                                  ],
                                ),
                              Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child:Text(
                                      'Specialties Serves',
                                       style: GoogleFonts.raleway(
                                        color: Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child:Text(
                                      'lunch and dinner',
                                       style: GoogleFonts.raleway(
                                        color: Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )
                                    ),
                                    
                                  ],
                                ),
                                Row(
                                 
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child:Text(
                                      'Services',
                                       style: GoogleFonts.raleway(
                                        color: Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child:Text(
                                      'Walk-Ins Welcome\nGood For Groups\nGood For Kids\nTake Out\nDelivery\nCatering\nWaiter Service',
                                       style: GoogleFonts.raleway(
                                        color: Color(0xff666666),
                                        fontSize: 13,
                                      ),
                                    )
                                    ),
                                    
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
                            'assets/images/uploads/2016/11/IMG_0118.jpg',
                            width: 570,
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 100),
              child: Row(
                children: [

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
