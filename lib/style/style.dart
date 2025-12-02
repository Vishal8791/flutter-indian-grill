import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xffe2001a); // your preferred color
  static const Color background = Color(0xFFF7F7F7);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF777777);
  static const Color sideMenuBg = Color(0xFFFFFFFF);
  static const Color sideMenuText = Color(0xFF1A1A1A);
  static const Color sideMenuSubText = Color(0xFF4B4B4B);
  static const Color sideMenuIcon = Color(0xFF2A2A2A);
  static const Color sideMenuSubIcon = Color(0xFF5A5A5A);
  static const Color sideMenuArrow = Color(0xFFB5B5B5);
  static const Color sideMenuHover = Color(0xFFF2F2F2);
  static const Color appBg = Colors.white;

}

// <-- Make sure this exists in your project

class AppTextStyle {
  // -------------------------
  // POPPINS TEXT STYLES
  // -------------------------

  static TextStyle poppinsH1 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static TextStyle poppinsH2 = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle poppinsSubtitle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle poppinsBody = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle poppinsSmall = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle poppinsButton = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  // -------------------------
  // INTER TEXT STYLES
  // -------------------------

  static TextStyle interH1 = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static TextStyle interH2 = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle interSubtitle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle interBody = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle interSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle interButton = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle drawerexpandableHeading = GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w500
  );
  /// Drawer Item — Poppins Version
  static TextStyle poppinsDrawer(bool isActive) => GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
        color: isActive ? AppColors.primary : AppColors.sideMenuText,
      );
  
   static TextStyle poppinssubmenuDrawer(bool isActive) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
        color: isActive ? AppColors.primary : AppColors.sideMenuText,
      );

  /// Drawer Item — Inter Version
  static TextStyle interDrawer(bool isActive) => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
        color: isActive ? AppColors.primary : AppColors.sideMenuText,
      );
}
