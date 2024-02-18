import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sss/context/cell_editor_select.dart';

import 'cell.dart';
import 'doc.dart';

class Context {
  Context() {
    {
      var doc = addDoc();
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

      doc.displayName = "EEPROM";
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
              CellEditorSelectItem("1", "1. --- 111 ---", null),
              CellEditorSelectItem("2", "2. Реле номер пять", null),
              CellEditorSelectItem("3", "3. Входная дверь1", null),
              CellEditorSelectItem("4", "4. Входная дверь2", null),
              CellEditorSelectItem("5", "5. Входная дверь3", null),
              CellEditorSelectItem("6", "6. Входная дверь4", null),
              CellEditorSelectItem("7", "7. Входная дверь5", null),
              CellEditorSelectItem("8", "8. Входная дверь6", null),
              CellEditorSelectItem("9", "9. Входная дверь7", null),
              CellEditorSelectItem("10", "10. Входная дверь8", null),
              CellEditorSelectItem("11", "11. Входная дверь9", null),
            ];
          }
        }
      }
    }
    {
      var doc = addDoc();
      doc.displayName = "Relay View";
      for (int y = 0; y < 5; y++) {
        for (int x = 0; x < 5; x++) {
          doc.setCell(x, y, "111");
        }
      }
    }
  }

  Doc addDoc() {
    Doc doc = Doc();
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

  Function onUpdate = () {};
  Function onShowEditDialog = (Cell c) {};
  Function onDefaultFocus = () {};

  void requestDefaultFocus() {
    onDefaultFocus();
  }

  List<Doc> docs = [];
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
    Doc doc = docs[index];
    return GestureDetector(
      onTap: () {
        currentDocIndex = index;
        notifyChanges();
      },
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: col,
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Container(
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
