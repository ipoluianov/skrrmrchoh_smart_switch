import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sss/context/cell_editor.dart';
import 'package:sss/context/cell_editor_select.dart';
import 'package:sss/context/cell_editor_text.dart';

class CellShortcut {
  final LogicalKeyboardKey key;
  final String value;
  const CellShortcut(this.key, this.value);
}

class Cell {
  Cell(this.x, this.y, this.value) {
    displayNameSource = (String v) {
      return value;
    };
  }

  String id = UniqueKey().toString();
  int x = 0;
  int y = 0;
  String value = "";
  String defaultValue = "!#NO#!";

  List<CellShortcut> shortcuts = [];

  bool hover = false;

  List<CellEditorSelectItem> options = [];
  void addOption(String value, LogicalKeyboardKey? shortcut) {
    var item = CellEditorSelectItem(value, shortcut);
    options.add(item);
  }

  CellBorder borderLeft = CellBorder();
  CellBorder borderRight = CellBorder();
  CellBorder borderTop = CellBorder();
  CellBorder borderBottom = CellBorder();

  static const cellEditorTypeNone = 0;
  static const cellEditorTypeText = 1;
  static const cellEditorTypeSelect = 2;

  int cellEditorType = cellEditorTypeNone;

  Function onNeedCloseEditor = () {};

  String Function(String) displayNameSource = (String v) {
    return "";
  };

  void closeEditor() {
    onNeedCloseEditor();
  }

  CellEditor? buildEditor(String header, Function() onAccept) {
    CellEditor? result;
    switch (cellEditorType) {
      case cellEditorTypeNone:
        break;
      case cellEditorTypeText:
        result = CellEditorText(this, onAccept);
        break;
      case cellEditorTypeSelect:
        result = CellEditorSelect(
          this,
          header,
          options,
        );
        break;
    }

    return result;
  }

  Widget buildViewer() {
    return Text(displayNameSource(value));
  }

  bool Function(RawKeyDownEvent event) onKeyDownEvent = (ev) {
    return false;
  };

  bool processKeyDownEvent(RawKeyDownEvent event) {
    return onKeyDownEvent(event);
  }
}

class CellBorder {
  double width = 2;
  Color color = Colors.transparent;
}
