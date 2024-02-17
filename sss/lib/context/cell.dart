import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sss/context/cell_editor.dart';
import 'package:sss/context/cell_editor_select.dart';
import 'package:sss/context/cell_editor_text.dart';

class Cell {
  String id = UniqueKey().toString();
  int x = 0;
  int y = 0;
  String content = "";

  bool hover = false;

  List<CellEditorSelectItem> options = [];

  CellBorder borderLeft = CellBorder();
  CellBorder borderRight = CellBorder();
  CellBorder borderTop = CellBorder();
  CellBorder borderBottom = CellBorder();

  static const cellEditorTypeNone = 0;
  static const cellEditorTypeText = 1;
  static const cellEditorTypeSelect = 2;

  int cellEditorType = cellEditorTypeNone;

  Function onNeedCloseEditor = () {};

  void closeEditor() {
    onNeedCloseEditor();
  }

  CellEditor? buildEditor(Function() onAccept) {
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
          options,
        );
        break;
    }

    return result;
  }

  Widget buildViewer() {
    return Text(content);
  }

  Cell(this.x, this.y, this.content);

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
