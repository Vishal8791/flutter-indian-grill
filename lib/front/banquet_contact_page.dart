import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:indiangrill/front/career.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      LabeledTextField(
                          labelText: 'Expected No. of guest:',
                          controller: guestController),
                      LabeledTextField(
                          labelText: 'Date:', controller: dateController),
                      LabeledTextField(
                          labelText: 'Time:', controller: timeController),
                      LabeledTextField(
                          labelText: 'Name:', controller: nameController),
                      LabeledTextField(
                          labelText: 'Email Address:',
                          controller: emailController),
                      LabeledTextField(
                          labelText: 'Phone Number:',
                          controller: mobileController),
                      LabeledTextField(
                          labelText: 'Message:', controller: messageController),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () => submitbanquetForm(context),
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
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  Widget buildMobileLayout() {
    return buildDesktopLayout();
  }

  Widget buildTabletLayout() {
    return buildDesktopLayout();
  }
}
