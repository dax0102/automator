import 'package:flutter/material.dart';

ThemeData get dark {
  final base = ThemeData(brightness: Brightness.dark, fontFamily: null);

  const primary = Color(0xff4FD1C5);
  const onPrimary = Color(0xff000000);
  const surface = Color(0xff2D3748);
  const background = Color(0xff1A202C);
  const error = Color(0xffE53E3E);
  const onError = Color(0xffffffff);

  return base.copyWith(
    scaffoldBackgroundColor: background,
    colorScheme: base.colorScheme.copyWith(
      primary: primary,
      onPrimary: onPrimary,
      secondary: primary,
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
  );
}
