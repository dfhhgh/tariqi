import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tariqi/core/them_light/App_color_light.dart';

class LightTheme {
  static ThemeData theme = ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(TextStyle(fontFamily: "Almarai")),
        foregroundColor: WidgetStatePropertyAll(AppColorsLight.textPrimary),
      ),
    ),
    disabledColor: AppColorsLight.secondary.withOpacity(0.5),
    iconTheme: IconThemeData(color: AppColorsLight.accent),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    focusColor: AppColorsLight.accent,
    inputDecorationTheme: InputDecorationThemeData(
      focusColor: AppColorsLight.accent,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColorsLight.accent),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 15.sp),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColorsLight.accent),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      floatingLabelStyle: TextStyle(color: AppColorsLight.accent),
    ),
    indicatorColor: AppColorsLight.accent,
    brightness: ThemeData.light().brightness,
    fontFamily: "Inter",
    scaffoldBackgroundColor: AppColorsLight.background,
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(AppColorsLight.accent),
      fillColor: WidgetStatePropertyAll(AppColorsLight.background),
      side: MaterialStateBorderSide.resolveWith((states) {
        return BorderSide(color: AppColorsLight.accent, width: 2);
      }),
    ),
  );
}
