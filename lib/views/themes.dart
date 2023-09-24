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
          backgroundColor: Colors.blueGrey.shade400,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black54,
          ),
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
        primaryColor: Colors.blueGrey.shade900,
        scaffoldBackgroundColor: Colors.blueGrey.shade900,
        backgroundColor: Colors.blueGrey.shade900,
        shadowColor: const Color.fromARGB(255, 44, 56, 59),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(5),
            shape: MaterialStateProperty.all(const CircleBorder()),
            backgroundColor: MaterialStateProperty.all(Colors.amber),
          ),
        ),
        buttonColor: Colors.amber[600],
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.blueGrey.shade900,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white70,
          ),
        ),
        textTheme: TextTheme(
          subtitle1: TextStyle(
            color: Colors.blueGrey.shade400,
            fontSize: 14,
          ),
          subtitle2: const TextStyle(
            color: Color.fromARGB(255, 178, 215, 232),
            fontSize: 12,
          ),
          bodyText1: const TextStyle(
            fontSize: 28,
            color: Color.fromARGB(255, 178, 215, 232),
          ),
          headline3: const TextStyle(
            fontSize: 38,
            color: Color.fromARGB(255, 178, 215, 232),
            fontWeight: FontWeight.bold,
          )
        ),
      );
}
