import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sss/context/cell_editor_select.dart';
import 'package:sss/settings.dart';

import 'cell.dart';
import 'project.dart';
import 'relay_view_row.dart';
import 'sheet.dart';

import 'package:confirm_dialog/confirm_dialog.dart';

class Context {
  Context() {
    initDocument();
  }

  static const int relayViewSheetIndex = 0;
  static const int switchesSheetIndex = 1;
  static const int settingsSheetIndex = 2;
  static const int eepromSheetIndex = 3;

  String currentFileName = "";

  void createEEPROMView() {
    var doc = addSheet();
    doc.addColumn("N", 60);
    doc.addColumn("Relay\r\n *lines", 100);
    doc.addColumn("Action\r\n *invert", 100);
    doc.addColumn("SW falling\r\n *escort block", 100);
    doc.addColumn("SW rising\r\n *escort timer", 100);
    doc.addColumn("RL falling", 100);
    doc.addColumn("RL rising", 100);
    doc.addColumn("---", 100);
    doc.addColumn("Time Hours", 100);
    doc.addColumn("Time Minutes", 100);
    doc.addColumn("Time Value", 100);

    doc.displayName = "Образ EEPROM";
    for (int y = 0; y < 64; y++) {
      doc.setCell(0, y, "");
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

  String lastProjectString = "";

  bool hasChanges() {
    String s = saveDocumentToString();
    return s != lastProjectString;
  }

  void createSwitches() {
    var doc = addSheet();
    doc.addColumn("Выключатель", 250);
    doc.addColumn("Фронт", 100);
    doc.addColumn("Действие", 100);
    doc.addColumn("Реле", 100);

    doc.displayName = "Сводка";
  }

  int countPerRelay = 8;

  void createSettings() {
    var doc = addSheet();
    doc.addColumn("Параметр", 250);
    doc.addColumn("Значение", 250);

    doc.displayName = "Настройки";

    for (int relayIndex = 0; relayIndex < 16; relayIndex++) {
      var cell1 = doc.setCell(0, relayIndex, "Реле $relayIndex");
      cell1.setBorderLeftTopDefault();
      cell1.cellEditorType = Cell.cellEditorTypeNone;

      var cell2 = doc.setCell(1, relayIndex, "Название реле");
      cell2.setBorderLeftTopDefault();
      cell2.cellEditorType = Cell.cellEditorTypeText;
    }

    for (int swIndex = 0; swIndex < 24; swIndex++) {
      var cell1 = doc.setCell(0, 16 + swIndex, "Выключатель $swIndex");
      cell1.setBorderLeftTopDefault();
      cell1.cellEditorType = Cell.cellEditorTypeNone;

      var cell2 = doc.setCell(1, 16 + swIndex, "Название выключателя");
      cell2.setBorderLeftTopDefault();
      cell2.cellEditorType = Cell.cellEditorTypeText;
    }
  }

  void createRelayView() {
    var doc = addSheet();
    doc.displayName = "Реле";

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
      for (int i = 0; i < countPerRelay; i++) {
        int y = ri * countPerRelay + i;
        bool firstLineOfRelay = i == 0;
        CellBorder borderTop = CellBorder(
          Settings.borderWidth,
          Settings.borderColor,
        );
        CellBorder borderLeft = CellBorder(
          Settings.borderWidth,
          Settings.borderColor,
        );
        CellBorder borderRight = CellBorder(
          Settings.borderWidth,
          Colors.transparent,
        );
        CellBorder borderBottom = CellBorder(
          Settings.borderWidth,
          Colors.transparent,
        );
        if (i == 0) {
          borderTop.color = Settings.borderColor;
          borderTop.width = 2;
        }
        switch (i) {
          case 0:
            {
              Cell cell = doc.setCell(0, y, "Реле №$ri");
              cell.cellEditorType = Cell.cellEditorTypeText;
              cell.borderTop = borderTop;
              cell.borderLeft = borderLeft;
              cell.fontBold = true;
              cell.fontSize += 2;
              cell.backColor = Colors.amberAccent;
            }
            break;
          case 1:
            {
              Cell cell = doc.setCell(0, y, "relay-state:$ri");
              cell.cellEditorType = Cell.cellEditorTypeNone;
              cell.displayNameSource = actualValue;
              cell.borderLeft = borderLeft;
            }
            break;
          case 2:
            {
              Cell cell = doc.setCell(0, y, "Включить");
              cell.action = "on:$ri";
            }
            break;
          case 3:
            {
              Cell cell = doc.setCell(0, y, "Отключить");
              cell.action = "on:$ri";
            }
            break;
          case 4:
            {
              Cell cell = doc.setCell(0, y, "Отключить по таймеру");
              cell.borderTop = borderTop;
              cell.borderLeft = borderLeft;
              cell.borderBottom = borderBottom;
              cell.borderRight = borderRight;
              cell.defaultValue = "";
              cell.cellEditorType = Cell.cellEditorTypeNone;
            }
            break;
          case 5:
            {
              Cell cell = doc.setCell(0, y, "");
              cell.borderTop = borderTop;
              cell.borderLeft = borderLeft;
              cell.borderBottom = CellBorder(
                Settings.borderWidth,
                Settings.borderColor,
              );
              cell.borderRight = borderRight;
              cell.defaultValue = "";
              cell.cellEditorType = Cell.cellEditorTypeText;
              cell.displayNameSource = displayNameOffTimer;
            }
            break;
          default:
            Cell cell = doc.setCell(0, y, "");
            cell.borderLeft = borderLeft;
            break;
        }

        {
          Cell cell = doc.setCell(1, y, "");
          cell.borderTop = borderTop;
          cell.borderLeft = borderLeft;
          cell.borderBottom = borderBottom;
          cell.borderRight = borderRight;
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
          cell.borderLeft = borderLeft;
          cell.borderBottom = borderBottom;
          cell.borderRight = borderRight;
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
          cell.borderLeft = borderLeft;
          cell.borderBottom = borderBottom;
          cell.borderRight = borderRight;
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
          cell.borderLeft = borderLeft;
          cell.borderBottom = borderBottom;
          cell.borderRight = borderRight;
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
          cell.borderLeft = borderLeft;
          cell.borderBottom = borderBottom;
          cell.borderRight = borderRight;
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
          cell.borderLeft = borderLeft;
          cell.borderBottom = borderBottom;
          cell.borderRight = borderRight;
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
          cell.borderLeft = borderLeft;
          cell.borderBottom = borderBottom;
          cell.borderRight = borderRight;
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
          cell.borderLeft = borderLeft;
          cell.borderBottom = borderBottom;
          cell.borderRight = borderRight;
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
          cell.borderLeft = borderLeft;
          cell.borderBottom = borderBottom;
          cell.borderRight = borderRight;
          cell.cellEditorType = Cell.cellEditorTypeText;
          cell.defaultValue = "";
        }
        {
          Cell cell = doc.setCell(10, y, "");
          cell.borderTop = borderTop;
          cell.borderLeft = borderLeft;
          cell.borderBottom = borderBottom;
          cell.borderRight = borderRight;
          cell.cellEditorType = Cell.cellEditorTypeText;
          cell.defaultValue = "";
        }
        {
          Cell cell = doc.setCell(11, y, "");
          cell.borderTop = borderTop;
          cell.borderLeft = borderLeft;
          cell.borderBottom = borderBottom;
          cell.borderRight = borderRight;
          cell.cellEditorType = Cell.cellEditorTypeText;
          cell.defaultValue = "";
        }
        {
          Cell cell = doc.setCell(12, y, "");
          cell.borderTop = borderTop;
          cell.borderLeft = borderLeft;
          cell.borderBottom = borderBottom;
          cell.borderRight = borderRight;
          cell.cellEditorType = Cell.cellEditorTypeText;
          cell.defaultValue = "";
        }
      }
    }
  }

  String formatValue(int v) {
    return v.toRadixString(16).padLeft(2, '0').toUpperCase();
  }

  void clearEEPROM() {
    var shEEPROM = docs[eepromSheetIndex];
    for (int i = 0; i < 64; i++) {
      int rowIndex = i;
      /*if (i > 1) {
        rowIndex -= 1;
      }*/
      //if (i != 1) {
      shEEPROM.getCell(0, i).value = rowIndex.toString();
      //}

      for (int ii = 1; ii < 11; ii++) {
        shEEPROM.getCell(ii, i).value = formatValue(0xFF);
      }
    }
  }

  int compileEEPROMIndex = 1;

  void addEvent(int relayIndex, int action, int column, int value) {
    var shEEPROM = docs[eepromSheetIndex];
    String valueStr = formatValue(value);
    bool hasSet = false;
    for (int i = 0; i <= compileEEPROMIndex; i++) {
      int? rIndex = shEEPROM.getCellValue(1, i);
      int? aIndex = shEEPROM.getCellValue(2, i);
      int? v = shEEPROM.getCellValue(column, i);
      if (relayIndex == rIndex && action == aIndex) {
        if (v == 0xFF) {
          shEEPROM.getCell(column, i).value = valueStr;
          hasSet = true;
        }
      }
    }

    if (!hasSet) {
      if (compileEEPROMIndex < 63) {
        compileEEPROMIndex++;

        shEEPROM.getCell(1, compileEEPROMIndex).value = formatValue(relayIndex);
        shEEPROM.getCell(2, compileEEPROMIndex).value = formatValue(action);
        shEEPROM.getCell(column, compileEEPROMIndex).value = valueStr;
      }
    }
  }

  void addEventTime(int relayIndex, int action, int column, int h, int m) {
    var shEEPROM = docs[eepromSheetIndex];
    String valueHStr = formatValue(h);
    String valueMStr = formatValue(m);
    bool hasSet = false;
    for (int i = 0; i <= compileEEPROMIndex; i++) {
      int? rIndex = shEEPROM.getCellValue(1, i);
      int? aIndex = shEEPROM.getCellValue(2, i);
      int? vH = shEEPROM.getCellValue(column, i);
      int? vM = shEEPROM.getCellValue(column + 1, i);
      if (relayIndex == rIndex && action == aIndex) {
        if (vH == 0xFF && vM == 0xFF) {
          shEEPROM.getCell(column, i).value = valueHStr;
          shEEPROM.getCell(column + 1, i).value = valueMStr;
          hasSet = true;
        }
      }
    }

    if (!hasSet) {
      if (compileEEPROMIndex < 63) {
        compileEEPROMIndex++;

        shEEPROM.getCell(1, compileEEPROMIndex).value = formatValue(relayIndex);
        shEEPROM.getCell(2, compileEEPROMIndex).value = formatValue(action);
        shEEPROM.getCell(column, compileEEPROMIndex).value = valueHStr;
        shEEPROM.getCell(column + 1, compileEEPROMIndex).value = valueMStr;
      }
    }
  }

  void clearSwitches() {
    var shSwitches = docs[switchesSheetIndex];
    shSwitches.clearRows();
  }

  void fillSwitches() {
    int index = 0;
    var shEEPROM = docs[eepromSheetIndex];
    var shSwitches = docs[switchesSheetIndex];
    shSwitches.clearRows();
    for (int swIndex = 0; swIndex < 16; swIndex++) {
      for (int i = 1; i < 64; i++) {
        var switchRising = shEEPROM.getCellValue(4, i);
        if (swIndex != switchRising) {
          continue;
        }
        var relay = shEEPROM.getCellValue(1, i);
        var action = shEEPROM.getCellValue(2, i);
        if (switchRising != 0xFF) {
          shSwitches.setCell(0, index, getSwitchName(swIndex));
          shSwitches.setCell(1, index, "восх фронт");
          shSwitches.setCell(2, index, action == 0 ? "включает" : "выключает");
          shSwitches.setCell(3, index, getRelayName(relay));
          index++;
        }
      }
      for (int i = 1; i < 64; i++) {
        var switchRising = shEEPROM.getCellValue(3, i);
        if (swIndex != switchRising) {
          continue;
        }
        var relay = shEEPROM.getCellValue(1, i);
        var action = shEEPROM.getCellValue(2, i);
        if (switchRising != 0xFF) {
          shSwitches.setCell(0, index, getSwitchName(swIndex));
          shSwitches.setCell(1, index, "низх фронт");
          shSwitches.setCell(2, index, action == 0 ? "включает" : "выключает");
          shSwitches.setCell(3, index, getRelayName(relay));
          index++;
        }
      }
    }
  }

  void compileEEPROM() {
    int countPerRelay = 8;
    compileEEPROMIndex = 0;
    clearEEPROM();
    var shRelayView = docs[relayViewSheetIndex];
    var shEEPROM = docs[eepromSheetIndex];
    var shSettings = docs[settingsSheetIndex];

    Map<int, int> timerValuesByRelay = {};
    for (int ri = 0; ri < 16; ri++) {
      var y = ri * countPerRelay + 5;
      var v = shRelayView.getCell(0, y).value;
      int vInt = 255;
      int? vIntN = int.tryParse(v);
      if (vIntN != null) {
        vInt = vIntN;
      }
      timerValuesByRelay[ri] = vInt;
    }

    for (int ri = 0; ri < 16; ri++) {
      for (int i = 0; i < countPerRelay; i++) {
        var y = ri * countPerRelay + i;
        var swonFront = shRelayView.getCell(1, y).value;
        var swonSwitch = shRelayView.getCell(2, y).value;
        var swoffFront = shRelayView.getCell(3, y).value;
        var swoffSwitch = shRelayView.getCell(4, y).value;
        var rlonFront = shRelayView.getCell(5, y).value;
        var rlonRelay = shRelayView.getCell(6, y).value;
        var rloffFront = shRelayView.getCell(7, y).value;
        var rloffRelay = shRelayView.getCell(8, y).value;
        var tonH = shRelayView.getCell(9, y).value;
        var tonM = shRelayView.getCell(10, y).value;
        var toffH = shRelayView.getCell(11, y).value;
        var toffM = shRelayView.getCell(12, y).value;

        bool swonValid = false;
        int swonFrontByte = 0xFF;
        int swonSwitchByte = 0xFF;
        if (swonFront.isEmpty && swonSwitch.isEmpty) {
          swonValid = true;
        }
        if (swonFront.isNotEmpty && swonSwitch.isNotEmpty) {
          swonFrontByte = int.tryParse(swonFront, radix: 10) ?? 0xFF;
          swonSwitchByte = int.tryParse(swonSwitch, radix: 10) ?? 0xFF;
          if (swonFrontByte == 0xFF || swonSwitchByte == 0xFF) {
            swonFrontByte = 0xFF;
            swonSwitchByte = 0xFF;
          }
          swonValid = swonFrontByte != 0xFF && swonSwitchByte != 0xFF;
          if (swonValid) {
            if (swonFrontByte == 0x00) {
              addEvent(ri, 0, 3, swonSwitchByte);
            }
            if (swonFrontByte == 0x01) {
              addEvent(ri, 0, 4, swonSwitchByte);
            }
          }
        }
        shRelayView.getCell(1, y).warning = !swonValid;
        shRelayView.getCell(2, y).warning = !swonValid;

        bool swoffValid = false;
        int swoffFrontByte = 0xFF;
        int swoffSwitchByte = 0xFF;
        if (swoffFront.isEmpty && swoffSwitch.isEmpty) {
          swoffValid = true;
        }
        if (swoffFront.isNotEmpty && swoffSwitch.isNotEmpty) {
          swoffFrontByte = int.tryParse(swoffFront, radix: 10) ?? 0xFF;
          swoffSwitchByte = int.tryParse(swoffSwitch, radix: 10) ?? 0xFF;
          if (swoffFrontByte == 0xFF || swoffSwitchByte == 0xFF) {
            swoffFrontByte = 0xFF;
            swoffSwitchByte = 0xFF;
          }
          swoffValid = swoffFrontByte != 0xFF && swoffSwitchByte != 0xFF;
          if (swoffValid) {
            if (swoffFrontByte == 0x00) {
              addEvent(ri, 1, 3, swoffSwitchByte);
            }
            if (swoffFrontByte == 0x01) {
              addEvent(ri, 1, 4, swoffSwitchByte);
            }
          }
        }
        shRelayView.getCell(3, y).warning = !swoffValid;
        shRelayView.getCell(4, y).warning = !swoffValid;

        // Relays
        bool rlonValid = false;
        int rlonFrontByte = 0xFF;
        int rlonRelayByte = 0xFF;
        if (rlonFront.isEmpty && rlonRelay.isEmpty) {
          rlonValid = true;
        }
        if (rlonFront.isNotEmpty && rlonRelay.isNotEmpty) {
          rlonFrontByte = int.tryParse(rlonFront, radix: 10) ?? 0xFF;
          rlonRelayByte = int.tryParse(rlonRelay, radix: 10) ?? 0xFF;
          if (rlonFrontByte == 0xFF || rlonRelayByte == 0xFF) {
            rlonFrontByte = 0xFF;
            rlonRelayByte = 0xFF;
          }
          rlonValid = rlonFrontByte != 0xFF && rlonRelayByte != 0xFF;
          if (rlonValid) {
            if (rlonFrontByte == 0x00) {
              addEvent(ri, 0, 5, rlonRelayByte);
            }
            if (rlonFrontByte == 0x01) {
              addEvent(ri, 0, 6, rlonRelayByte);
            }
          }
        }
        shRelayView.getCell(5, y).warning = !rlonValid;
        shRelayView.getCell(6, y).warning = !rlonValid;

        // Relays
        bool rloffValid = false;
        int rloffFrontByte = 0xFF;
        int rloffRelayByte = 0xFF;
        if (rloffFront.isEmpty && rloffRelay.isEmpty) {
          rloffValid = true;
        }
        if (rloffFront.isNotEmpty && rloffRelay.isNotEmpty) {
          rloffFrontByte = int.tryParse(rloffFront, radix: 10) ?? 0xFF;
          rloffRelayByte = int.tryParse(rloffRelay, radix: 10) ?? 0xFF;
          if (rloffFrontByte == 0xFF || rloffRelayByte == 0xFF) {
            rloffFrontByte = 0xFF;
            rloffRelayByte = 0xFF;
          }
          rloffValid = rloffFrontByte != 0xFF && rloffRelayByte != 0xFF;
          if (rloffValid) {
            if (rloffFrontByte == 0x00) {
              addEvent(ri, 1, 5, rloffRelayByte);
            }
            if (rloffFrontByte == 0x01) {
              addEvent(ri, 1, 6, rloffRelayByte);
            }
          }
        }
        shRelayView.getCell(7, y).warning = !rloffValid;
        shRelayView.getCell(8, y).warning = !rloffValid;

        // Time
        bool tonValid = false;
        int tonHByte = 0xFF;
        int tonMByte = 0xFF;
        if (tonH.isEmpty && tonM.isEmpty) {
          tonValid = true;
        }
        if (tonH.isNotEmpty && tonM.isNotEmpty) {
          tonHByte = int.tryParse(tonH, radix: 10) ?? 0xFF;
          tonMByte = int.tryParse(tonM, radix: 10) ?? 0xFF;
          if (tonHByte == 0xFF || tonMByte == 0xFF) {
            tonHByte = 0xFF;
            tonHByte = 0xFF;
          }
          tonValid = tonHByte != 0xFF && tonMByte != 0xFF;
          if (tonValid) {
            addEventTime(ri, 0, 8, tonHByte, tonMByte);
          }
        }
        shRelayView.getCell(9, y).warning = !tonValid;
        shRelayView.getCell(10, y).warning = !tonValid;

        // Time
        bool toffValid = false;
        int toffHByte = 0xFF;
        int toffMByte = 0xFF;
        if (toffH.isEmpty && toffM.isEmpty) {
          toffValid = true;
        }
        if (toffH.isNotEmpty && toffM.isNotEmpty) {
          toffHByte = int.tryParse(toffH, radix: 10) ?? 0xFF;
          toffMByte = int.tryParse(toffM, radix: 10) ?? 0xFF;
          if (toffHByte == 0xFF || toffMByte == 0xFF) {
            toffHByte = 0xFF;
            toffHByte = 0xFF;
          }
          toffValid = toffHByte != 0xFF && toffMByte != 0xFF;
          if (toffValid) {
            addEventTime(ri, 1, 8, toffHByte, toffMByte);
          }
        }
        shRelayView.getCell(11, y).warning = !toffValid;
        shRelayView.getCell(12, y).warning = !toffValid;
      }
    }

    for (int ri = 0; ri < 16; ri++) {
      for (int i = 0; i < 64; i++) {
        if (shEEPROM.getCellValue(1, i) == ri) {
          if (shEEPROM.getCellValue(2, i) == 1 || true) {
            shEEPROM.getCell(10, i).value =
                formatValue(timerValuesByRelay[ri] ?? 255);
          }
        }
      }
    }

    shEEPROM.getCell(1, 0).value = formatValue(compileEEPROMIndex);
    shEEPROM.getCell(2, 0).value =
        shSettings.getCell(1, 1).value == "1" ? "01" : "00";
    shEEPROM.getCell(3, 0).value = shSettings.getCell(1, 2).value;
    shEEPROM.getCell(4, 0).value = shSettings.getCell(1, 3).value;

    fillSwitches();
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

  String displayNameOffTimer(String v) {
    if (v == "") {
      return "нет";
    }

    return "$v мин";
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

    int? switchIndex = int.tryParse(v);
    if (switchIndex != null) {
      return getSwitchName(switchIndex);
    }

    return "выключатель №$v";
  }

  String displayNameRelay(String v) {
    if (v == "") {
      return "";
    }

    int? relayIndex = int.tryParse(v);
    if (relayIndex != null) {
      return getRelayName(relayIndex);
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
    updateRelayNames();

    if (currentDocIndex == relayViewSheetIndex) {
      compileEEPROM();
    }
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
    if (event.logicalKey == LogicalKeyboardKey.f3) {
      currentDocIndex = 2;
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.f4) {
      currentDocIndex = 3;
      return;
    }

    processed = docs[currentDocIndex].processKeyDown(event);
    //print("Processed: $processed");
    processedLastKey = processed;
  }

  Widget buildButton(BuildContext context, String text2, int index) {
    Color col = Settings.backColor;
    if (index == currentDocIndex) {
      col = Settings.selectionColor;
    }
    Sheet doc = docs[index];
    var text1 = doc.displayName;
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
              color: Settings.borderColor,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text1),
              Text(text2),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonSpecial(
    BuildContext context,
    String text1,
    String text2,
    Function(BuildContext context) onClick, {
    bool highlighted = false,
  }) {
    Color col = Settings.backColor;

    if (highlighted) {
      col = Settings.selectionColor;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          onClick(context);
        },
        child: Container(
          width: 120,
          height: 50,
          decoration: BoxDecoration(
            color: col,
            border: Border.all(
              color: Settings.borderColor,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text1),
              Text(text2),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    List<Widget> buttons = [];
    buttons.add(buildButton(context, "F1", 0));
    buttons.add(buildButton(context, "F2", 1));
    buttons.add(buildButton(context, "F3", 2));
    buttons.add(buildButton(context, "F4", 3));

    buttons.add(Expanded(child: Container()));
    buttons.add(buildButtonSpecial(context, "Создать", "", btnNew));
    buttons.add(buildButtonSpecial(context, "Открыть", "Ctrl+O", btnOpen));
    buttons.add(
      buildButtonSpecial(
        context,
        "Сохранить",
        "Ctrl+S",
        btnSave,
        highlighted: hasChanges(),
      ),
    );
    buttons.add(buildButtonSpecial(context, "Сохранить", "как ...", btnSaveAs));
    buttons.add(buildButtonSpecial(context, "Загрузить", "F5", btnDownload));
    buttons.add(buildButtonSpecial(context, "Выгрузить", "F12", btnUpload));
    return Row(
      children: buttons,
    );
  }

  void initDocument() {
    docs = [];
    createRelayView();
    createSwitches();
    createSettings();
    createEEPROMView();
  }

  void loadDocumentFromFile(String fileName) async {
    var value = await File(fileName).readAsString();
    var shRelayView = docs[relayViewSheetIndex];
    var stRelayView = docs[settingsSheetIndex];
    var m = jsonDecode(value);
    Project project = Project.fromJson(m);
    for (int relayIndex = 0; relayIndex < 16; relayIndex++) {
      for (int i = 0; i < 8; i++) {
        int rowIndex = relayIndex * countPerRelay + i;
        RelayViewRow item = project.items[rowIndex];

        shRelayView.getCell(1, rowIndex).value = item.onsw1;
        shRelayView.getCell(2, rowIndex).value = item.onsw2;
        shRelayView.getCell(3, rowIndex).value = item.onrl1;
        shRelayView.getCell(4, rowIndex).value = item.onrl2;

        shRelayView.getCell(5, rowIndex).value = item.offsw1;
        shRelayView.getCell(6, rowIndex).value = item.offsw2;
        shRelayView.getCell(7, rowIndex).value = item.offrl1;
        shRelayView.getCell(8, rowIndex).value = item.offrl2;

        shRelayView.getCell(9, rowIndex).value = item.ontm1;
        shRelayView.getCell(10, rowIndex).value = item.ontm2;
        shRelayView.getCell(11, rowIndex).value = item.offtm1;
        shRelayView.getCell(12, rowIndex).value = item.offtm2;
      }
    }

    for (int settingsIndex = 0; settingsIndex < 16 + 24; settingsIndex++) {
      stRelayView.getCell(1, settingsIndex).value =
          project.settings[settingsIndex];
    }

    currentFileName = fileName;
    lastProjectString = value;
    notifyChanges();
  }

  String getRelayName(int relayIndex) {
    var settingsView = docs[settingsSheetIndex];
    return settingsView.getCell(1, relayIndex).value;
  }

  String getSwitchName(int swIndex) {
    var settingsView = docs[settingsSheetIndex];
    return settingsView.getCell(1, swIndex + 16).value;
  }

  void updateRelayNames() {
    for (int i = 0; i < 16; i++) {
      var shRelayView = docs[relayViewSheetIndex];
      int rowIndex = i * 8;
      shRelayView.getCell(0, rowIndex).value = getRelayName(i);
    }
  }

  String saveDocumentToString() {
    Project project = Project([], []);
    var shRelayView = docs[relayViewSheetIndex];
    var stRelayView = docs[settingsSheetIndex];
    for (int relayIndex = 0; relayIndex < 16; relayIndex++) {
      for (int i = 0; i < 8; i++) {
        int rowIndex = relayIndex * countPerRelay + i;

        RelayViewRow item = project.items[rowIndex];

        item.onsw1 = shRelayView.getCellValueStr(1, rowIndex);
        item.onsw2 = shRelayView.getCellValueStr(2, rowIndex);
        item.onrl1 = shRelayView.getCellValueStr(3, rowIndex);
        item.onrl2 = shRelayView.getCellValueStr(4, rowIndex);

        item.offsw1 = shRelayView.getCellValueStr(5, rowIndex);
        item.offsw2 = shRelayView.getCellValueStr(6, rowIndex);
        item.offrl1 = shRelayView.getCellValueStr(7, rowIndex);
        item.offrl2 = shRelayView.getCellValueStr(8, rowIndex);

        item.ontm1 = shRelayView.getCellValueStr(9, rowIndex);
        item.ontm2 = shRelayView.getCellValueStr(10, rowIndex);
        item.offtm1 = shRelayView.getCellValueStr(11, rowIndex);
        item.offtm2 = shRelayView.getCellValueStr(12, rowIndex);
      }
    }

    for (int settingsIndex = 0; settingsIndex < 16 + 24; settingsIndex++) {
      project.settings[settingsIndex] =
          stRelayView.getCellValueStr(1, settingsIndex);
    }

    /*var encoder = const JsonEncoder.withIndent(" ");
    encoder.convert(project);
    String projectStr = encoder.toString();*/

    String projectStr = jsonEncode(project);
    return projectStr;
  }

  void saveDocumentToFile(String fileName) {
    String projectStr = saveDocumentToString();
    File(fileName).writeAsString(projectStr).then((File file) {});
    currentFileName = fileName;
    lastProjectString = projectStr;
    notifyChanges();
  }

  void btnNew(BuildContext context) {
    initDocument();
    currentFileName = "";
    lastProjectString = "";
    notifyChanges();
  }

  void btnOpen(BuildContext context) async {
    var inputFile = await FilePicker.platform.pickFiles(
      dialogTitle: 'Please select an input file:',
    );

    if (inputFile == null || inputFile.count != 1) {
      return;
    }

    loadDocumentFromFile(inputFile.files[0].path!);
  }

  void btnSave(BuildContext context) async {
    await save(currentFileName);
  }

  Future<void> save(String defaultFile) async {
    String outputFile = defaultFile;
    if (outputFile.isEmpty) {
      String? file = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'project.sss',
      );
      if (file == null) {
        return;
      }
      outputFile = file;
    }

    saveDocumentToFile(outputFile);
  }

  void btnSaveAs(BuildContext context) async {
    save("");
  }

  void btnDownload(BuildContext context) {}

  void btnUpload(BuildContext context) {}

  Widget buildStatus(BuildContext context) {
    String status = currentFileName;
    if (hasChanges()) status += "*";
    return Expanded(child: Text(status));
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(context),
              Expanded(
                child: currentDoc,
              ),
              Container(
                height: 20,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1, color: Settings.borderColor),
                  ),
                  color: Colors.amber.withAlpha(100),
                ),
                child: buildStatus(context),
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
