import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiangrill/captcha/math_captcha.dart';
import 'package:indiangrill/front/career.dart'; // For LabeledTextField
import 'package:indiangrill/front/datepicker/date_picker_field.dart';

class OrderCakePage extends StatefulWidget {
  final Map product;
  const OrderCakePage({super.key, required this.product});

  @override
  _OrderCakePageState createState() => _OrderCakePageState();
}

class _OrderCakePageState extends State<OrderCakePage> {
  // ✅ Input Controllers
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cakeMessageController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController cakeSizeController = TextEditingController();
  final TextEditingController freshCreamController = TextEditingController();
  final TextEditingController decorationController = TextEditingController();
  final TextEditingController cakeforController = TextEditingController();
  final TextEditingController toyoptionController = TextEditingController();
  final TextEditingController ordertypeController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();

  String specialCakeType = "None"; // default
  String needCandles = "No";
  String cakeFor = "Boy"; // default value
  String toysOption = "Yes"; // default value
  String ordertype = "PickUp from store";
  final TextEditingController specialCakeController =
      TextEditingController(text: "None");

  final List<String> cakeSize = <String>[
    '1/8 Sheet 2lbs (10-12) Price : 30\$',
    '1/4 Sheet 4lbs (20-24) Price : 57\$',
    '3/8 Sheet 6lbs (30-34) Price : 81\$',
    'Half Sheet 8lbs (40-44) Price : 105\$',
    '5/8 Sheet 10lbs (50-55) Price : 127\$',
    '3/4 Sheet 12lbs (60-66) Price : 148\$',
    '7/8 Sheet 14lbs (70-78) Price : 165\$',
    'Full Sheet 16lbs (80-90) Price : 180\$',
  ];

  final List<String> freshcream = <String>[
    'Black Forest',
    'Strawberry',
    'Pineapple',
    'Choc-Mousse',
    'Tiramisu',
    'Mango',
    'Mixed Fruit',
    'Butter Scotch',
    '--Other--'
  ];

  String? selectedcakeSize;
  String? selectedfreshcream;
  @override
  void initState() {
    super.initState();
    selectedcakeSize = cakeSize.first; // ✅ Default first option
    cakeSizeController.text = selectedcakeSize!; // ✅ Sets controller too
    selectedfreshcream = freshcream.first;
    freshCreamController.text = selectedfreshcream!;
  }

  void dispose() {
    dateController.dispose();
    cakeMessageController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    referenceController.dispose();
    timeController.dispose();
    cakeSizeController.dispose();
    specialCakeController.dispose();
    freshCreamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1024) {
      return _wrapContent(buildDesktopLayout(context));
    } else if (screenWidth >= 600) {
      return _wrapContent(buildTabletLayout(context));
    } else {
      return _wrapContent(buildMobileLayout(context));
    }
  }

  // ✅ Wrapper (Ensures correct layout inside MainLayout)
  Widget _wrapContent(Widget child) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1400),
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: child,
        ),
      ),
    );
  }

  // ✅ Desktop Layout
  Widget buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 190),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: buildFormSection(context)),
          const SizedBox(width: 60),
          Expanded(child: buildProductSection()),
        ],
      ),
    );
  }

  // ✅ Tablet Layout
  Widget buildTabletLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Order Cake",
            style:
                GoogleFonts.raleway(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: buildFormSection(context)),
            const SizedBox(width: 20),
            Expanded(child: buildProductSection()),
          ],
        )
      ],
    );
  }

  // ✅ Mobile Layout
  Widget buildMobileLayout(BuildContext context) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20),   // ✅ FIXED
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFormSection(context),
          const SizedBox(height: 20),
          buildProductSection(),
        ],
      ),
    ),
  );
}


  // ✅ Form Section
  Widget buildFormSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Cake name: ",
                style: GoogleFonts.raleway(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[700])),
            Text(widget.product['name'] ?? "",
                style: GoogleFonts.raleway(
                    fontSize: 16, color: const Color(0xffe2001a))),
          ],
        ),
        Text('Please fill up the form below to send a request to order a cake.',
            style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey[700])),
        const SizedBox(height: 10),
        DatePickerField(controller: dateController, labelText: "Date"),
        LabeledTextField(labelText: "Time ", controller: timeController),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Special Cakes:",
                  style: GoogleFonts.raleway(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              Wrap(
                spacing: 10,
                children: [
                  buildRadioOption(
                    value: "Sugar-Free",
                    groupValue: specialCakeType,
                    onChanged: (val) {
                      setState(() {
                        specialCakeType = val!;
                        specialCakeController.text = val!;
                      });
                    },
                  ),
                  buildRadioOption(
                    value: "Vanilla",
                    groupValue: specialCakeType,
                    onChanged: (val) {
                      setState(() {
                        specialCakeType = val!;
                        specialCakeController.text = val!;
                      });
                    },
                  ),
                  buildRadioOption(
                    value: "Chocolate",
                    groupValue: specialCakeType,
                    onChanged: (val) {
                      setState(() {
                        specialCakeType = val!;
                        specialCakeController.text = val!;
                      });
                    },
                  ),
                  buildRadioOption(
                    value: "None",
                    groupValue: specialCakeType,
                    onChanged: (val) {
                      setState(() {
                        specialCakeType = val!;
                        specialCakeController.text = val!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'Cake Size : ',
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
              isExpanded: true, // Make dropdown full width of parent
              buttonDecoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(0),
              ),
              // buttonPadding: const EdgeInsets.symmetric(
              //     horizontal: 12, vertical: 12),
              value: selectedcakeSize,
              onChanged: (String? newValue) {
                setState(() {
                  selectedcakeSize = newValue;
                  cakeSizeController.text = newValue ?? cakeSize.first;
                });
              },
              items: cakeSize
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
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'Fresh Cream : ',
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
              isExpanded: true, // Make dropdown full width of parent
              buttonDecoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(0),
              ),
              // buttonPadding: const EdgeInsets.symmetric(
              //     horizontal: 12, vertical: 12),
              value: selectedfreshcream,
              onChanged: (String? newValue) {
                setState(() {
                  selectedfreshcream = newValue;
                  freshCreamController.text = newValue ?? freshcream.first;
                });
              },
              items: freshcream
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
        const SizedBox(height: 10),
        LabeledTextField(
            labelText: "Decorations/Toys ", controller: decorationController),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Candles (PickUp from store) :",
                  style: GoogleFonts.raleway(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              Wrap(
                spacing: 10,
                children: [
                  buildRadioOption(
                    value: "Yes",
                    groupValue: needCandles,
                    onChanged: (val) {
                      setState(() {
                        needCandles = val!;
                      });
                    },
                  ),
                  buildRadioOption(
                    value: "No",
                    groupValue: needCandles,
                    onChanged: (val) {
                      setState(() {
                        needCandles = val!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        LabeledTextField(
            labelText: "Writing On Cake ", controller: cakeMessageController),
        // Cake For :
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "Cake For :",
            style:
                GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 10,
          children: [
            buildRadioOption(
              value: "Boy",
              groupValue: cakeFor,
              onChanged: (val) {
                setState(() {
                  cakeFor = val!;
                });
              },
            ),
            buildRadioOption(
              value: "Girl",
              groupValue: cakeFor,
              onChanged: (val) {
                setState(() {
                  cakeFor = val!;
                });
              },
            ),
          ],
        ),

// Toys :
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Toys (For selection call store at 215-855-4900) :",
            style:
                GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 10,
          children: [
            buildRadioOption(
              value: "Yes",
              groupValue: toysOption,
              onChanged: (val) {
                setState(() {
                  toysOption = val!;
                });
              },
            ),
            buildRadioOption(
              value: "No",
              groupValue: toysOption,
              onChanged: (val) {
                setState(() {
                  toysOption = val!;
                });
              },
            ),
          ],
        ),

          LabeledTextField(
            labelText: "Special Request ", controller: cakeMessageController),
        
        const SizedBox(height: 20),
        Text("Customer Information",
            style:
                GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        LabeledTextField(labelText: "Name", controller: nameController),
        const SizedBox(height: 10),
        LabeledTextField(
            labelText: "Contact Number", controller: phoneController),
        const SizedBox(height: 10),
        LabeledTextField(labelText: "Email", controller: emailController),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Order Type : ",
            style: 
                GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 10,
          children: [
            buildRadioOption(
              value: "PickUp from store",
              groupValue: ordertype,
              onChanged: (val) {
                setState(() {
                  ordertype = val!;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        LabeledTextField(labelText: "How they heard about us :", controller: referenceController),

        const SizedBox(height: 20),
        MathCaptcha(controller: captchaController),

        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Order placed successfully!")),
            );
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
                                child: const Text('Send'),
        ),
      ],
    );
  }

  Widget buildRadioOption({
    required String value,
    required String groupValue,
    required void Function(String?) onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged, // dynamically updates the state
        ),
        Text(
          value,
          style: GoogleFonts.raleway(fontSize: 12),
        ),
      ],
    );
  }

  // ✅ Product Section
  Widget buildProductSection() {
    final image = widget.product['image'] != null &&
            widget.product['image'].toString().isNotEmpty
        ? 'https://images.weserv.nl/?url=${Uri.encodeComponent(widget.product['image'])}'
        : "assets/cake.png";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSpecialNotes(),
        const SizedBox(height: 20),
        Image.network(
          image,
          height: 200,
          width: double.infinity,
          fit: BoxFit.contain, // Prevents Image Cropping
        ),
      ],
    );
  }

  // ✅ Dropdown Field Builder
  Widget buildDropdownField(String label, List<String> items) {
    return DropdownButtonFormField(
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (value) {},
    );
  }
}

// ✅ Special Notes Component
Widget buildSpecialNotes() {
  final notes = [
    "All cake orders require a prepayment.",
    "Sugar-free or custom cakes may cost extra.",
    "Online cake orders are not confirmed unless manually acknowledged by Indian Grill location.",
    "All designer cakes, with or without toy, will be \$10 extra.",
    "Special toys require 14-days notice to order the toy – By Thursday.",
    "Toys can only be added to cakes with minimum size of 1/4 sheet.",
    "Two flavors are allowed only on cakes larger than 1/2 sheet (8 lbs).",
    "Discount available for full party order.",
    "No refunds, store credit will be given if deemed necessary."
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Special Notes",
          style: GoogleFonts.raleway(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800])),
      const SizedBox(height: 10),
      ...List.generate(
          notes.length,
          (i) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text("${i + 1}. ${notes[i]}",
                    style: GoogleFonts.raleway(
                        fontSize: 12, height: 1.5, color: Colors.grey[700])),
              )),
    ],
  );
}
