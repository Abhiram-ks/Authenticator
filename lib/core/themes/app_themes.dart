
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppPalette.blueColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppPalette.whiteColor,
    fontFamily: GoogleFonts.poppins().fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
     backgroundColor: AppPalette.whiteColor,
      selectedItemColor: AppPalette.blackColor,
      unselectedItemColor: AppPalette.greyColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.blueColor,
     iconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(color: AppPalette.blackColor),
      bodyMedium: GoogleFonts.poppins(color: AppPalette.blackColor),
      bodySmall: GoogleFonts.poppins(color: AppPalette.blackColor),
    )
  );
}