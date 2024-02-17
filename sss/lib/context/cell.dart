import 'package:flutter/material.dart';

class Cell {
  int x = 0;
  int y = 0;
  String content = "";
  int borderWidth = 1;
  Color borderColor = Colors.transparent;

  Cell(this.x, this.y, this.content);
}
