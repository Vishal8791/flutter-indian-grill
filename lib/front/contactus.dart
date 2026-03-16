// contactus.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:indiangrill/front/career.dart';
import 'package:indiangrill/captcha/math_captcha.dart';
import 'package:indiangrill/services/api_config.dart';

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
  final TextEditingController captchaController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();
  bool formSubmitted = false;
  bool isLoading = false;

  Future<void> submitContactForm(BuildContext context) async {
    final url = Uri.parse(
        '${ApiConfig.baseUrl}/wp-json/flutter/v1/contact');

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
     //   final data = jsonDecode(response.body);
        setState(() {
          formSubmitted = true;
          nameController.clear();
          emailController.clear();
          mobileController.clear();
          commentController.clear();
        });

        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
            );
          }
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
    return SingleChildScrollView(
        controller: _scrollController,
        child: Container(
            color: Colors.white,
            child: LayoutBuilder(builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
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
            })));
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        style:
                                            GoogleFonts.raleway(fontSize: 16),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Contact Us',
                                        style: GoogleFonts.raleway(
                                          fontSize: 20,
                                          color: const Color(0xffE2001A),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            LabeledTextField(
                                              labelText: 'Name',
                                              controller: nameController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return 'Please enter your name';
                                                }

                                                final nameRegex =
                                                    RegExp(r"^[a-zA-Z\s'-]+$");
                                                if (!nameRegex
                                                    .hasMatch(value.trim())) {
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
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your email';
                                                }
                                                final regex = RegExp(
                                                    r'^[^@]+@[^@]+\.[^@]+$');
                                                if (!regex.hasMatch(value)) {
                                                  return 'Please enter a valid email';
                                                }
                                                return null;
                                              },
                                            ),
                                            LabeledTextField(
                                              labelText: 'Telephone',
                                              controller: mobileController,
                                              keyboardType: TextInputType.phone,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your phone number';
                                                }
                                                if (value.length < 10) {
                                                  return 'Phone number must be at least 10 digits';
                                                }
                                                return null;
                                              },
                                            ),
                                            LabeledTextField(
                                              labelText: 'Comment',
                                              controller: commentController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a comment';
                                                }
                                                return null;
                                              },
                                            ),
                                            MathCaptcha(
                                                    controller:
                                                        captchaController),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      isLoading = true;
                                                    });

                                                    await submitContactForm(
                                                        context);

                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xffE2001A),
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 26,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadiusGeometry
                                                              .circular(30)),
                                                ),
                                                child: isLoading
                                                    ? const SizedBox(
                                                        height: 22,
                                                        width: 22,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : Text(
                                                        'Send',
                                                        style:
                                                            GoogleFonts.raleway(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
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
                            'assets/images/uploads/2020/04/IMG_0118.webp',
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
                                MathCaptcha(
                                        controller: captchaController),
                                Container(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Builder(
                                    builder: (BuildContext context) {
                                      return ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isLoading = true;
                                            });

                                            await submitContactForm(context);

                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        },
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
                                        child: isLoading
                                            ? const SizedBox(
                                                height: 22,
                                                width: 22,
                                                child:
                                                    CircularProgressIndicator(
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
                            'assets/images/uploads/2020/04/IMG_0118.webp',
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
              // ---------------------------
              // ⭐ CONTACT DETAILS SECTION
              // ---------------------------
              Center(
                child: Column(
                  children: [
                    Text(
                      "Indian Grill\nHotBreads Cakes & Curries",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "969 Bethlehem Pike\nMontgomeryville PA 18936",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // PHONE CLICKABLE
                    GestureDetector(
                      onTap: () async {
                        final Uri phoneUri =
                            Uri(scheme: 'tel', path: '2158554900');

                        await launchUrl(
                          phoneUri,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Text(
                        "Phone: 215-855-4900",
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // EMAIL CLICKABLE
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
                      child: Text(
                        "E-mail: contact@indian-grill.com",
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Website: ",
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            const url = 'https://www.indian-grill.com';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              final Uri websiteUri =
                                  Uri.parse("https://www.indian-grill.com");
                              await launchUrl(websiteUri,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Text(
                            "indian-grill.com",
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // ---------------------------
              // CONTACT FORM TITLE
              // ---------------------------
              Text(
                'Contact Us',
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  color: const Color(0xffE2001A),
                  fontWeight: FontWeight.w800,
                ),
              ),

              // ---------------------------
              // CONTACT FORM FIELDS
              // ---------------------------
              Form(
                key: _formKey,
                child: Column(
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        if (!regex.hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    LabeledTextField(
                      labelText: 'Telephone',
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length < 10) {
                          return 'Phone number must be at least 10 digits';
                        }
                        return null;
                      },
                    ),
                    LabeledTextField(
                      labelText: 'Comment',
                      controller: commentController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a comment';
                        }
                        return null;
                      },
                    ),
                    MathCaptcha(controller: captchaController),

                    // SUBMIT BUTTON CENTERED
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);

                              await submitContactForm(context);

                              setState(() => isLoading = false);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffE2001A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
  );
}
}
