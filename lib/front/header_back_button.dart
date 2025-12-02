import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderBackButton extends StatelessWidget {
  final String title;
  final VoidCallback? onBack; // optional custom back action

  const HeaderBackButton({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          // ---------------- Back Button ----------------
          GestureDetector(
            onTap: onBack ?? () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 20,
                color: Colors.black87,
              ),
            ),
          ),

          const Spacer(),

          // ---------------- Title ----------------
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const Spacer(),

          // Placeholder to balance row
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
