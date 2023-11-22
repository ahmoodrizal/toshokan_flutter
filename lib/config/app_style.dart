import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semibold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

class AppColors {
  static Color primaryColor = const Color(0xff232D3F);
  static Color secondaryColor = const Color(0xffB9B4C7);
}

class AppFonts {
  static TextStyle darkTextStyle = GoogleFonts.poppins(color: AppColors.primaryColor);
  static TextStyle subTextStyle = GoogleFonts.poppins(color: AppColors.secondaryColor);

  static FontWeight light = FontWeight.w300;
  static FontWeight regular = FontWeight.w400;
  static FontWeight medium = FontWeight.w500;
  static FontWeight semibold = FontWeight.w600;
  static FontWeight bold = FontWeight.w700;
}
