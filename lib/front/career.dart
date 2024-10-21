import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

// Custom widget for Label with TextField
class LabeledTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  LabeledTextField({
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(   
      padding: EdgeInsets.only(top: 20), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: GoogleFonts.raleway(
              fontSize: 13,
              color: Color(0xff666666),
            ),
          ),
          // Space between label and text field
          TextField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide(
                  color: Color(0xff666666),
                  width: 0.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0), // No rounded corners
                borderSide: BorderSide(
                  color: Colors.grey, // Border color when text field is not focused
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
  @override
  _CareerState createState() => _CareerState();
}

class _CareerState extends State<Career> {
  // Controllers to manage text input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  String? _selectedFileName;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    designationController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  // Function to pick a file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
      });
    } else {
      // User canceled the picker
      setState(() {
        _selectedFileName = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(320, 50, 190, 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Fill the form below to join Indian Grill',
              style: GoogleFonts.lato(
                fontSize: 22,
                color: Color(0xff666666),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            width: 550,
            padding: EdgeInsets.only(left: 30),
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
                SizedBox(height: 20),
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
                          color: Color(0xff666666),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(

                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff666666),
                          width: 0.5,
                        )
                      ),
                      child:Row(
                        children: [
                          TextButton(
                            onPressed: _pickFile,
                            child: Text('Choose File'),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _selectedFileName != null
                                  ? _selectedFileName!
                                  : 'No file chosen',
                              style: GoogleFonts.raleway(
                                fontSize: 13,
                                color: Color(0xff666666)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      ),
                      Container(
                      padding: EdgeInsets.only(top:20),
                      child:ElevatedButton(
            onPressed: () {
              // Add your onPressed code here!
              print('Send button pressed!');
            },
            child: Text('Send'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Color(0xffe2001a), // Text color
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: TextStyle(fontSize: 20),
            ).copyWith(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4), // No border radius
                ),
              ),
            ),
          )
                  ),
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
  runApp(MaterialApp(
    home: Career(),
  ));
}
