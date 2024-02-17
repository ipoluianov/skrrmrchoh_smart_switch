import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'cell.dart';
import 'col.dart';

class Doc {
  String displayName = "Tab";
  List<Cell> cells = [];
  int currentX = 0;
  int currentY = 0;

  List<Col> columns = [];

  void addColumn(String displayName, double width) {
    columns.add(Col(columns.length, displayName, width));
  }

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
    scrollToItem(y);
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
    return columns.length;
  }

  double columnWidth(int index) {
    return columns[index].width;
  }

  double rowHeight(int index) {
    return 30;
  }

  double docWidth() {
    double result = 0;
    for (int i = 0; i < columnCount(); i++) {
      result += columns[i].width;
    }
    return result;
  }

  Cell? getCell(int x, int y) {
    for (var c in cells) {
      if (c.x == x && c.y == y) {
        return c;
      }
    }
    return null;
  }

  ScrollController hController = ScrollController();
  ScrollController vController = ScrollController();

  void scrollToItem(int itemIndex) {
    final double itemPosition = itemIndex * rowHeight(0);
    final double scrollPosition = vController.position.pixels;
    final double viewportHeight = vController.position.viewportDimension;

    if (itemPosition < scrollPosition) {
      // Элемент находится выше видимой области, прокрутим вверх
      vController.jumpTo(itemPosition);
    } else if ((itemPosition + rowHeight(0)) >
        (scrollPosition + viewportHeight)) {
      // Элемент находится ниже видимой области, прокрутим вниз
      // Прокрутим так, чтобы элемент оказался внизу видимой области
      vController.jumpTo(itemPosition + rowHeight(0) - viewportHeight);
    }
  }

  Widget build(BuildContext context, double viewportWidth) {
    //return Text("123");
    int rs = rowCount();
    int cs = columnCount();
    List<Widget> rows = [];
    Color borderColor = Colors.white10;
    List<Widget> cellsInHeaderRow = [];
    for (int x = 0; x < cs; x++) {
      cellsInHeaderRow.add(
        SizedBox(
          width: columnWidth(x),
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Text(columns[x].displayName),
          ),
        ),
      );
    }
    Widget headerRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cellsInHeaderRow,
    );

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
              onTap: () {},
              onTapDown: (details) {
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
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cellsInRow,
        ),
      );
    }
    Widget docWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );

    //print(viewportWidth);

    docWidget = Scrollbar(
      controller: vController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: vController,
        child: docWidget,
      ),
    );

    Widget fullWidget = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //headerRow,
          Expanded(
            child: docWidget,
          ),
        ],
      ),
    );

    return Container(
      child: Scrollbar(
        controller: hController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: hController,
          child: fullWidget,
        ),
      ),
    );
  }
}
