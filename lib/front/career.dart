import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

// Custom widget for Label with TextField
class LabeledTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const LabeledTextField({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: GoogleFonts.raleway(
              fontSize: 13,
              color: const Color(0xff666666),
            ),
          ),
          // Space between label and text field
          TextField(
            controller: controller,
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
                borderRadius: BorderRadius.circular(0), // No rounded corners
                borderSide: const BorderSide(
                  color: Colors
                      .grey, // Border color when text field is not focused
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0), // No rounded corners
                borderSide: const BorderSide(
                  color: Colors.grey, // Border color when text field is focused
                  width: 0.5,
                ),
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
  _CareerState createState() => _CareerState();
}

class _CareerState extends State<Career> {
final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  String? _selectedFileName;
  PlatformFile? _selectedFile;

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
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null && result.files.single.bytes != null) {
    setState(() {
      _selectedFile = result.files.single;
      _selectedFileName = result.files.single.name;
    });
  } else {
    setState(() {
      _selectedFile = null;
      _selectedFileName = null;
    });
  }
}

Future<void> _submitForm() async {
  final uri = Uri.parse("https://www.indian-grill.com/wp-json/flutter/v1/careerForm");

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Form submitted successfully!")),
    );
    _clearForm();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed: ${response.statusCode}")),
    );
  }
}

  void _clearForm() {
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
    return Container(child: LayoutBuilder(
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
      padding: const EdgeInsets.fromLTRB(320, 50, 190, 100),
      child: Column(
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
            child: Column(
              children: [
                LabeledTextField(
                  labelText: 'Your Name (required)',
                  controller: nameController,
                ),
                LabeledTextField(
                  labelText: 'Your Email (required)',
                  controller: emailController,
                ),
                LabeledTextField(
                  labelText: 'Your Mobile Number (required)',
                  controller: mobileController,
                ),
                LabeledTextField(
                  labelText: 'Designation',
                  controller: designationController,
                ),
                LabeledTextField(
                  labelText: 'Tell Us Something Interesting About Yourself',
                  controller: aboutController,
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
                        )),
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
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed:  _submitForm,
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
              ],
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
      child: Column(
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
            child: Column(
              children: [
                LabeledTextField(
                  labelText: 'Your Name (required)',
                  controller: nameController,
                ),
                LabeledTextField(
                  labelText: 'Your Email (required)',
                  controller: emailController,
                ),
                LabeledTextField(
                  labelText: 'Your Mobile Number (required)',
                  controller: mobileController,
                ),
                LabeledTextField(
                  labelText: 'Designation',
                  controller: designationController,
                ),
                LabeledTextField(
                  labelText: 'Tell Us Something Interesting About Yourself',
                  controller: aboutController,
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
                        )),
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
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: _submitForm,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMobileLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
      child: Column(
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
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LabeledTextField(
                  labelText: 'Your Name (required)',
                  controller: nameController,
                ),
                LabeledTextField(
                  labelText: 'Your Email (required)',
                  controller: emailController,
                ),
                LabeledTextField(
                  labelText: 'Your Mobile Number (required)',
                  controller: mobileController,
                ),
                LabeledTextField(
                  labelText: 'Designation',
                  controller: designationController,
                ),
                LabeledTextField(
                  labelText: 'Tell Us Something Interesting About Yourself',
                  controller: aboutController,
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
                        )),
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
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: _submitForm,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Career(),
  ));
}
