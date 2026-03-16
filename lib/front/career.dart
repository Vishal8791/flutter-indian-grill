import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:indiangrill/style/style.dart'; // Import AppColors
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:indiangrill/captcha/math_captcha.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:indiangrill/services/api_config.dart';

class LabeledTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final IconData? icon;

  const LabeledTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.validator,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: GoogleFonts.raleway(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            maxLines: maxLines,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
              prefixIcon: icon != null
                  ? Icon(icon, color: Colors.red.shade400)
                  : null,

              filled: true,
              fillColor: Colors.white,

              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),

              border: OutlineInputBorder(
                // borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black26),
              ),
              enabledBorder: OutlineInputBorder(
                // borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black26),
              ),
              focusedBorder: OutlineInputBorder(
                // borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red.shade400, width: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// Career widget now changed to StatefulWidget to manage controllers
class Career extends StatefulWidget {
  const Career({super.key});

  @override
  CareerState createState() => CareerState();
}

class CareerState extends State<Career> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();

  String? _selectedFileName;
  PlatformFile? _selectedFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool formSubmitted = false;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    designationController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'webp',
          'webp',
          'webp',
          'gif'
        ], // allow documents + images
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        setState(() {
          _selectedFile = file;
          _selectedFileName = file.name;
        });

        if (kIsWeb) {
          if (file.bytes != null) {
            // print("WEB: Received file bytes = ${file.bytes!.length}");
          } else {
            // print("WEB: No bytes received!");
          }
        }

        // --- Mobile / Desktop Handling ---
        else {
          if (file.path != null) {
            // print("MOBILE/DESKTOP: File path = ${file.path}");
          } else {
            // print("MOBILE/DESKTOP: No file path available");
          }
        }
      } else {
        // User canceled
        setState(() {
          _selectedFile = null;
          _selectedFileName = null;
        });
      }
    } catch (e) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    final uri = Uri.parse(
        "${ApiConfig.baseUrl}/wp-json/flutter/v1/careerForm");

    var request = http.MultipartRequest("POST", uri);

    // Add text fields
    request.fields['name'] = nameController.text.trim();
    request.fields['email'] = emailController.text.trim();
    request.fields['mobile'] = mobileController.text.trim();
    request.fields['designation'] = designationController.text.trim();
    request.fields['about'] = aboutController.text.trim();

    // Attach file as bytes (important for web)
    if (_selectedFile != null && _selectedFile!.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'cv', // field name in PHP
          _selectedFile!.bytes!,
          filename: _selectedFile!.name,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Form submitted successfully!")),
      // );
      _clearForm();
    } else {
      if(!mounted) return ;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${response.statusCode}")),
      );
    }
  }

  void _clearForm() {
    formSubmitted = true;
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    designationController.clear();
    aboutController.clear();
    setState(() {
      _selectedFile = null;
      _selectedFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        // // print("Current Width: $screenWidth");

        if (kIsWeb) {
          // For web: apply responsive layout based on screen size
          if (screenWidth > 1024) {
            // // print("Web/Desktop layout is being used");
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
    );
  }

  Widget buildDesktopLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(320, 50, 190, 100),
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Fill the form below to join Indian Grill Type a message',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      color: const Color(0xff666666),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  width: 550,
                  padding: const EdgeInsets.only(left: 30),
                  child: Form(
                    key: _formKey, // Add Form key
                    child: Column(
                      children: [
                        LabeledTextField(
                          labelText: 'Your Name (required)',
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }

                            // Allow only letters, spaces, apostrophes, and hyphens
                            final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
                            if (!nameRegex.hasMatch(value.trim())) {
                              return 'Name should contain only letters';
                            }

                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }

                            return null;
                          },
                        ),

                        LabeledTextField(
                          labelText: 'Your Email (required)',
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }

                            // RFC-safe email validation
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
                          labelText: 'Your Mobile Number (required)',
                          controller: mobileController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your mobile number';
                            }

                            // Allows +country code and 10–15 digits
                            final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
                            if (!phoneRegex.hasMatch(value.trim())) {
                              return 'Please enter a valid mobile number (10–15 digits)';
                            }

                            return null;
                          },
                        ),

                        LabeledTextField(
                          labelText: 'Designation',
                          controller: designationController,
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              // Optional but must be alphabetic if filled
                              final designationRegex =
                                  RegExp(r"^[a-zA-Z\s'-]+$");
                              if (!designationRegex.hasMatch(value.trim())) {
                                return 'Designation should contain only letters';
                              }
                            }
                            return null; // Optional field
                          },
                          // No validation (optional field)
                        ),

                        LabeledTextField(
                          labelText:
                              'Tell Us Something Interesting About Yourself',
                          controller: aboutController,
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              if (value.trim().length < 10) {
                                return 'Please write at least 10 characters';
                              }
                              // Should contain at least one letter
                              if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                                return 'Message must include some letters';
                              }
                            }
                            return null; // Optional field
                          },
                          // No validation (optional field)
                        ),

                        const SizedBox(height: 20),

                        // File Picker Section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Please Share Your CV',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff666666),
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: _pickFile,
                                      child: const Text('Choose File'),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _selectedFileName != null
                                            ? _selectedFileName!
                                            : 'No file chosen',
                                        style: GoogleFonts.raleway(
                                            fontSize: 13,
                                            color: const Color(0xff666666)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                         MathCaptcha(controller: captchaController),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            // onPressed: () {
                            //   if (_formKey.currentState!.validate()) {
                            //     if (_selectedFileName == null) {
                            //       ScaffoldMessenger.of(context).showSnackBar(
                            //         const SnackBar(
                            //           content: Text('Please upload your CV.'),
                            //         ),
                            //       );
                            //       return;
                            //     }
                            //     _submitForm();
                            //   }
                            // },
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedFileName == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please upload your CV.'),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                await _submitForm();

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
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildTabletLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(80, 50, 0, 50),
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Fill the form below to join Indian Grill Type a message',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      color: const Color(0xff666666),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  padding: const EdgeInsets.only(left: 30),
                  child: Form(
                    key: _formKey, // Add the form key here
                    child: Column(
                      children: [
                        LabeledTextField(
                          labelText: 'Your Name (required)',
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }

                            // Allow only letters, spaces, apostrophes, and hyphens
                            final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
                            if (!nameRegex.hasMatch(value.trim())) {
                              return 'Name should contain only letters';
                            }

                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }

                            return null;
                          },
                        ),

                        LabeledTextField(
                          labelText: 'Your Email (required)',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }

                            // RFC-safe email validation
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
                          labelText: 'Your Mobile Number (required)',
                          controller: mobileController,
                          keyboardType: const TextInputType.numberWithOptions(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your mobile number';
                            }

                            // Allows +country code and 10–15 digits
                            final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
                            if (!phoneRegex.hasMatch(value.trim())) {
                              return 'Please enter a valid mobile number (10–15 digits)';
                            }

                            return null;
                          },
                        ),

                        LabeledTextField(
                          labelText: 'Designation',
                          controller: designationController,
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              // Optional but must be alphabetic if filled
                              final designationRegex =
                                  RegExp(r"^[a-zA-Z\s'-]+$");
                              if (!designationRegex.hasMatch(value.trim())) {
                                return 'Designation should contain only letters';
                              }
                            }
                            return null; // Optional field
                          },
                        ),

                        LabeledTextField(
                          labelText:
                              'Tell Us Something Interesting About Yourself',
                          controller: aboutController,
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              if (value.trim().length < 10) {
                                return 'Please write at least 10 characters';
                              }
                              // Should contain at least one letter
                              if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                                return 'Message must include some letters';
                              }
                            }
                            return null; // Optional field
                          },
                        ),

                        const SizedBox(height: 20),

                        // File Picker Section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Please Share Your CV',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff666666),
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: _pickFile,
                                      child: const Text('Choose File'),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _selectedFileName != null
                                            ? _selectedFileName!
                                            : 'No file chosen',
                                        style: GoogleFonts.raleway(
                                            fontSize: 13,
                                            color: const Color(0xff666666)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        MathCaptcha(controller: captchaController),

                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            // onPressed: () {
                            //   if (_formKey.currentState!.validate()) {
                            //     if (_selectedFileName == null) {
                            //       ScaffoldMessenger.of(context).showSnackBar(
                            //         const SnackBar(
                            //           content: Text('Please upload your CV.'),
                            //         ),
                            //       );
                            //       return;
                            //     }

                            //     _submitForm();
                            //   }
                            // },
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedFileName == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please upload your CV.'),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                await _submitForm();

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
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildMobileLayout() {
    return SingleChildScrollView(
        child: Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
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
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Fill the form below to join Indian Grill Type a message',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      color: const Color(0xff666666),
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Form(
                    key: _formKey, // Add the form key
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LabeledTextField(
                          labelText: 'Your Name (required)',
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }

                            // Allow only letters, spaces, apostrophes, and hyphens
                            final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
                            if (!nameRegex.hasMatch(value.trim())) {
                              return 'Name should contain only letters';
                            }

                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }

                            return null;
                          },
                        ),

                        LabeledTextField(
                          labelText: 'Your Email (required)',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }

                            // RFC-safe email validation
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
                          labelText: 'Your Mobile Number (required)',
                          controller: mobileController,
                          keyboardType: const TextInputType.numberWithOptions(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your mobile number';
                            }

                            // Allows +country code and 10–15 digits
                            final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
                            if (!phoneRegex.hasMatch(value.trim())) {
                              return 'Please enter a valid mobile number (10–15 digits)';
                            }

                            return null;
                          },
                        ),

                        LabeledTextField(
                          labelText: 'Designation',
                          controller: designationController,
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              // Optional but must be alphabetic if filled
                              final designationRegex =
                                  RegExp(r"^[a-zA-Z\s'-]+$");
                              if (!designationRegex.hasMatch(value.trim())) {
                                return 'Designation should contain only letters';
                              }
                            }
                            return null; // Optional field
                          },
                        ),

                        LabeledTextField(
                          labelText:
                              'Tell Us Something Interesting About Yourself',
                          controller: aboutController,
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              if (value.trim().length < 10) {
                                return 'Please write at least 10 characters';
                              }
                              // Should contain at least one letter
                              if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                                return 'Message must include some letters';
                              }
                            }
                            return null; // Optional field
                          },
                        ),

                        const SizedBox(height: 20),

                        // File Picker Section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Please Share Your CV',
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: const Color(0xff666666),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff666666),
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: _pickFile,
                                      child: const Text('Choose File'),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _selectedFileName != null
                                            ? _selectedFileName!
                                            : 'No file chosen',
                                        style: GoogleFonts.raleway(
                                            fontSize: 13,
                                            color: const Color(0xff666666)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        MathCaptcha(controller: captchaController),

                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            // onPressed: () {
                            //   if (_formKey.currentState!.validate()) {
                            //     if (_selectedFileName == null) {
                            //       ScaffoldMessenger.of(context).showSnackBar(
                            //         const SnackBar(
                            //           content: Text('Please upload your CV.'),
                            //         ),
                            //       );
                            //       return;
                            //     }

                            //     _submitForm();
                            //   }
                            // },
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedFileName == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please upload your CV.'),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                await _submitForm();

                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                             style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffE2001A),
                                    foregroundColor: Colors.white,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                                    shape:
                                        RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30)),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
    ));
  }
}

void main() {
  runApp(const MaterialApp(
    home: Career(),
  ));
}
