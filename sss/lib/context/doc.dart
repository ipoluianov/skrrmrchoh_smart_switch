import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cell.dart';

class Doc {
  List<Cell> cells = [];
  int currentX = 0;
  int currentY = 0;

  bool editing_ = false;
  FocusNode currentFocusNode_ = FocusNode();
  TextEditingController currentTextEditingController_ = TextEditingController();

  void notifyChanges() {
    onUpdate();
  }

  Function onUpdate = () {};

  void setCurrentCell(int x, int y) {
    currentX = x;
    currentY = y;
    notifyChanges();
  }

  bool processKeyDown(RawKeyDownEvent event) {
    bool processed = false;
    if (editing_) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        editing_ = false;
        processed = true;
      }
    } else {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (currentY > 0) {
          setCurrentCell(currentX, currentY - 1);
        }
        processed = true;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (currentY < rowCount() - 1) {
          setCurrentCell(currentX, currentY + 1);
        }
        processed = true;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (currentX > 0) {
          setCurrentCell(currentX - 1, currentY);
        }
        processed = true;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (currentX < columnCount() - 1) {
          setCurrentCell(currentX + 1, currentY);
        }
        processed = true;
      }
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        editing_ = true;
        processed = true;

        var cell = getCell(currentX, currentY);
        if (cell != null) {
          currentTextEditingController_.text = cell.content;
          Timer.run(() {
            currentFocusNode_.requestFocus();
          });
        }
      }
    }
    notifyChanges();
    return processed;
  }

  int rowCount() {
    int maxRowIndex = -1;
    for (Cell c in cells) {
      if (c.y > maxRowIndex) {
        maxRowIndex = c.y;
      }
    }
    return maxRowIndex + 1;
  }

  int columnCount() {
    int maxColumnIndex = -1;
    for (Cell c in cells) {
      if (c.x > maxColumnIndex) {
        maxColumnIndex = c.x;
      }
    }
    return maxColumnIndex + 1;
  }

  double columnWidth(int index) {
    return 100;
  }

  double rowHeight(int index) {
    return 30;
  }

  Cell? getCell(int x, int y) {
    for (var c in cells) {
      if (c.x == x && c.y == y) {
        return c;
      }
    }
    return null;
  }

  Widget build(BuildContext context) {
    int rs = rowCount();
    int cs = columnCount();
    List<Widget> rows = [];
    Color borderColor = Colors.white10;
    for (int y = 0; y < rs; y++) {
      List<Widget> cellsInRow = [];
      for (int x = 0; x < cs; x++) {
        var cell = getCell(x, y);

        if (cell != null) {
          if (x == currentX && y == currentY) {
            borderColor = Colors.blue;
          } else {
            borderColor = cell.borderColor;
          }

          Widget widget = Container();

          if (x == currentX && y == currentY && editing_) {
            widget = TextField(
              controller: currentTextEditingController_,
              focusNode: currentFocusNode_,
              onSubmitted: (value) {
                var cell = getCell(currentX, currentY);
                if (cell != null) {
                  cell.content = value;
                }
                editing_ = false;
              },
            );
          } else {
            widget = GestureDetector(
              onTap: () {
                setCurrentCell(x, y);
                editing_ = false;
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white24,
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Text(cell.content),
              ),
            );
          }

          cellsInRow.add(
            SizedBox(
              width: columnWidth(x),
              height: rowHeight(y),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: widget,
              ),
            ),
          );
        } else {
          cellsInRow.add(Container());
        }
      }
      rows.add(Row(
        children: cellsInRow,
      ));
    }
    return Column(
      children: rows,
    );
  }
}
