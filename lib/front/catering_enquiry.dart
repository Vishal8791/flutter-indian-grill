import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiangrill/front/career.dart';
import 'package:http/http.dart' as http;

class CateringEnquiry extends StatefulWidget {
  const CateringEnquiry({super.key});

  @override
  _CateringEnquiryState createState() => _CateringEnquiryState();
}

class _CateringEnquiryState extends State<CateringEnquiry> {
  final List<String> eventTime = <String>[
    'Lunch',
    'Dinner',
    'Lunch and Dinner',
    'Other'
  ];

  final List<String> refferal = <String>[
    'Existing Customer',
    'Friend',
    'Magazine',
    'Newspaper',
    'Facebook',
    'Email',
    'Internet Search',
    'Internet Yellow Pages',
    'Other'
  ];

  final List<String> occasions = <String>[
    'Birthday party',
    'Wedding',
    'Anniversary',
    'Garba',
    'Engagement',
    'Sweet 16',
    'Baby Shower',
    'Mehndi',
    'Baptism',
    'Graduation Party',
    'Corporate Event',
    'Sari Ceremony',
    'Others'
  ];
  final List<String> list1 = [
    'Graduations',
    'Baby Showers',
    'Communions',
    'Engagement Parties',
    'Birthday Parties',
    'Christenings',
    'Business Meetings',
  ];

  final List<String> list2 = [
    'Bridal Showers',
    'Confirmations',
    'Rehearsal Dinners',
    'Corporate Seminars',
    'Holiday Parties',
    'Anniversary Parties',
    'Bar Mitzvahs',
  ];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController eventtimeController = TextEditingController();
  final TextEditingController cateringTypeController = TextEditingController();
  final TextEditingController foodtypeController = TextEditingController();
  final TextEditingController guestController = TextEditingController();
  final TextEditingController occasionController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  bool formSubmitted = false;
  Future<void> submitcateringForm(BuildContext context) async {
    final url = Uri.parse(
        'https://www.indian-grill.com/wp-json/flutter/v1/cateringForm');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name' : nameController.text.trim(),
          'email': emailController.text.trim(),
          'mobile': mobileController.text.trim(),
          'date': dateController.text.trim(),
          'eventtime': eventtimeController.text.trim(),
          'cateringtype': cateringTypeController.text.trim(),
          'foodtype': foodtypeController.text.trim(),
          'guests': guestController.text.trim(),
          'occasion' :occasionController.text.trim(),
          'about': aboutController.text.trim(),
          'comment':commentController.text.trim()
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          formSubmitted = true;
          nameController.clear();
          emailController.clear();
          mobileController.clear();
          dateController.clear();
          cateringTypeController.clear();
          foodtypeController.clear();
          guestController.clear();
          eventtimeController.clear();
          commentController.clear();
          occasionController.clear();
          aboutController.clear();
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(data['message'] ?? 'Submitted successfully!')),
        // );
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting form.')),
      );
    }
  }

  // Add a variable to store the selected event time
  String? selectedEventTime;
  String? selectedOccassion;
  String? selectedReferral;
  @override
  void initState() {
    super.initState();
    // Initialize selected values to the first item in their respective lists
    selectedEventTime = eventTime.first;
    selectedOccassion = occasions.first;
    selectedReferral = refferal.first;
    cateringType = "On Premises";
    cateringTypeController.text = cateringType!;
    eventtimeController.text = selectedEventTime ?? '';
    occasionController.text = selectedOccassion ?? '';
    aboutController.text = selectedReferral ?? '';
  }

  String cateringType = "On Premises";
  String foodtype = 'Vegetarian'; // Default selection
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: LayoutBuilder(
          builder: (context, Constraints) {
            double screenWidth = Constraints.maxWidth;
            // // print("Current Width: $screenWidth");

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
      padding: const EdgeInsets.fromLTRB(190, 20, 190, 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column with text and list
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        color: Color(0xffe5e5e5),
                        thickness: 1,
                      ),
                      Text(
                        'Let INDIAN GRILLS (NORTH WALES)\nHelp you plan and cater\nyour next special event!',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          color: const Color(0xff666666),
                        ),
                      ),
                      const Divider(
                        color: Color(0xffe5e5e5),
                        thickness: 1,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // First column of list items
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: list1
                                    .map(
                                      (item) => RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: '• ',
                                              style: TextStyle(
                                                fontSize: 16, // Bullet size
                                                color: Color(0xff666666),
                                              ),
                                            ),
                                            TextSpan(
                                              text: item,
                                              style: GoogleFonts.raleway(
                                                fontSize: 14, // Text size
                                                color: const Color(0xff666666),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            // Second column of list items
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: list2
                                    .map(
                                      (item) => RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: '• ',
                                              style: TextStyle(
                                                fontSize: 16, // Bullet size
                                                color: Color(0xff666666),
                                              ),
                                            ),
                                            TextSpan(
                                              text: item,
                                              style: GoogleFonts.raleway(
                                                fontSize: 14, // Text size
                                                color: const Color(0xff666666),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xffe5e5e5),
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'And more...',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              color: const Color(0xff666666),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Divider(
                            color: Color(0xffe5e5e5),
                            thickness: 1,
                          )),
                      Text(
                        'Please fill out the form below to send a request to Indian Grills (North Wales) to cater for any of your occasions.',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          color: const Color(0xff666666),
                        ),
                      ),
                      const Divider(
                        color: Color(0xffe5e5e5),
                        thickness: 1,
                      ),
                      Text(
                        'Indian Grills (North Wales) will contact you regarding the catering request.',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          color: const Color(0xff666666),
                        ),
                      ),
                      SizedBox(
                        width: 450,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabeledTextField(
                              labelText: 'Name',
                              controller: nameController,
                            ),
                            LabeledTextField(
                              labelText: 'Email',
                              controller: emailController,
                            ),
                            LabeledTextField(
                              labelText: 'Contact Number',
                              controller: mobileController,
                            ),
                            LabeledTextField(
                              labelText: 'Event Date',
                              controller: dateController,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Event Time',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                ),
                              ),
                            ),
                            // Add DropdownButton for Event Time
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: const BorderSide(
                                      color: Color(0xff666666),
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // No rounded corners
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color when text field is not focused
                                      width: 0.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // No rounded corners
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color when text field is focused
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                value: selectedEventTime,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedEventTime = newValue;
                                    eventtimeController.text = newValue ?? eventTime.first;
                                  });
                                },
                                items: eventTime
                                    .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: GoogleFonts.raleway(
                                            fontSize: 13,
                                            color: const Color(0xff666666),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Type of Catering:',
                                    style: GoogleFonts.raleway(
                                      fontSize: 13,
                                      color: const Color(0xff666666),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(
                                            'On Premises',
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                          value: "On Premises",
                                          groupValue: cateringType,
                                          onChanged: (String? value) {
                                            setState(() {
                                              cateringType = value!;
                                              cateringTypeController.text = cateringType;
                                            });
                                          },
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical:
                                                      0), // Adjusts padding
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(
                                            'External Location',
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                          value: "External Location",
                                          groupValue: cateringType,
                                          onChanged: (String? value) {
                                            setState(() {
                                              cateringType = value!;
                                              cateringTypeController.text = cateringType;
                                            });
                                          },
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical:
                                                      0), // Adjusts padding
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Occasion :',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: const BorderSide(
                                      color: Color(0xff666666),
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // No rounded corners
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color when text field is not focused
                                      width: 0.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // No rounded corners
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color when text field is focused
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                value: selectedOccassion,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOccassion = newValue;
                                    occasionController.text = newValue ?? '';
                                    
                                  });
                                },
                                items: occasions
                                    .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: GoogleFonts.raleway(
                                            fontSize: 13,
                                            color: const Color(0xff666666),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Type of Food:',
                                    style: GoogleFonts.raleway(
                                      fontSize: 13,
                                      color: const Color(0xff666666),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(
                                            'Vegetarian',
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                          value: "vegetarian",
                                          groupValue: foodtype,
                                          onChanged: (String? value) {
                                            setState(() {
                                              foodtype = value!;
                                              foodtypeController.text = foodtype;
                                            });
                                          },
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical:
                                                      0), // Adjusts padding
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(
                                            'Non Vegetarian',
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                          value: "nonvegetarian",
                                          groupValue: foodtype,
                                          onChanged: (String? value) {
                                            setState(() {
                                              foodtype = value!;
                                              foodtypeController.text = foodtype;

                                            });
                                          },
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical:
                                                      0), // Adjusts padding
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(
                                            'both',
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                          value: "both",
                                          groupValue: foodtype,
                                          onChanged: (String? value) {
                                            setState(() {
                                              foodtype = value!;
                                              foodtypeController.text = foodtype;
                                            });
                                          },
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical:
                                                      0), // Adjusts padding
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            LabeledTextField(
                              labelText: 'Estimated Number of Guests :',
                              controller: guestController,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                'Comments',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                ),
                              ),
                            ),
                            TextField(
                              controller: commentController,
                              maxLines:
                                  null, // This allows the TextField to grow vertically
                              minLines: 5, // Minimum height when empty
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xff666666), // Border color
                                    width: 0.1, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      0), // Optional: adds rounded corners
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'How Did You Hear About Us :',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: const BorderSide(
                                      color: Color(0xff666666),
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // No rounded corners
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color when text field is not focused
                                      width: 0.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // No rounded corners
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color when text field is focused
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                value: selectedReferral,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedReferral = newValue;
                                    aboutController.text = newValue ?? refferal.first;
                                  });
                                },
                                items: refferal
                                    .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: GoogleFonts.raleway(
                                            fontSize: 13,
                                            color: const Color(0xff666666),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                             onPressed: () => submitcateringForm(context),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color(0xffe2001a), // Text color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              textStyle: const TextStyle(fontSize: 20),
                            ).copyWith(
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // No border radius
                                ),
                              ),
                            ),
                            child: const Text('Send'),
                          )),
                    ],
                  ),
                ),
              ),
              // Right column with image
              Expanded(
                flex: 3,
                child: Image.asset(
                  'assets/images/uploads/2016/11/store.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMobileLayout() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column with text and list
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: Color(0xffe5e5e5),
                    thickness: 1,
                  ),
                  Text(
                    'Let INDIAN GRILLS (NORTH WALES)\nHelp you plan and cater\nyour next special event!',
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      color: const Color(0xff666666),
                    ),
                  ),
                  const Divider(
                    color: Color(0xffe5e5e5),
                    thickness: 1,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First column of list items
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: list1
                                .map(
                                  (item) => RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: '• ',
                                          style: TextStyle(
                                            fontSize: 16, // Bullet size
                                            color: Color(0xff666666),
                                          ),
                                        ),
                                        TextSpan(
                                          text: item,
                                          style: GoogleFonts.raleway(
                                            fontSize: 14, // Text size
                                            color: const Color(0xff666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        // Second column of list items
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: list2
                                .map(
                                  (item) => RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: '• ',
                                          style: TextStyle(
                                            fontSize: 16, // Bullet size
                                            color: Color(0xff666666),
                                          ),
                                        ),
                                        TextSpan(
                                          text: item,
                                          style: GoogleFonts.raleway(
                                            fontSize: 14, // Text size
                                            color: const Color(0xff666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color(0xffe5e5e5),
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'And more...',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          color: const Color(0xff666666),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Divider(
                        color: Color(0xffe5e5e5),
                        thickness: 1,
                      )),
                  Text(
                    'Please fill out the form below to send a request to Indian Grills (North Wales) to cater for any of your occasions.',
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      color: const Color(0xff666666),
                    ),
                  ),
                  const Divider(
                    color: Color(0xffe5e5e5),
                    thickness: 1,
                  ),
                  Text(
                    'Indian Grills (North Wales) will contact you regarding the catering request.',
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      color: const Color(0xff666666),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              // Right column with image
              Image.asset(
                'assets/images/uploads/2016/11/store.jpg',
                fit: BoxFit.cover,
              ),

              Container(
                padding: const EdgeInsets.only(top: 20),
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledTextField(
                      labelText: 'Name',
                      controller: nameController,
                    ),
                    LabeledTextField(
                      labelText: 'Email',
                      controller: emailController,
                    ),
                    LabeledTextField(
                      labelText: 'Contact Number',
                      controller: mobileController,
                    ),
                    LabeledTextField(
                      labelText: 'Event Date',
                      controller: dateController,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Event Time',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          color: const Color(0xff666666),
                        ),
                      ),
                    ),
                    // Add DropdownButton for Event Time
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: const BorderSide(
                              color: Color(0xff666666),
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(0), // No rounded corners
                            borderSide: const BorderSide(
                              color: Colors
                                  .grey, // Border color when text field is not focused
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(0), // No rounded corners
                            borderSide: const BorderSide(
                              color: Colors
                                  .grey, // Border color when text field is focused
                              width: 0.5,
                            ),
                          ),
                        ),
                        value: selectedEventTime,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedEventTime = newValue;
                            eventtimeController.text = newValue ?? eventTime.first;
                          });
                        },
                        items: eventTime
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: GoogleFonts.raleway(
                                    fontSize: 13,
                                    color: const Color(0xff666666),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Type of Catering:',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              color: const Color(0xff666666),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text(
                                    'On Premises',
                                    style: GoogleFonts.raleway(
                                      fontSize: 12,
                                      color: const Color(0xff666666),
                                    ),
                                  ),
                                  value: "On Premises",
                                  groupValue: cateringType,
                                  onChanged: (String? value) {
                                    setState(() {
                                      cateringType = value!;
                                      cateringTypeController.text = cateringType;
                                    });
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 0), // Adjusts padding
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text(
                                    'External Location',
                                    style: GoogleFonts.raleway(
                                      fontSize: 12,
                                      color: const Color(0xff666666),
                                    ),
                                  ),
                                  value: "External Location",
                                  groupValue: cateringType,
                                  onChanged: (String? value) {
                                    setState(() {
                                      cateringType = value!;
                                      cateringTypeController.text = cateringType;
                                    });
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 0), // Adjusts padding
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Occasion :',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          color: const Color(0xff666666),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: const BorderSide(
                              color: Color(0xff666666),
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(0), // No rounded corners
                            borderSide: const BorderSide(
                              color: Colors
                                  .grey, // Border color when text field is not focused
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(0), // No rounded corners
                            borderSide: const BorderSide(
                              color: Colors
                                  .grey, // Border color when text field is focused
                              width: 0.5,
                            ),
                          ),
                        ),
                        value: selectedOccassion,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOccassion = newValue;
                            occasionController.text = newValue ?? '';
                          });
                        },
                        items: occasions
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: GoogleFonts.raleway(
                                    fontSize: 13,
                                    color: const Color(0xff666666),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Type of Food:',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              color: const Color(0xff666666),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text(
                                    'Vegetarian',
                                    style: GoogleFonts.raleway(
                                      fontSize: 12,
                                      color: const Color(0xff666666),
                                    ),
                                  ),
                                  value: "vegetarian",
                                  groupValue: foodtype,
                                  onChanged: (String? value) {
                                    setState(() {
                                      foodtype = value!;
                                      foodtypeController.text = foodtype;
                                    });
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 0), // Adjusts padding
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text(
                                    'Non Vegetarian',
                                    style: GoogleFonts.raleway(
                                      fontSize: 12,
                                      color: const Color(0xff666666),
                                    ),
                                  ),
                                  value: "nonvegetarian",
                                  groupValue: foodtype,
                                  onChanged: (String? value) {
                                    setState(() {
                                      foodtype = value!;
                                      foodtypeController.text = foodtype;
                                    });
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 0), // Adjusts padding
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text(
                                    'both',
                                    style: GoogleFonts.raleway(
                                      fontSize: 12,
                                      color: const Color(0xff666666),
                                    ),
                                  ),
                                  value: "both",
                                  groupValue: foodtype,
                                  onChanged: (String? value) {
                                    setState(() {
                                      foodtype = value!;
                                      foodtypeController.text = foodtype;
                                    });
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 0), // Adjusts padding
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    LabeledTextField(
                      labelText: 'Estimated Number of Guests :',
                      controller: aboutController,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        'Comments',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          color: const Color(0xff666666),
                        ),
                      ),
                    ),
                    TextField(
                      controller: commentController,
                      maxLines:
                          null, // This allows the TextField to grow vertically
                      minLines: 5, // Minimum height when empty
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xff666666), // Border color
                            width: 0.1, // Border width
                          ),
                          borderRadius: BorderRadius.circular(
                              0), // Optional: adds rounded corners
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'How Did You Hear About Us :',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          color: const Color(0xff666666),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: const BorderSide(
                              color: Color(0xff666666),
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(0), // No rounded corners
                            borderSide: const BorderSide(
                              color: Colors
                                  .grey, // Border color when text field is not focused
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(0), // No rounded corners
                            borderSide: const BorderSide(
                              color: Colors
                                  .grey, // Border color when text field is focused
                              width: 0.5,
                            ),
                          ),
                        ),
                        value: selectedReferral,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedReferral = newValue;
                            aboutController.text = newValue ?? refferal.first;
                          });
                        },
                        items: refferal
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: GoogleFonts.raleway(
                                    fontSize: 13,
                                    color: const Color(0xff666666),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                   onPressed: () => submitcateringForm(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xffe2001a), // Text color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(fontSize: 20),
                    ).copyWith(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(4), // No border radius
                        ),
                      ),
                    ),
                    child: const Text('Send'),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTabletLayout() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column with text and list
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        color: Color(0xffe5e5e5),
                        thickness: 1,
                      ),
                      Text(
                        'Let INDIAN GRILLS (NORTH WALES)\nHelp you plan and cater\nyour next special event!',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          color: const Color(0xff666666),
                        ),
                      ),
                      const Divider(
                        color: Color(0xffe5e5e5),
                        thickness: 1,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // First column of list items
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: list1
                                    .map(
                                      (item) => RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: '• ',
                                              style: TextStyle(
                                                fontSize: 16, // Bullet size
                                                color: Color(0xff666666),
                                              ),
                                            ),
                                            TextSpan(
                                              text: item,
                                              style: GoogleFonts.raleway(
                                                fontSize: 14, // Text size
                                                color: const Color(0xff666666),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            // Second column of list items
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: list2
                                    .map(
                                      (item) => RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: '• ',
                                              style: TextStyle(
                                                fontSize: 16, // Bullet size
                                                color: Color(0xff666666),
                                              ),
                                            ),
                                            TextSpan(
                                              text: item,
                                              style: GoogleFonts.raleway(
                                                fontSize: 14, // Text size
                                                color: const Color(0xff666666),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xffe5e5e5),
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'And more...',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              color: const Color(0xff666666),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Divider(
                            color: Color(0xffe5e5e5),
                            thickness: 1,
                          )),
                      Text(
                        'Please fill out the form below to send a request to Indian Grills (North Wales) to cater for any of your occasions.',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          color: const Color(0xff666666),
                        ),
                      ),
                      const Divider(
                        color: Color(0xffe5e5e5),
                        thickness: 1,
                      ),
                      Text(
                        'Indian Grills (North Wales) will contact you regarding the catering request.',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          color: const Color(0xff666666),
                        ),
                      ),
                      SizedBox(
                        width: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabeledTextField(
                              labelText: 'Name',
                              controller: nameController,
                            ),
                            LabeledTextField(
                              labelText: 'Email',
                              controller: emailController,
                            ),
                            LabeledTextField(
                              labelText: 'Contact Number',
                              controller: mobileController,
                            ),
                            LabeledTextField(
                              labelText: 'Event Date',
                              controller: dateController,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Event Time',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                ),
                              ),
                            ),
                            // Add DropdownButton for Event Time
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: const BorderSide(
                                      color: Color(0xff666666),
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // No rounded corners
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color when text field is not focused
                                      width: 0.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // No rounded corners
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color when text field is focused
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                value: selectedEventTime,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedEventTime = newValue;
                                    eventtimeController.text = newValue ?? eventTime.first;
                                  });
                                },
                                items: eventTime
                                    .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: GoogleFonts.raleway(
                                            fontSize: 13,
                                            color: const Color(0xff666666),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Type of Catering:',
                                    style: GoogleFonts.raleway(
                                      fontSize: 13,
                                      color: const Color(0xff666666),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(
                                            'On Premises',
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                          value: "On Premises",
                                          groupValue: cateringType,
                                          onChanged: (String? value) {
                                            setState(() {
                                              cateringType = value!;
                                              cateringTypeController.text = cateringType;
                                            });
                                          },
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical:
                                                      0), // Adjusts padding
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(
                                            'External Location',
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                          value: "External Location",
                                          groupValue: cateringType,
                                          onChanged: (String? value) {
                                            setState(() {
                                              cateringType = value!;
                                              cateringTypeController.text = cateringType;
                                            });
                                          },
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical:
                                                      0), // Adjusts padding
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Occasion :',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: const BorderSide(
                                      color: Color(0xff666666),
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // No rounded corners
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color when text field is not focused
                                      width: 0.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // No rounded corners
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color when text field is focused
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                value: selectedOccassion,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOccassion = newValue;
                                    occasionController.text = newValue ?? '';
                                  });
                                },
                                items: occasions
                                    .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: GoogleFonts.raleway(
                                            fontSize: 13,
                                            color: const Color(0xff666666),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Type of Food:',
                                    style: GoogleFonts.raleway(
                                      fontSize: 13,
                                      color: const Color(0xff666666),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(
                                            'Vegetarian',
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                          value: "vegetarian",
                                          groupValue: foodtype,
                                          onChanged: (String? value) {
                                            setState(() {
                                              foodtype = value!;
                                              foodtypeController.text = foodtype;
                                            });
                                          },
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical:
                                                      0), // Adjusts padding
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(
                                            'Non Vegetarian',
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                          value: "nonvegetarian",
                                          groupValue: foodtype,
                                          onChanged: (String? value) {
                                            setState(() {
                                              foodtype = value!;
                                              foodtypeController.text = foodtype;
                                            });
                                          },
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical:
                                                      0), // Adjusts padding
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(
                                            'both',
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                          value: "both",
                                          groupValue: foodtype,
                                          onChanged: (String? value) {
                                            setState(() {
                                              foodtype = value!;
                                              foodtypeController.text = foodtype;
                                            });
                                          },
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical:
                                                      0), // Adjusts padding
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            LabeledTextField(
                              labelText: 'Estimated Number of Guests :',
                              controller: aboutController,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                'Comments',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                ),
                              ),
                            ),
                            TextField(
                              controller: commentController,
                              maxLines:
                                  null, // This allows the TextField to grow vertically
                              minLines: 5, // Minimum height when empty
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xff666666), // Border color
                                    width: 0.1, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      0), // Optional: adds rounded corners
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'How Did You Hear About Us :',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: const BorderSide(
                                      color: Color(0xff666666),
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // No rounded corners
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color when text field is not focused
                                      width: 0.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // No rounded corners
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color when text field is focused
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                value: selectedReferral,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedReferral = newValue;
                                    aboutController.text = newValue ?? refferal.first;
                                  });
                                },
                                items: refferal
                                    .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: GoogleFonts.raleway(
                                            fontSize: 13,
                                            color: const Color(0xff666666),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                          onPressed: () => submitcateringForm(context),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color(0xffe2001a), // Text color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              textStyle: const TextStyle(fontSize: 20),
                            ).copyWith(
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // No border radius
                                ),
                              ),
                            ),
                            child: const Text('Send'),
                          )),
                    ],
                  ),
                ),
              ),
              // Right column with image
              Expanded(
                flex: 3,
                child: Image.asset(
                  'assets/images/uploads/2016/11/store.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
