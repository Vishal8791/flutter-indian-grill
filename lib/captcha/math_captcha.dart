// math_captcha.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MathCaptcha extends StatefulWidget {
  final TextEditingController controller;
  const MathCaptcha({super.key, required this.controller});

  @override
  State<MathCaptcha> createState() => _MathCaptchaState();
}

class _MathCaptchaState extends State<MathCaptcha> {
  late int a;
  late int b;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    Random random = Random();
    a = random.nextInt(10);
    b = random.nextInt(10);
    widget.controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Captcha: What is $a + $b?',
              style: GoogleFonts.raleway(
                fontSize: 13,
                color: const Color(0xff666666),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: _generateCaptcha,
              icon: const Icon(Icons.refresh, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          validator: (value) {
            int? answer = int.tryParse(value ?? '');
            if (value == null || value.isEmpty) {
              return 'Please solve the captcha';
            }
            if (answer != (a + b)) {
              _generateCaptcha();
              return 'Incorrect answer, try again';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide:
                  const BorderSide(color: Color(0xff666666), width: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}
