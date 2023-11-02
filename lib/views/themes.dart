import 'package:flutter/material.dart';

class WidthProportion {
  late double full;
  late double oneThird;
  late double half;
  late double oneFourth;
  late double oneSixth;
  late double oneEighth;
  late double oneTenth;

  WidthProportion({
    required this.full,
    required this.half,
    required this.oneThird,
    required this.oneFourth,
    required this.oneSixth,
    required this.oneEighth,
    required this.oneTenth,
  });

  factory WidthProportion.of(BuildContext context) {
    return WidthProportion(
      full: MediaQuery.of(context).size.width,
      half: MediaQuery.of(context).size.width / 2,
      oneThird: MediaQuery.of(context).size.width / 3,
      oneFourth: MediaQuery.of(context).size.width / 4,
      oneSixth: MediaQuery.of(context).size.width / 6,
      oneEighth: MediaQuery.of(context).size.width / 8,
      oneTenth: MediaQuery.of(context).size.width / 10,
    );
  }
}

class CustomTheme {
  Color platinum;
  Color gold;
  Color silver;
  Color bronze;

  CustomTheme({required this.platinum, required this.gold, required this.silver, required this.bronze});
}

class CustomColors {
  CustomTheme light;
  CustomTheme dark;

  CustomColors({required this.light, required this.dark});

  CustomTheme of(BuildContext context){
    if(Theme.of(context).brightness == Brightness.dark){
      return dark;
    } else {
      return light;
    }
  }
}

abstract class CovoiceTheme {
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

  static const ColorScheme _lightColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 238, 84, 82),
    primaryVariant: Color.fromARGB(255, 214, 75, 73),
    secondary: Color.fromARGB(255, 82, 103, 108),
    secondaryVariant: Color.fromARGB(255, 154, 181, 187),
    surface: Color.fromARGB(255, 138, 162, 168),
    background: Color.fromARGB(255, 207, 216, 221),
    error: Color.fromARGB(255, 96, 114, 128),
    onPrimary: Color.fromARGB(255, 180, 180, 180),
    onSecondary: Color.fromARGB(255, 70, 70, 70),
    onSurface: Color.fromARGB(255, 178, 215, 232),
    onBackground: Color.fromARGB(255, 178, 215, 232),
    onError: Color.fromARGB(255, 255, 255, 255),
    brightness: Brightness.light,
  );

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        colorScheme: _lightColorScheme,
        primaryColor: _lightColorScheme.secondaryVariant,
        scaffoldBackgroundColor: _lightColorScheme.background,
        backgroundColor: _lightColorScheme.background,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(5),
            shape: MaterialStateProperty.all(const CircleBorder()),
            backgroundColor: MaterialStateProperty.all(_lightColorScheme.primary),
          ),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: _lightColorScheme.secondaryVariant,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _lightColorScheme.secondary,
          ),
          foregroundColor: _lightColorScheme.secondary,
        ),
        textTheme: TextTheme(
          subtitle1: TextStyle(
            color: _lightColorScheme.secondary,
            fontSize: 14,
          ),
          subtitle2: TextStyle(
            color: _lightColorScheme.onSecondary,
            fontSize: 12,
          ),
          caption: TextStyle(
            color: _lightColorScheme.secondary,
            fontSize: 12,
          ),
          bodyText1: TextStyle(
            fontSize: 28,
            color: _lightColorScheme.secondary,
          ),
          bodyText2: TextStyle(
            fontSize: 16,
            color: _lightColorScheme.secondary,
          ),
          headline3: TextStyle(
            fontSize: 38,
            color: _lightColorScheme.secondary,
            fontWeight: FontWeight.bold,
          )
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(_lightColorScheme.secondary),
            foregroundColor: MaterialStateProperty.all(_lightColorScheme.background),
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              )
            )
          )
        ),
        disabledColor: _lightColorScheme.secondaryVariant,
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(_lightColorScheme.background),
          fillColor: MaterialStateProperty.all(_lightColorScheme.secondary),
        ),
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        colorScheme: _darkColorScheme,
        primaryColor: _darkColorScheme.secondary,
        scaffoldBackgroundColor: _darkColorScheme.background,
        backgroundColor: _darkColorScheme.background,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(5),
            shape: MaterialStateProperty.all(const CircleBorder()),
            backgroundColor: MaterialStateProperty.all(_darkColorScheme.primary),
          ),
        ),
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
          caption: TextStyle(
            color: _darkColorScheme.secondary,
            fontSize: 12,
          ),
          bodyText1: TextStyle(
            fontSize: 28,
            color: _darkColorScheme.secondary,
          ),
          bodyText2: TextStyle(
            fontSize: 16,
            color: _darkColorScheme.secondary,
          ),
          headline3: TextStyle(
            fontSize: 38,
            color: _darkColorScheme.secondary,
            fontWeight: FontWeight.bold,
          )
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(_darkColorScheme.secondary),
            foregroundColor: MaterialStateProperty.all(_darkColorScheme.background),
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              )
            )
          )
        ),
        disabledColor: _darkColorScheme.secondaryVariant,
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(_darkColorScheme.background),
          fillColor: MaterialStateProperty.all(_darkColorScheme.secondary),
        ),
      );

  static final customColors = CustomColors(
    light: CustomTheme(
      platinum: Colors.lightBlue[300]!,
      gold: Colors.yellow[700]!,
      silver: Colors.grey[350]!,
      bronze: Colors.brown[400]!,
    ),
    dark: CustomTheme(
      platinum: Colors.lightBlue[200]!,
      gold: Colors.yellow[700]!,
      silver: Colors.grey,
      bronze: Colors.brown,
    ),
  );
}
