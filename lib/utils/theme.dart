import 'package:flutter/material.dart';

class AppTheme{
  static  ThemeData lightTheme = ThemeData(brightness: Brightness.light,
      primarySwatch: MaterialColor(0xFF64C4DA, <int, Color>{
        50: Color(0x1A64C3D9),
        100: Color(0x4D64C3D9),
        200: Color(0x8064C3D9),
        300: Color(0x9964C3D9),
        400: Color(0xCC64C3D9),
        500: Color(0xFF64C3D9),
        600: Color(0xFF64C3D9),
        700: Color(0xFF64C3D9),
        800: Color(0xFF64C3D9),
        900: Color(0xFF64C3D9),
      }),
    fontFamily: 'PublicSans' 'Poppins-Regular',

  );
  static  ThemeData whitelightTheme = ThemeData(brightness: Brightness.light,
    primarySwatch: MaterialColor(0xFFFFFFFF, <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    }),
    fontFamily: 'PublicSans' 'Poppins-Regular',

  );
  static  ThemeData appThemecolors = ThemeData(brightness: Brightness.light,
    primarySwatch: MaterialColor(0xFF64C4DA, <int, Color>{
      50: Color(0xFF64C4DA),
      100: Color(0xFF64C4DA),
      200: Color(0xFF64C4DA),
      300: Color(0xFF64C4DA),
      400: Color(0xFF64C4DA),
      500: Color(0xFF64C4DA),
      600: Color(0xFF64C4DA),
      700: Color(0xFF64C4DA),
      800: Color(0xFF64C4DA),
      900: Color(0xFF64C4DA),
    }),
    fontFamily: 'PublicSans' 'Poppins-Regular',

  );
  // static  ThemeData darkTheme = ThemeData(brightness: Brightness.dark,);
}

