import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cell.dart';
import 'doc.dart';

class Context {
  Context() {
    var doc = addDoc();
    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < 10; x++) {
        doc.cells.add(Cell(x, y, "item $x $y"));
      }
    }

    doc.getCell(5, 5)!.borderWidth = 1;
    doc.getCell(5, 5)!.borderColor = Colors.red;
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

  Widget buildHeader(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.green,
    );
  }

  ScrollController hController = ScrollController();
  ScrollController vController = ScrollController();

  Widget build(BuildContext context) {
    Widget currentDoc = Container();
    if (currentDocIndex >= 0 && currentDocIndex < docs.length) {
      currentDoc = docs[currentDocIndex].build(context);
    }

    currentDoc = Scrollbar(
      controller: vController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: vController,
        child: Scrollbar(
          controller: hController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: hController,
            scrollDirection: Axis.horizontal,
            child: currentDoc,
          ),
        ),
      ),
    );

    return Row(
      children: [
        Container(color: Colors.yellow, width: 50),
        Expanded(
          child: Column(
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
        ),
        Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          thickness: 20,
          child: Container(
            width: 40,
            //height: 100,
            color: Colors.red.withOpacity(0.3),
          ),
          controller: vController,
        ),
        Container(color: Colors.purple, width: 50),
      ],
    );
  }
}
