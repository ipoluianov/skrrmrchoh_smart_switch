import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sss/context/cell_editor.dart';
import 'package:sss/context/cell_editor_select.dart';
import 'package:sss/context/cell_editor_text.dart';
import 'package:sss/settings.dart';

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
  bool warning = false;

  bool fontBold = false;
  double fontSize = 16;
  Color textColor = Colors.black;
  Color backColor = Colors.white;

  List<CellShortcut> shortcuts = [];

  bool hover = false;

  List<CellEditorSelectItem> options = [];
  void addOption(String value, LogicalKeyboardKey? shortcut) {
    var item = CellEditorSelectItem(value, shortcut);
    options.add(item);
  }

  CellBorder borderLeft = CellBorder(1, Colors.transparent);
  CellBorder borderRight = CellBorder(1, Colors.transparent);
  CellBorder borderTop = CellBorder(1, Colors.transparent);
  CellBorder borderBottom = CellBorder(1, Colors.transparent);

  void setBorderLeftTopDefault() {
    borderLeft = CellBorder(Settings.borderWidth, Settings.borderColor);
    borderTop = CellBorder(Settings.borderWidth, Settings.borderColor);
  }

  static const cellEditorTypeNone = 0;
  static const cellEditorTypeText = 1;
  static const cellEditorTypeSelect = 2;

  int cellEditorType = cellEditorTypeNone;

  Function onNeedCloseEditor = () {};

  String textToInitField = "";

  String Function(String) displayNameSource = (String v) {
    return "";
  };

  String action = "";
  Function(String) onAction = (String a) {};

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
    if (action.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Settings.selectionColor,
            ),
            borderRadius: BorderRadius.circular(3),
            color: Settings.selectionColor,
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Center(
              child: Text(
                displayNameSource(value),
              ),
            ),
          ),
        ),
      );
    }
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: Container(
        color: warning ? Colors.redAccent.withOpacity(0.4) : backColor,
        child: Row(
          children: [
            Text(
              displayNameSource(value),
              style: TextStyle(
                fontWeight: fontBold ? FontWeight.bold : FontWeight.normal,
                fontSize: fontSize,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
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
  CellBorder(this.width, this.color);
}
