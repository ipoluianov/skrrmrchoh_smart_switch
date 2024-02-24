import 'package:flutter/material.dart';

class Settings {
  static Brightness brightness = Brightness.light;
  static Color backColor = Colors.black;
  static Color textColor = Colors.white;
  static Color borderColor = Colors.white30;
  static Color selectionColor = Colors.blue;
  static double borderWidth = 1;

  static void setLight() {
    brightness = Brightness.light;
    backColor = const Color.fromARGB(255, 200, 200, 200);
    textColor = const Color.fromARGB(255, 50, 50, 50);
    borderColor = const Color.fromARGB(255, 50, 50, 50);
    selectionColor = const Color.fromARGB(255, 20, 100, 200);
  }
}
