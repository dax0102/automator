import 'package:flutter/material.dart';

class ThemeComponents {
  const ThemeComponents._();

  static String codeFont = 'Cascadia Code';

  static double get spacing => 16;
  static EdgeInsets get defaultPadding => EdgeInsets.all(spacing);
  static InputBorder get inputBorder => const OutlineInputBorder();

  static get cellAlignment => TableCellVerticalAlignment.middle;
  static get textAlignment => TextAlign.center;
}

ThemeData get dark {
  final base = ThemeData(brightness: Brightness.dark, fontFamily: 'Rubik');

  const primary = Color(0xff4299E1);
  const onPrimary = Color(0xff000000);
  const surface = Color(0xff2D3748);
  const background = Color(0xff1A202C);
  const error = Color(0xffE53E3E);
  const onError = Color(0xffffffff);

  return base.copyWith(
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    colorScheme: base.colorScheme.copyWith(
      primary: primary,
      onPrimary: onPrimary,
      secondary: Colors.red,
      onSecondary: onPrimary,
      surface: surface,
      error: error,
      onError: onError,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        elevation: 0,
      ),
    ),
    appBarTheme: base.appBarTheme.copyWith(
      elevation: 0,
      backgroundColor: background,
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: Color.lerp(surface, Colors.white, 0.05),
      selectedColor: Color.lerp(primary, Colors.transparent, 0.05),
    ),
    dialogTheme: base.dialogTheme.copyWith(
      backgroundColor: surface,
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      behavior: SnackBarBehavior.floating,
    ),
    cardTheme: base.cardTheme.copyWith(
      color: surface,
    ),
  );
}
