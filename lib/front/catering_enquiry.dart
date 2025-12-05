// ignore_for_file: deprecated_member_use
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiangrill/front/career.dart';
import 'package:http/http.dart' as http;
import 'package:indiangrill/front/datepicker/date_picker_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:indiangrill/captcha/math_captcha.dart';

class CateringEnquiry extends StatefulWidget {
  const CateringEnquiry({super.key});

  @override
  CateringEnquiryState createState() => CateringEnquiryState();
}

class CateringEnquiryState extends State<CateringEnquiry> {
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
  final TextEditingController captchaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool formSubmitted = false;
  bool isLoading = false;

  Future<void> submitcateringForm(BuildContext context) async {
    final url = Uri.parse(
        'https://www.dev.indian-grill.com/wp-json/flutter/v1/cateringForm');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'mobile': mobileController.text.trim(),
          'date': dateController.text.trim(),
          'eventtime': eventtimeController.text.trim(),
          'cateringtype': cateringTypeController.text.trim(),
          'foodtype': foodtypeController.text.trim(),
          'guests': guestController.text.trim(),
          'occasion': occasionController.text.trim(),
          'about': aboutController.text.trim(),
          'comment': commentController.text.trim()
        }),
      );

      if (response.statusCode == 200) {
       // final data = jsonDecode(response.body);

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
    cateringTypeController.text = cateringType;
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
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
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
                      Form(
                        key: _formKey,
                        child: formSubmitted
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Thank you!',
                                    style: GoogleFonts.raleway(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Your form has been submitted. We will contact you soon.',
                                    style: GoogleFonts.raleway(fontSize: 16),
                                  ),
                                ],
                              )
                            : SizedBox(
                                width: 400,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabeledTextField(
                                      labelText: 'Name',
                                      controller: nameController,
                                      validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
                    if (!nameRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid name (letters only)';
                    }

                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }

                    return null;
                  },
                                    ),
                                    LabeledTextField(
                                      labelText: 'Email',
                                      controller: emailController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        final emailRegex = RegExp(
                                            r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                                        if (!emailRegex.hasMatch(value)) {
                                          return 'Please enter a valid email address';
                                        }
                                        return null;
                                      },
                                    ),
                                    LabeledTextField(
                                      labelText: 'Contact Number',
                                      controller: mobileController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your mobile number';
                                        }
                                        if (!RegExp(r'^\d{10,15}$')
                                            .hasMatch(value)) {
                                          return 'Please enter a valid mobile number';
                                        }
                                        return null;
                                      },
                                    ),
                                    // LabeledTextField(
                                    //   labelText: 'Event Date',
                                    //   controller: dateController,
                                    // ),
                                    DatePickerField(
                                      controller: dateController,
                                      labelText: "Event Date",
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Event Time : ',
                                        style: GoogleFonts.raleway(
                                          fontSize: 13,
                                          color: const Color(0xff666666),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded:
                                              true, // Make dropdown full width of parent
                                          buttonDecoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          // buttonPadding: const EdgeInsets.symmetric(
                                          //     horizontal: 12, vertical: 12),
                                          value: selectedEventTime,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedEventTime = newValue;
                                              eventtimeController.text =
                                                  newValue ?? eventTime.first;
                                            });
                                          },
                                          items: eventTime
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style:
                                                          GoogleFonts.raleway(
                                                        fontSize: 13,
                                                        color: const Color(
                                                            0xff666666),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          dropdownPadding:
                                              const EdgeInsets.all(1),
                                          dropdownDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.white,
                                          ),
                                          dropdownMaxHeight: 200,
                                          scrollbarAlwaysShow: true,
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Type of Catering :',
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
                                                      color: const Color(
                                                          0xff666666),
                                                    ),
                                                  ),
                                                  value: "On Premises",
                                                  groupValue: cateringType,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      cateringType = value!;
                                                      cateringTypeController
                                                          .text = cateringType;
                                                    });
                                                  },
                                                  contentPadding: const EdgeInsets
                                                      .symmetric(
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
                                                      color: const Color(
                                                          0xff666666),
                                                    ),
                                                  ),
                                                  value: "External Location",
                                                  groupValue: cateringType,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      cateringType = value!;
                                                      cateringTypeController
                                                          .text = cateringType;
                                                    });
                                                  },
                                                  contentPadding: const EdgeInsets
                                                      .symmetric(
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded:
                                              true, // Full width of parent
                                          buttonDecoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          value: selectedOccassion,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedOccassion = newValue;
                                              occasionController.text =
                                                  newValue ?? '';
                                            });
                                          },
                                          items: occasions
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style:
                                                          GoogleFonts.raleway(
                                                        fontSize: 13,
                                                        color: const Color(
                                                            0xff666666),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          dropdownPadding:
                                              const EdgeInsets.all(4),
                                          dropdownDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.white,
                                          ),
                                          dropdownMaxHeight:
                                              200, // Scrollable if many items
                                          scrollbarAlwaysShow: true,
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Type of Food :',
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
                                                      color: const Color(
                                                          0xff666666),
                                                    ),
                                                  ),
                                                  value: "vegetarian",
                                                  groupValue: foodtype,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      foodtype = value!;
                                                      foodtypeController.text =
                                                          foodtype;
                                                    });
                                                  },
                                                  contentPadding: const EdgeInsets
                                                      .symmetric(
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
                                                      color: const Color(
                                                          0xff666666),
                                                    ),
                                                  ),
                                                  value: "nonvegetarian",
                                                  groupValue: foodtype,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      foodtype = value!;
                                                      foodtypeController.text =
                                                          foodtype;
                                                    });
                                                  },
                                                  contentPadding: const EdgeInsets
                                                      .symmetric(
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
                                                      color: const Color(
                                                          0xff666666),
                                                    ),
                                                  ),
                                                  value: "both",
                                                  groupValue: foodtype,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      foodtype = value!;
                                                      foodtypeController.text =
                                                          foodtype;
                                                    });
                                                  },
                                                  contentPadding: const EdgeInsets
                                                      .symmetric(
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
                                      labelText: 'Estimated Number of Guests',
                                      controller: guestController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter number of guests';
                                        }
                                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                                          return 'Please enter a valid number';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType
                                          .number, // Optional: show numeric keyboard
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: Text(
                                        'Comments :',
                                        style: GoogleFonts.raleway(
                                          fontSize: 13,
                                          color: const Color(0xff666666),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: commentController,
                                      maxLines: null, // grows vertically
                                      minLines: 5, // minimum height
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your comments';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xff666666),
                                            width: 0.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          borderSide: const BorderSide(
                                            color: Color(0xff666666),
                                            width: 0.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          borderSide: const BorderSide(
                                            color: Color(0xff666666),
                                            width: 0.5,
                                          ),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded:
                                              true, // make dropdown full width
                                          buttonDecoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                            borderRadius: BorderRadius.circular(
                                                0), // match previous styling
                                          ),
                                          value: selectedReferral,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedReferral = newValue;
                                              aboutController.text =
                                                  newValue ?? refferal.first;
                                            });
                                          },
                                          items: refferal
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style:
                                                          GoogleFonts.raleway(
                                                        fontSize: 13,
                                                        color: const Color(
                                                            0xff666666),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          dropdownPadding:
                                              const EdgeInsets.all(4),
                                          dropdownDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            color: Colors.white,
                                          ),
                                          dropdownMaxHeight:
                                              200, // scrollable if list is long
                                          scrollbarAlwaysShow: true,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                            MathCaptcha(controller: captchaController),
                            const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: !formSubmitted
                            ? ElevatedButton(
                               onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });

                    await submitcateringForm(context);

                    setState(() {
                      isLoading = false;
                    });
                  }
                },
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
                                 child: isLoading
    ? const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
    : Text(
        'Send',
        style: GoogleFonts.raleway(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
              // Right column with image
              Expanded(
                flex: 3,
                child: Image.asset(
                  'assets/images/uploads/2016/11/store.webp',
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
    return SingleChildScrollView(
    
   child: Container(
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
                'assets/images/uploads/2016/11/store.webp',
                fit: BoxFit.cover,
              ),

              Form(
                key: _formKey,
                child: formSubmitted
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Thank you!',
                            style: GoogleFonts.raleway(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Your form has been submitted. We will contact you soon.',
                            style: GoogleFonts.raleway(fontSize: 16),
                          ),
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.only(top: 20),
                        width: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabeledTextField(
                              labelText: 'Name',
                              controller: nameController,
                              validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
                    if (!nameRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid name (letters only)';
                    }

                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }

                    return null;
                  },
                            ),

                            LabeledTextField(
                              labelText: 'Email',
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                final emailRegex = RegExp(
                                    r"^(?!\.)[A-Za-z0-9._%+-]+(?<!\.)@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$",
                                  );
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            LabeledTextField(
                              labelText: 'Contact Number',
                              controller: mobileController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your contact number';
                                }
                                if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                                  return 'Please enter a valid contact number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DatePickerField(
                              controller: dateController,
                              labelText: "Event Date",
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Event Time : ',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded:
                                      true, // Make dropdown full width of parent
                                  buttonDecoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  // buttonPadding: const EdgeInsets.symmetric(
                                  //     horizontal: 12, vertical: 12),
                                  value: selectedEventTime,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedEventTime = newValue;
                                      eventtimeController.text =
                                          newValue ?? eventTime.first;
                                    });
                                  },
                                  items: eventTime
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: GoogleFonts.raleway(
                                                fontSize: 13,
                                                color: const Color(0xff666666),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  dropdownPadding: const EdgeInsets.all(1),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                  dropdownMaxHeight: 200,
                                  scrollbarAlwaysShow: true,
                                ),
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
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "On Premises",
                                            groupValue: cateringType,
                                            onChanged: (value) {
                                              setState(() {
                                                cateringType = value!;
                                                cateringTypeController.text =
                                                    cateringType;
                                              });
                                            },
                                          ),
                                          Text(
                                            "On Premises",
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                          width: 20), // spacing between radios
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "External Location",
                                            groupValue: cateringType,
                                            onChanged: (value) {
                                              setState(() {
                                                cateringType = value!;
                                                cateringTypeController.text =
                                                    cateringType;
                                              });
                                            },
                                          ),
                                          Text(
                                            "External Location",
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                        ],
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
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true, // Full width of parent
                                  buttonDecoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  value: selectedOccassion,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedOccassion = newValue;
                                      occasionController.text = newValue ?? '';
                                    });
                                  },
                                  items: occasions
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: GoogleFonts.raleway(
                                                fontSize: 13,
                                                color: const Color(0xff666666),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  dropdownPadding: const EdgeInsets.all(4),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                  dropdownMaxHeight:
                                      200, // Scrollable if many items
                                  scrollbarAlwaysShow: true,
                                ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "vegetarian",
                                            groupValue: foodtype,
                                            onChanged: (value) {
                                              setState(() {
                                                foodtype = value!;
                                                foodtypeController.text =
                                                    foodtype;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Vegetarian",
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "nonvegetarian",
                                            groupValue: foodtype,
                                            onChanged: (value) {
                                              setState(() {
                                                foodtype = value!;
                                                foodtypeController.text =
                                                    foodtype;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Non Vegetarian",
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "both",
                                            groupValue: foodtype,
                                            onChanged: (value) {
                                              setState(() {
                                                foodtype = value!;
                                                foodtypeController.text =
                                                    foodtype;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Both",
                                            style: GoogleFonts.raleway(
                                              fontSize: 12,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            LabeledTextField(
                              labelText: 'Estimated Number of Guests',
                              controller: guestController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter number of guests';
                                }
                                if (!RegExp(r'^\d+$').hasMatch(value)) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                'Comments :',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: commentController,
                              maxLines: null, // grows vertically
                              minLines: 5, // minimum height
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your comments';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xff666666),
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  borderSide: const BorderSide(
                                    color: Color(0xff666666),
                                    width: 0.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  borderSide: const BorderSide(
                                    color: Color(0xff666666),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
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
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true, // make dropdown full width
                                  buttonDecoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius: BorderRadius.circular(
                                        0), // match previous styling
                                  ),
                                  value: selectedReferral,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedReferral = newValue;
                                      aboutController.text =
                                          newValue ?? refferal.first;
                                    });
                                  },
                                  items: refferal
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: GoogleFonts.raleway(
                                                fontSize: 13,
                                                color: const Color(0xff666666),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  dropdownPadding: const EdgeInsets.all(4),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Colors.white,
                                  ),
                                  dropdownMaxHeight:
                                      200, // scrollable if list is long
                                  scrollbarAlwaysShow: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            MathCaptcha(controller: captchaController),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
              ),
              Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: !formSubmitted
                      ? ElevatedButton(
                              onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });

                    await submitcateringForm(context);

                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xffe2001a),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            textStyle: const TextStyle(fontSize: 20),
                          ).copyWith(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                           child: isLoading
    ? const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
    :Center( 
    child:Text(
        'Send',
        style: GoogleFonts.raleway(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
                        )
                      )
                      : const SizedBox()),
            ],
          ),
        ],
      ),
    )
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
                      Form(
                        key: _formKey,
                        child: formSubmitted
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Thank you!',
                                    style: GoogleFonts.raleway(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Your form has been submitted. We will contact you soon.',
                                    style: GoogleFonts.raleway(fontSize: 16),
                                  ),
                                ],
                              )
                            : SizedBox(
                                width: 350,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabeledTextField(
                                      labelText: 'Name',
                                      controller: nameController,
                                     validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
                    if (!nameRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid name (letters only)';
                    }

                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }

                    return null;
                  },
                                    ),
                                    LabeledTextField(
                                      labelText: 'Email',
                                      controller: emailController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        final emailRegex = RegExp(
                                            r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                                        if (!emailRegex.hasMatch(value)) {
                                          return 'Please enter a valid email address';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    LabeledTextField(
                                      labelText: 'Contact Number',
                                      controller: mobileController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your contact number';
                                        }
                                        if (!RegExp(r'^\d{10,15}$')
                                            .hasMatch(value)) {
                                          return 'Please enter a valid contact number';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                    ),
                                    DatePickerField(
                                      controller: dateController,
                                      labelText: "Event Date",
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top:
                                              16), // slightly more top padding for tablet
                                      child: Text(
                                        'Event Time :',
                                        style: GoogleFonts.raleway(
                                          fontSize:
                                              15, // slightly larger for tablet
                                          color: const Color(0xff666666),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              12), // more vertical padding
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true, // full width
                                          buttonDecoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                            borderRadius: BorderRadius.circular(
                                                6), // smooth corners
                                          ),
                                          value: selectedEventTime,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedEventTime = newValue;
                                              eventtimeController.text =
                                                  newValue ?? eventTime.first;
                                            });
                                          },
                                          items: eventTime
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style:
                                                          GoogleFonts.raleway(
                                                        fontSize:
                                                            15, // larger text for tablet
                                                        color: const Color(
                                                            0xff666666),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          dropdownPadding:
                                              const EdgeInsets.all(8),
                                          dropdownDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: Colors.white,
                                          ),
                                          dropdownMaxHeight:
                                              250, // more height for tablet
                                          scrollbarAlwaysShow: true,
                                          hint: Text(
                                            'Select Event Time',
                                            style: GoogleFonts.raleway(
                                                fontSize: 15,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                      color: const Color(
                                                          0xff666666),
                                                    ),
                                                  ),
                                                  value: "On Premises",
                                                  groupValue: cateringType,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      cateringType = value!;
                                                      cateringTypeController
                                                          .text = cateringType;
                                                    });
                                                  },
                                                  contentPadding: const EdgeInsets
                                                      .symmetric(
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
                                                      color: const Color(
                                                          0xff666666),
                                                    ),
                                                  ),
                                                  value: "External Location",
                                                  groupValue: cateringType,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      cateringType = value!;
                                                      cateringTypeController
                                                          .text = cateringType;
                                                    });
                                                  },
                                                  contentPadding: const EdgeInsets
                                                      .symmetric(
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
                                      padding: const EdgeInsets.only(
                                          top:
                                              16), // more top padding for tablet
                                      child: Text(
                                        'Occasion :',
                                        style: GoogleFonts.raleway(
                                          fontSize:
                                              15, // larger for tablet readability
                                          color: const Color(0xff666666),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              12), // increased vertical padding
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true, // full width
                                          buttonDecoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                            borderRadius: BorderRadius.circular(
                                                6), // smooth corners
                                          ),
                                          value: selectedOccassion,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedOccassion = newValue;
                                              occasionController.text =
                                                  newValue ?? '';
                                            });
                                          },
                                          items: occasions
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style:
                                                          GoogleFonts.raleway(
                                                        fontSize:
                                                            15, // larger text
                                                        color: const Color(
                                                            0xff666666),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          dropdownPadding:
                                              const EdgeInsets.all(8),
                                          dropdownDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: Colors.white,
                                          ),
                                          dropdownMaxHeight:
                                              250, // more height for tablet
                                          scrollbarAlwaysShow: true,
                                          hint: Text(
                                            'Select Occasion',
                                            style: GoogleFonts.raleway(
                                                fontSize: 15,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                      color: const Color(
                                                          0xff666666),
                                                    ),
                                                  ),
                                                  value: "vegetarian",
                                                  groupValue: foodtype,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      foodtype = value!;
                                                      foodtypeController.text =
                                                          foodtype;
                                                    });
                                                  },
                                                  contentPadding: const EdgeInsets
                                                      .symmetric(
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
                                                      color: const Color(
                                                          0xff666666),
                                                    ),
                                                  ),
                                                  value: "nonvegetarian",
                                                  groupValue: foodtype,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      foodtype = value!;
                                                      foodtypeController.text =
                                                          foodtype;
                                                    });
                                                  },
                                                  contentPadding: const EdgeInsets
                                                      .symmetric(
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
                                                      color: const Color(
                                                          0xff666666),
                                                    ),
                                                  ),
                                                  value: "both",
                                                  groupValue: foodtype,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      foodtype = value!;
                                                      foodtypeController.text =
                                                          foodtype;
                                                    });
                                                  },
                                                  contentPadding: const EdgeInsets
                                                      .symmetric(
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
                                      labelText: 'Estimated Number of Guests',
                                      controller: guestController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter number of guests';
                                        }
                                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                                          return 'Please enter a valid number';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: Text(
                                        'Comments :',
                                        style: GoogleFonts.raleway(
                                          fontSize: 13,
                                          color: const Color(0xff666666),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: commentController,
                                      maxLines: null, // grows vertically
                                      minLines: 5, // minimum height
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your comments';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xff666666),
                                            width: 0.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          borderSide: const BorderSide(
                                            color: Color(0xff666666),
                                            width: 0.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          borderSide: const BorderSide(
                                            color: Color(0xff666666),
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top:
                                              16), // more top padding for tablet
                                      child: Text(
                                        'How Did You Hear About Us :',
                                        style: GoogleFonts.raleway(
                                          fontSize:
                                              15, // larger font for tablet
                                          color: const Color(0xff666666),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              12), // increased vertical padding
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true, // full width
                                          buttonDecoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                            borderRadius: BorderRadius.circular(
                                                6), // smooth corners
                                          ),
                                          value: selectedReferral,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedReferral = newValue;
                                              aboutController.text =
                                                  newValue ?? refferal.first;
                                            });
                                          },
                                          items: refferal
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style:
                                                          GoogleFonts.raleway(
                                                        fontSize:
                                                            15, // larger text
                                                        color: const Color(
                                                            0xff666666),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          dropdownPadding:
                                              const EdgeInsets.all(8),
                                          dropdownDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: Colors.white,
                                          ),
                                          dropdownMaxHeight:
                                              250, // scrollable for tablet
                                          scrollbarAlwaysShow: true,
                                          hint: Text(
                                            'Select Referral',
                                            style: GoogleFonts.raleway(
                                                fontSize: 15,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                            MathCaptcha(controller: captchaController),
                            const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: !formSubmitted
                            ? ElevatedButton(
                                    onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });

                    await submitcateringForm(context);

                    setState(() {
                      isLoading = false;
                    });
                  }
                },
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
                                 child: isLoading
    ? const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
    : Text(
        'Send',
        style: GoogleFonts.raleway(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
              // Right column with image
              Expanded(
                flex: 3,
                child: Image.asset(
                  'assets/images/uploads/2016/11/store.webp',
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
