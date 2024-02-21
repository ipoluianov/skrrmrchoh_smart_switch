import 'package:flutter/material.dart';

class Settings {
  static Brightness brightness = Brightness.dark;
  static Color backColor = Colors.black;
  static Color textColor = Colors.white;
  static Color borderColor = Colors.white30;
  static Color selectionColor = Colors.blue;

  static void setLight() {
    brightness = Brightness.light;
    backColor = Colors.white;
    textColor = const Color.fromARGB(255, 200, 200, 200);
    borderColor = const Color.fromARGB(255, 200, 200, 200);
    selectionColor = const Color.fromARGB(255, 20, 20, 200);
  }
}
