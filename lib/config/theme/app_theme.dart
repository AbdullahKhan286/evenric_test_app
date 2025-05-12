import 'package:evenric_app/config/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define the default theme for the app
  static final ThemeData dark = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: whiteColor,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: primaryColor,
    ),

    /// =============== APP BAR THEME ================
    appBarTheme: AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: whiteColor,
      ),
      titleTextStyle: GoogleFonts.playfairDisplay(
        color: primaryColor,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
      ),
    ),

    /// =============== Bottom Nav Bar ================
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      selectedItemColor: whiteColor,
      unselectedItemColor: whiteColor,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: whiteColor,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: whiteColor,
      ),
      elevation: 0,
    ),

    // =============== Text Theme =====================
    textTheme: TextTheme(
      // Display styles
      displayLarge: GoogleFonts.poppins(
        fontSize: 32.sp,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),

      // Headline styles
      headlineLarge: GoogleFonts.poppins(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: textPrimaryColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: textPrimaryColor,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: textPrimaryColor,
      ),

      // Title styles
      titleLarge: GoogleFonts.poppins(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),

      // Body styles
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: textPrimaryColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: textPrimaryColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: textPrimaryColor,
      ),

      // Label styles
      labelLarge: GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
    ),

    // =============== Card Theme =====================
    cardTheme: CardTheme(
      color: primaryColor,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
    ),

    // =============== TextField Theme =====================
  );
}
