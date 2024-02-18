import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sss/context/cell_editor_select.dart';

import 'cell.dart';
import 'sheet.dart';

class Context {
  Context() {
    createRelayView();
    createEEPROMView();
  }

  void createEEPROMView() {
    var doc = addSheet();
    doc.addColumn("Index", 60);
    doc.addColumn("Relay Number", 60);
    doc.addColumn("Action", 60);
    doc.addColumn("Switch Falling Edge", 60);
    doc.addColumn("Switch Rising Edge", 60);
    doc.addColumn("Relay Falling Edge", 60);
    doc.addColumn("Relay Rising Edge", 60);
    doc.addColumn("Switch Double Click", 60);
    doc.addColumn("Time Hours", 60);
    doc.addColumn("Time Minutes", 60);
    doc.addColumn("Time Value", 60);

    doc.displayName = "Образ EEPROM";
    for (int y = 0; y < 64; y++) {
      doc.setCell(0, y, "$y");
    }
    for (int y = 0; y < 64; y++) {
      for (int x = 1; x < 11; x++) {
        var cell = doc.setCell(x, y, "FF");
        if (x == 2) {
          cell.cellEditorType = Cell.cellEditorTypeText;
        }
        if (x == 3) {
          cell.cellEditorType = Cell.cellEditorTypeSelect;
          cell.options = [
            CellEditorSelectItem("1", LogicalKeyboardKey.digit1),
            CellEditorSelectItem("2", LogicalKeyboardKey.digit2),
            CellEditorSelectItem("3", LogicalKeyboardKey.digit3),
            CellEditorSelectItem("4", null),
            CellEditorSelectItem("5", null),
            CellEditorSelectItem("6", null),
            CellEditorSelectItem("7", null),
            CellEditorSelectItem("8", null),
            CellEditorSelectItem("9", null),
            CellEditorSelectItem("10", null),
            CellEditorSelectItem("11", null),
          ];
        }
      }
    }
  }

  void createRelayView() {
    var doc = addSheet();
    doc.displayName = "Настройка";

    doc.addTopHeaderColumn("", 200);

    doc.addColumn("Реле", 200);

    doc.addTopHeaderColumn("Включение по", 210);
    doc.addColumn("фронту", 60);
    doc.addColumn("выключателя", 150);

    doc.addTopHeaderColumn("Отключение по", 210);
    doc.addColumn("фронту", 60);
    doc.addColumn("выключателя", 150);

    doc.addTopHeaderColumn("Включение по", 210);
    doc.addColumn("фронту", 60);
    doc.addColumn("реле", 150);

    doc.addTopHeaderColumn("Отключение по", 210);
    doc.addColumn("фронту", 60);
    doc.addColumn("реле", 150);

    doc.addTopHeaderColumn("Включение по времени", 200);
    doc.addColumn("часы", 50);
    doc.addColumn("минуты", 150);

    doc.addTopHeaderColumn("Отключение по времени", 200);
    doc.addColumn("часы", 50);
    doc.addColumn("минуты", 150);

    for (int ri = 0; ri < 16; ri++) {
      int countPerRelay = 8;
      for (int i = 0; i < countPerRelay; i++) {
        int y = ri * countPerRelay + i;
        CellBorder borderTop = CellBorder();
        if (i == 0) {
          borderTop.color = Colors.white54;
          borderTop.width = 2;
        }
        switch (i) {
          case 0:
            {
              Cell cell = doc.setCell(0, y, "Реле №$ri");
              cell.cellEditorType = Cell.cellEditorTypeText;
              cell.borderTop = borderTop;
            }
            break;
          case 1:
            {
              Cell cell = doc.setCell(0, y, "relay-state:$ri");
              cell.cellEditorType = Cell.cellEditorTypeText;
              cell.displayNameSource = actualValue;
            }
            break;
          default:
            Cell cell = doc.setCell(0, y, "");
            break;
        }

        {
          Cell cell = doc.setCell(1, y, "");
          cell.borderTop = borderTop;
          cell.defaultValue = "";
          cell.cellEditorType = Cell.cellEditorTypeSelect;
          cell.addOption("", null);
          cell.addOption("0", null);
          cell.addOption("1", null);
          cell.shortcuts
              .add(const CellShortcut(LogicalKeyboardKey.digit2, "0"));
          cell.shortcuts
              .add(const CellShortcut(LogicalKeyboardKey.digit1, "1"));
          cell.displayNameSource = displayNameOnOff;
        }
        {
          Cell cell = doc.setCell(2, y, "");
          cell.borderTop = borderTop;
          cell.cellEditorType = Cell.cellEditorTypeSelect;
          for (int i = 0; i < 24; i++) {
            cell.addOption("$i", null);
          }
          cell.displayNameSource = displayNameSwitch;
          cell.defaultValue = "";
        }
        {
          Cell cell = doc.setCell(3, y, "");
          cell.borderTop = borderTop;
          cell.defaultValue = "";
          cell.cellEditorType = Cell.cellEditorTypeSelect;
          cell.addOption("", null);
          cell.addOption("0", null);
          cell.addOption("1", null);
          cell.shortcuts
              .add(const CellShortcut(LogicalKeyboardKey.digit2, "0"));
          cell.shortcuts
              .add(const CellShortcut(LogicalKeyboardKey.digit1, "1"));
          cell.displayNameSource = displayNameOnOff;
        }
        {
          Cell cell = doc.setCell(4, y, "");
          cell.borderTop = borderTop;
          cell.cellEditorType = Cell.cellEditorTypeSelect;
          for (int i = 0; i < 24; i++) {
            cell.addOption("$i", null);
          }
          cell.displayNameSource = displayNameSwitch;
          cell.defaultValue = "";
        }
        {
          Cell cell = doc.setCell(5, y, "");
          cell.borderTop = borderTop;
          cell.defaultValue = "";
          cell.cellEditorType = Cell.cellEditorTypeSelect;
          cell.addOption("", null);
          cell.addOption("0", null);
          cell.addOption("1", null);
          cell.shortcuts
              .add(const CellShortcut(LogicalKeyboardKey.digit2, "0"));
          cell.shortcuts
              .add(const CellShortcut(LogicalKeyboardKey.digit1, "1"));
          cell.displayNameSource = displayNameOnOff;
        }
        {
          Cell cell = doc.setCell(6, y, "");
          cell.borderTop = borderTop;
          cell.cellEditorType = Cell.cellEditorTypeSelect;
          for (int i = 0; i < 16; i++) {
            cell.addOption("$i", null);
          }
          cell.displayNameSource = displayNameRelay;
          cell.defaultValue = "";
        }
        {
          Cell cell = doc.setCell(7, y, "");
          cell.borderTop = borderTop;
          cell.defaultValue = "";
          cell.cellEditorType = Cell.cellEditorTypeSelect;
          cell.addOption("", null);
          cell.addOption("0", null);
          cell.addOption("1", null);
          cell.shortcuts
              .add(const CellShortcut(LogicalKeyboardKey.digit2, "0"));
          cell.shortcuts
              .add(const CellShortcut(LogicalKeyboardKey.digit1, "1"));
          cell.displayNameSource = displayNameOnOff;
        }
        {
          Cell cell = doc.setCell(8, y, "");
          cell.borderTop = borderTop;
          cell.cellEditorType = Cell.cellEditorTypeSelect;
          for (int i = 0; i < 16; i++) {
            cell.addOption("$i", null);
          }
          cell.displayNameSource = displayNameRelay;
          cell.defaultValue = "";
        }
        {
          Cell cell = doc.setCell(9, y, "");
          cell.borderTop = borderTop;
          cell.cellEditorType = Cell.cellEditorTypeText;
          cell.defaultValue = "";
        }
        {
          Cell cell = doc.setCell(10, y, "");
          cell.borderTop = borderTop;
          cell.cellEditorType = Cell.cellEditorTypeText;
          cell.defaultValue = "";
        }
        {
          Cell cell = doc.setCell(11, y, "");
          cell.borderTop = borderTop;
          cell.cellEditorType = Cell.cellEditorTypeText;
          cell.defaultValue = "";
        }
        {
          Cell cell = doc.setCell(12, y, "");
          cell.borderTop = borderTop;
          cell.cellEditorType = Cell.cellEditorTypeText;
          cell.defaultValue = "";
        }
      }
    }
  }

  void updateSwitchOptionsOnCell(Cell cell) {}

  Sheet addSheet() {
    Sheet doc = Sheet();
    docs.add(doc);
    doc.onUpdate = notifyChanges;
    doc.onShowEditDialog = (Cell c) {
      onShowEditDialog(c);
    };
    doc.onDefaultFocus = () {
      onDefaultFocus();
    };
    return doc;
  }

  String displayNameOnOff(String v) {
    if (v == "0") {
      return "ОТКЛ";
    }
    if (v == "1") {
      return "ВКЛ";
    }
    return v;
  }

  String displayNameSwitch(String v) {
    if (v == "") {
      return "";
    }
    return "выключатель №$v";
  }

  String displayNameRelay(String v) {
    if (v == "") {
      return "";
    }
    return "реле №$v";
  }

  String actualValue(String v) {
    if (v.contains("relay-state:")) {
      List<String> parts = v.split(":");
      if (parts.length == 2) {
        int relayIndex = int.parse(parts[1]);
        if (relayIndex == 1) {
          return "Статус: ВКЛ";
        }
        return "Статус: откл";
      }
      return "";
    }
    return "";
  }

  Function onUpdate = () {};
  Function onShowEditDialog = (Cell c) {};
  Function onDefaultFocus = () {};

  void requestDefaultFocus() {
    onDefaultFocus();
  }

  List<Sheet> docs = [];
  int currentDocIndex = 0;

  bool processedLastKey = false;

  void notifyChanges() {
    onUpdate();
  }

  void processKeyDown(RawKeyDownEvent event) {
    bool processed = false;

    if (event.logicalKey == LogicalKeyboardKey.f1) {
      currentDocIndex = 0;
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.f2) {
      currentDocIndex = 1;
      return;
    }

    processed = docs[currentDocIndex].processKeyDown(event);
    //print("Processed: $processed");
    processedLastKey = processed;
  }

  Widget buildButton(BuildContext context, int index) {
    Color col = Colors.white24;
    if (index == currentDocIndex) {
      col = Colors.blue;
    }
    Sheet doc = docs[index];
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          currentDocIndex = index;
          notifyChanges();
        },
        child: Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
            color: col,
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: Center(
            child: Text(doc.displayName),
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    List<Widget> buttons = [];
    for (int i = 0; i < docs.length; i++) {
      buttons.add(buildButton(context, i));
    }
    return Row(
      children: buttons,
    );
  }

  Widget build(
      BuildContext context, double viewportWidth, double viewportHeight) {
    Widget currentDoc = Container();
    if (currentDocIndex >= 0 && currentDocIndex < docs.length) {
      currentDoc = docs[currentDocIndex]
          .build(context, viewportWidth, viewportHeight - 50);
    }

    //return Container(color: Colors.yellow, width: 50);

    return Row(
      children: [
        Container(color: Colors.yellow, width: 0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(context),
              Expanded(
                child: currentDoc,
              ),
              Container(
                height: 10,
                color: Colors.black,
              ),
            ],
          ),
          //Text("qqq"),
        ),
        Container(color: Colors.purple, width: 0),
      ],
    );
  }
}
