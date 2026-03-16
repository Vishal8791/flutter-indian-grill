// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:indiangrill/front/career.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiangrill/front/datepicker/date_picker_field.dart';
import 'package:indiangrill/captcha/math_captcha.dart';
import 'package:indiangrill/services/api_config.dart';

// BanquetContactPage converted to StatefulWidget
class BanquetContactPage extends StatefulWidget {
  const BanquetContactPage({super.key});

  @override
  State<BanquetContactPage> createState() => _BanquetContactPageState();
}

class _BanquetContactPageState extends State<BanquetContactPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController guestController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();

  bool formSubmitted = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> submitbanquetForm(BuildContext context) async {
    final url = Uri.parse(
        '${ApiConfig.baseUrl}/wp-json/flutter/v1/banquetform');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'guests': guestController.text.trim(),
          'date': dateController.text.trim(),
          'time': timeController.text.trim(),
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': mobileController.text.trim(),
          'message': messageController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
      //  final data = jsonDecode(response.body);

        setState(() {
          formSubmitted = true;
          guestController.clear();
          dateController.clear();
          timeController.clear();
          nameController.clear();
          emailController.clear();
          mobileController.clear();
          messageController.clear();
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(data['message'] ?? 'Submitted successfully!')),
        // );
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
       if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting form.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          if (screenWidth > 1024) {
            return buildDesktopLayout();
          } else if (screenWidth > 600) {
            return buildTabletLayout();
          } else {
            return buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget buildDesktopLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 190, vertical: 50),
      child: Column(
        children: [
          const Text('Check Banquet Availability'),
          Container(
            alignment: Alignment.centerLeft,
            width: 400,
            child: buildFormContent(),
          )
        ],
      ),
    );
  }

  Widget buildTabletLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: Column(
        children: [
          const Text('Check Banquet Availability'),
          Container(
            alignment: Alignment.centerLeft,
            width: 600, // wider than mobile but smaller than desktop
            child: buildFormContent(),
          )
        ],
      ),
    );
  }

  Widget buildMobileLayout() {
    return SingleChildScrollView(
        child: Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Check Banquet Availability',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xffdd3333)),
          ),
          const SizedBox(height: 20),
          buildFormContent(fullWidth: true), // mobile-friendly version
        ],
      ),
    ));
  }

  /// Extracted form content so all layouts reuse the same logic
  Widget buildFormContent({bool fullWidth = false}) {
    return formSubmitted
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Thank you!',
                style: GoogleFonts.raleway(
                  fontSize: 20,
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
        : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledTextField(
                  labelText: 'Expected Number of Guests',
                  controller: guestController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter number of guests';
                    }

                    final guests = int.tryParse(value.trim());
                    if (guests == null || guests <= 0) {
                      return 'Please enter a valid number of guests';
                    }

                    if (guests > 1000) {
                      // optional limit
                      return 'Guest count seems too high';
                    }

                    return null;
                  },
                ),
                DatePickerField(
                  controller: dateController,
                  labelText: "Date",
                ),
                LabeledTextField(
                  labelText: 'Time',
                  controller: timeController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter time';
                    }

                    // Allow formats like "10:30 AM" or "22:00"
                    final timeRegex = RegExp(
                        r'^(0?[1-9]|1[0-2]):[0-5][0-9]\s?(AM|PM|am|pm)$|^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');

                    if (!timeRegex.hasMatch(value.trim())) {
                      return 'Enter time in HH:MM or HH:MM AM/PM format';
                    }

                    return null;
                  },
                ),
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
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    final emailRegex = RegExp(
                      r"^(?!\.)[A-Za-z0-9._%+-]+(?<!\.)@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$",
                    );

                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),
                LabeledTextField(
                  labelText: 'Phone Number',
                  controller: mobileController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }

                    // ✅ Supports 10 to 15 digits, optionally with +country code
                    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
                    if (!phoneRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid phone number (10–15 digits)';
                    }

                    return null;
                  },
                ),
                LabeledTextField(
                  labelText: 'Message',
                  controller: messageController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a message';
                    }

                    if (value.trim().length < 5) {
                      return 'Message must be at least 5 characters long';
                    }

                    // Prevent only special characters or numbers
                    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                      return 'Message must contain some letters';
                    }

                    return null;
                  },
                ),
                MathCaptcha(controller: captchaController),
                Container(
               //   width: fullWidth ? double.infinity : null,
                  padding: const EdgeInsets.only(top: 20),
                  child:Center(child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });

                          await submitbanquetForm(context);

                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xffe2001a),
                        textStyle: const TextStyle(fontSize: 18),
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
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
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2),
                              child: Text(
                                'Submit',
                                style: GoogleFonts.raleway(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )),
                ),
                ),
              ]
                  .expand((widget) => [widget, const SizedBox(height: 8)])
                  .toList(),
            ),
          );
  }
}
