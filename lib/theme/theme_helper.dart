// ignore_for_file: duplicate_ignore

import 'dart:ui';
import 'package:flutter/material.dart';

String _appTheme = "lightCode";
LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class ThemeHelper {
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: appTheme.background,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.indigo500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: appTheme.black900.withOpacity(0.25),
          elevation: 4,
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 40,
        space: 40,
        color: colorScheme.primary,
      ),
    );
  }

  LightCodeColors themeColor() => _getThemeColors();

  ThemeData themeData() => _getThemeData();
}

/// Theme classs
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        displayMedium: TextStyle(
          color: appTheme.background,
          fontSize: 48,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w800,
        ),
        displaySmall: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 36,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w800,
        ),
        headlineLarge: TextStyle(
          color: appTheme.background,
          fontSize: 32,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w800,
        ),
        headlineSmall: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 24,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        labelLarge: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 20,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w800,
        ),
        titleSmall: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 15,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w800,
        ),
      );
}

class ColorSchemes {
  static const lightCodeColorScheme = ColorScheme.light(
    primary: const Color(0XFF13334C),
    primaryContainer: Color(0XFF949494),
    secondary: Color(0XFF195482),
    onPrimary: Color(0XFFFFFFFF),
  );
}

class LightCodeColors {
  // Black
  Color get black900 => const Color(0XFF000000);
// BlueGray
  Color get blueGray400 => const Color(0XFF888888);
// Gray
  Color get gray50 => const Color(0XFFF8F8F8);
  Color get gray700 => const Color(0XFF675E5E);
// Green
  Color get green700 => const Color(0XFF2BB308);
// Indigo
  Color get indigo500 => const Color(0XFF3270A2);
// LightBlue
  Color get lightBlueA700 => const Color(0XFF009BF3);
// background white
  Color get background => Color.fromARGB(255, 252, 252, 249);
// Red
  Color get redA700 => const Color(0XFFFF0C0C);
  Color get redA70001 => const Color(0XFFFF0000);
// Yellow
  Color get yellowA200 => const Color(0XFFF9FF00);
}
