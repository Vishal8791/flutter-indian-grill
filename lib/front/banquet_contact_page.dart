import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:indiangrill/front/career.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiangrill/front/datepicker/date_picker_field.dart';

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

  bool formSubmitted = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> submitbanquetForm(BuildContext context) async {
    final url = Uri.parse(
        'https://www.indian-grill.com/wp-json/flutter/v1/banquetform');

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
        final data = jsonDecode(response.body);

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
    return Container(
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
    );
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
                  labelText: 'Expected No. of guest:',
                  controller: guestController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of guests';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                DatePickerField(
                  controller: dateController,
                  labelText: "Date",
                ),
                LabeledTextField(
                  labelText: 'Time:',
                  controller: timeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter time';
                    }
                    return null;
                  },
                ),
                LabeledTextField(
                  labelText: 'Name:',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                LabeledTextField(
                  labelText: 'Email Address:',
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                LabeledTextField(
                  labelText: 'Phone Number:',
                  controller: mobileController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                LabeledTextField(
                  labelText: 'Message:',
                  controller: messageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a message';
                    }
                    return null;
                  },
                ),
                Container(
                  width: fullWidth ? double.infinity : null,
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        submitbanquetForm(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xffe2001a),
                      textStyle: const TextStyle(fontSize: 18),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      'Send',
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
