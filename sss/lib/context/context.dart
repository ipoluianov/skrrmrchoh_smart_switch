import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cell.dart';
import 'doc.dart';

class Context {
  Context() {
    {
      var doc = addDoc();
      doc.addColumn("Index", 50);
      doc.addColumn("Relay Number", 100);
      doc.addColumn("Action", 200);
      doc.addColumn("Switch Falling Edge", 100);
      doc.addColumn("Switch Rising Edge", 100);
      doc.addColumn("Relay Falling Edge", 100);
      doc.addColumn("Relay Rising Edge", 100);
      doc.addColumn("Switch Double Click", 100);
      doc.addColumn("Time Hours", 100);
      doc.addColumn("Time Minutes", 100);
      doc.addColumn("Time Value", 100);

      doc.displayName = "EEPROM";
      for (int y = 0; y < 64; y++) {
        doc.cells.add(Cell(0, y, "$y"));
      }
      for (int y = 0; y < 64; y++) {
        for (int x = 1; x < 11; x++) {
          doc.cells.add(Cell(x, y, "FF"));
        }
      }
    }
    {
      var doc = addDoc();
      doc.displayName = "Relay View";
      for (int y = 0; y < 5; y++) {
        for (int x = 0; x < 5; x++) {
          doc.cells.add(Cell(x, y, "item $x $y"));
        }
      }
    }
  }

  Doc addDoc() {
    Doc doc = Doc();
    docs.add(doc);
    doc.onUpdate = notifyChanges;
    return doc;
  }

  Function onUpdate = () {};
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

    docs[currentDocIndex].processKeyDown(event);
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

  Widget build(BuildContext context) {
    Widget currentDoc = Container();
    if (currentDocIndex >= 0 && currentDocIndex < docs.length) {
      currentDoc = docs[currentDocIndex].build(context);
    }

    //return Container(color: Colors.yellow, width: 50);

    return Row(
      children: [
        Container(color: Colors.yellow, width: 50),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(context),
              Expanded(
                child: currentDoc,
              ),
              Container(
                height: 50,
                color: Colors.blue,
              ),
            ],
          ),
          //Text("qqq"),
        ),
        Container(color: Colors.purple, width: 50),
      ],
    );
  }
}
