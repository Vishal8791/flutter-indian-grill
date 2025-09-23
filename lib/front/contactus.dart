// contactus.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:indiangrill/front/career.dart';

class Contactus extends StatefulWidget {
  const Contactus({super.key});
  @override
  State<Contactus> createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  bool formSubmitted = false;
  Future<void> submitContactForm(BuildContext context) async {
    final url =
        Uri.parse('https://www.indian-grill.com/wp-json/flutter/v1/contact');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': mobileController.text.trim(),
          'comment': commentController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          formSubmitted = true;
          nameController.clear();
          emailController.clear();
          mobileController.clear();
          commentController.clear();
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(data['message'] ?? 'Submitted successfully!')),
        // );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting form.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: LayoutBuilder(builder: (context, Constraints) {
          double screenWidth = Constraints.maxWidth;
          if (kIsWeb) {
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
        }));
  }

  Widget buildDesktopLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(190, 20, 190, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 300,
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
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                        'Contact Us',
                                        style: GoogleFonts.raleway(
                                          fontSize: 20,
                                          color: const Color(0xffE2001A),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      LabeledTextField(
                                          labelText: 'Name',
                                          controller: nameController),
                                      LabeledTextField(
                                          labelText: 'Email',
                                          controller: emailController),
                                      LabeledTextField(
                                          labelText: 'Telephone',
                                          controller: mobileController),
                                      LabeledTextField(
                                          labelText: 'Comment',
                                          controller: commentController),
                                      Container(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Builder(
                                          builder: (BuildContext context) {
                                            return ElevatedButton(
                                              onPressed: () =>
                                                  submitContactForm(context),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    const Color(0xffe2001a),
                                                textStyle: const TextStyle(
                                                    fontSize: 20),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              child: Text(
                                                'Send',
                                                style: GoogleFonts.raleway(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/uploads/2020/04/IMG_0118.jpg',
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Indian Grill\nHotBreads Cakes & Curries\n969 Bethlehem Pike\nMontgomeryville PA 18936\n',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff666666),
                            ),
                          ),
                          Text(
                            'Phone: 215-855-4900 \n\nE-mail: contact@indian-grill.com\n\nWebsite: indian-grill.com',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              color: const Color(0xff666666),
                            ),
                          )
                        ],
                      ))
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildTabletLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(190, 20, 190, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Contact Us',
                                  style: GoogleFonts.raleway(
                                    fontSize: 20,
                                    color: const Color(0xffE2001A),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                LabeledTextField(
                                    labelText: 'Name',
                                    controller: nameController),
                                LabeledTextField(
                                    labelText: 'Email',
                                    controller: emailController),
                                LabeledTextField(
                                    labelText: 'Telephone',
                                    controller: mobileController),
                                LabeledTextField(
                                    labelText: 'Comment',
                                    controller: commentController),
                                Container(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Builder(
                                    builder: (BuildContext context) {
                                      return ElevatedButton(
                                        onPressed: () =>
                                            submitContactForm(context),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              const Color(0xffe2001a),
                                          textStyle:
                                              const TextStyle(fontSize: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        child: Text(
                                          'Send',
                                          style: GoogleFonts.raleway(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/uploads/2020/04/IMG_0118.jpg',
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Indian Grill\nHotBreads Cakes & Curries\n969 Bethlehem Pike\nMontgomeryville PA 18936\n',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff666666),
                            ),
                          ),
                          Text(
                            'Phone: 215-855-4900 \n\nE-mail: contact@indian-grill.com\n\nWebsite: indian-grill.com',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              color: const Color(0xff666666),
                            ),
                          )
                        ],
                      ))
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildMobileLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Us Heading
          Text(
            'Contact Us',
            style: GoogleFonts.raleway(
              fontSize: 20,
              color: const Color(0xffE2001A),
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          // Contact Form
          LabeledTextField(labelText: 'Name', controller: nameController),
          const SizedBox(height: 12),
          LabeledTextField(labelText: 'Email', controller: emailController),
          const SizedBox(height: 12),
          LabeledTextField(
              labelText: 'Telephone', controller: mobileController),
          const SizedBox(height: 12),
          LabeledTextField(labelText: 'Comment', controller: commentController),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              print('Send button pressed!');
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xffe2001a),
              textStyle: const TextStyle(fontSize: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              'Send',
              style: GoogleFonts.raleway(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Address + Image
          Image.asset('assets/images/uploads/2020/04/IMG_0118.jpg'),
          const SizedBox(height: 30),
          Text(
            'Indian Grill\nHotBreads Cakes & Curries\n969 Bethlehem Pike\nMontgomeryville PA 18936\n',
            style: GoogleFonts.raleway(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xff666666),
            ),
          ),
          Text(
            'Phone: 215-855-4900 \n\nE-mail: contact@indian-grill.com\n\nWebsite: indian-grill.com',
            style: GoogleFonts.raleway(
              fontSize: 13,
              color: const Color(0xff666666),
            ),
          ),
        ],
      ),
    );
  }
}
