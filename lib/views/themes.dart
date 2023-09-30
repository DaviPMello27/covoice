import 'package:flutter/material.dart';

class WidthProportion {
  late double oneThird;
  late double half;
  late double oneFourth;
  late double oneSixth;
  late double oneEighth;
  late double oneTenth;

  WidthProportion({
    required this.half,
    required this.oneThird,
    required this.oneFourth,
    required this.oneSixth,
    required this.oneEighth,
    required this.oneTenth,
  });

  factory WidthProportion.of(BuildContext context) {
    return WidthProportion(
      half: MediaQuery.of(context).size.width / 2,
      oneThird: MediaQuery.of(context).size.width / 3,
      oneFourth: MediaQuery.of(context).size.width / 4,
      oneSixth: MediaQuery.of(context).size.width / 6,
      oneEighth: MediaQuery.of(context).size.width / 8,
      oneTenth: MediaQuery.of(context).size.width / 10,
    );
  }
}

abstract class VoicifyTheme {
  static const ColorScheme _darkColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 255, 179, 0),
    primaryVariant: Color.fromARGB(255, 229, 161, 0),
    secondary: Color.fromARGB(255, 178, 215, 232),
    secondaryVariant: Color.fromARGB(255, 102, 123, 133),
    surface: Color.fromARGB(255, 19, 23, 26),
    background: Color.fromARGB(255, 38, 50, 56),
    error: Color.fromARGB(255, 96, 114, 128),
    onPrimary: Color.fromARGB(255, 180, 180, 180),
    onSecondary: Color.fromARGB(255, 255, 255, 255),
    onSurface: Color.fromARGB(255, 178, 215, 232),
    onBackground: Color.fromARGB(255, 178, 215, 232),
    onError: Color.fromARGB(255, 255, 255, 255),
    brightness: Brightness.dark,
  );

  static ThemeData get light => ThemeData(
        primaryColor: Colors.blueGrey.shade300,
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        backgroundColor: Colors.blueGrey.shade100,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(5),
            shape: MaterialStateProperty.all(const CircleBorder()),
            backgroundColor: MaterialStateProperty.all(Colors.red[300]),
          ),
        ),
        buttonColor: Colors.red[400],
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: _darkColorScheme.error,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _darkColorScheme.secondary,
          ),
          foregroundColor: _darkColorScheme.error,
        ),
        textTheme: TextTheme(
          subtitle1: TextStyle(
            color: Colors.blueGrey.shade700,
            fontSize: 12,
          ),
          bodyText1: const TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        colorScheme: _darkColorScheme,
        primaryColor: const Color.fromARGB(255, 144, 164, 174),
        scaffoldBackgroundColor: _darkColorScheme.background,
        backgroundColor: _darkColorScheme.background,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(5),
            shape: MaterialStateProperty.all(const CircleBorder()),
            backgroundColor: MaterialStateProperty.all(_darkColorScheme.primary),
          ),
        ),
        buttonColor: _darkColorScheme.primaryVariant,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: _darkColorScheme.background,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _darkColorScheme.secondary,
          ),
        ),
        textTheme: TextTheme(
          subtitle1: TextStyle(
            color: _darkColorScheme.secondary,
            fontSize: 14,
          ),
          subtitle2: TextStyle(
            color: _darkColorScheme.onSecondary,
            fontSize: 12,
          ),
          bodyText1: TextStyle(
            fontSize: 28,
            color: _darkColorScheme.secondary,
          ),
          headline3: TextStyle(
            fontSize: 38,
            color: _darkColorScheme.secondary,
            fontWeight: FontWeight.bold,
          )
        ),
      );
}
