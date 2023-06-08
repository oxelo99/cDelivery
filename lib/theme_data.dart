import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static Color buttonColor(context) {
    if (MediaQuery
        .of(context)
        .platformBrightness == Brightness.light) {
      return const Color.fromARGB(255, 24, 166, 64);
    } else {
      return const Color.fromARGB(255, 241, 148, 58);
    }
  }
  static BoxDecoration customDecoration(context){
    return const BoxDecoration(
        color: Color.fromARGB(255, 48, 48, 48),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(
                0, 1), // changes position of shadow
          ),
        ]
    );
}
  static Color backgroundColor(context){
    if (MediaQuery
        .of(context)
        .platformBrightness == Brightness.light) {
      return Colors.white;
    } else {
      return const Color.fromARGB(255, 48, 48, 48);
    }
  }
  static Color textColor(context) {
    if (MediaQuery
        .of(context)
        .platformBrightness == Brightness.light) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  build(context) {}

  static ThemeData get lightTheme {
    return ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 24, 166, 64),
        ),
        primaryColor: const Color.fromARGB(255, 24, 166, 64),
        canvasColor: const Color.fromARGB(255, 24, 166, 64),
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
        textTheme: GoogleFonts.kanitTextTheme(),
        hintColor: Colors.white,

        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) => const Color.fromARGB(255, 24, 166, 64)),
              shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20));
              }),
            )
        ),

        inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.black),
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1, color: Color.fromARGB(255, 24, 166, 64)),
                borderRadius: BorderRadius.all(Radius.circular(25.0)))));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 33, 33, 33),
        ),
        primaryColor: const Color.fromARGB(255, 33, 33, 33),
        canvasColor: const Color.fromARGB(255, 241, 148, 58),
        scaffoldBackgroundColor: const Color.fromARGB(255, 48, 48, 48),
        brightness: Brightness.dark,
        textTheme: GoogleFonts.kanitTextTheme(),
        hintColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) => const Color.fromARGB(255, 241, 148, 58)),
              shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20));
              }),
            )
        ),

        inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(color: Colors.white),
            //fillColor: Colors.white,
            //filled: false,

            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Color.fromARGB(255, 241,
                    148, 58)),
                borderRadius: BorderRadius.all(Radius.circular(25.0
                )
                )
            )
        )
    );
  }
}
