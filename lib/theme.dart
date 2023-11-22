import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toshokan/config/app_style.dart';

class CustomTheme {
  static ThemeData myStyle = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
    textTheme: GoogleFonts.latoTextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(AppColors.primaryColor),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        textStyle: const MaterialStatePropertyAll(
          TextStyle(fontSize: 15),
        ),
      ),
    ),
  );
}
