import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sss/context/cell_editor_text.dart';

import 'cell.dart';
import 'cell_editor.dart';
import 'col.dart';

class Doc {
  String displayName = "Tab";
  List<Cell> _cells = [];
  int currentX = 0;
  int currentY = 0;

  List<Col> columns = [];

  void addColumn(String displayName, double width) {
    columns.add(Col(columns.length, displayName, width));
  }

  bool editing_ = false;
  CellEditor? currentEditor;

  void notifyChanges() {
    onUpdate();
  }

  Function onUpdate = () {};
  Function onShowEditDialog = (Cell c) {};
  Function onNeedCloseEditor = () {};

  Function onDefaultFocus = () {};

  void requestDefaultFocus() {
    onDefaultFocus();
  }

  void setCurrentCell(int x, int y) {
    currentX = x;
    currentY = y;
    scrollToItemX(x);
    scrollToItemY(y);
    notifyChanges();
  }

  bool processKeyDown(RawKeyDownEvent event) {
    bool processed = false;
    if (editing_) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        editing_ = false;
        processed = true;
      }
      if (dialogEditorIsActive()) {
        var cell = getCell(currentX, currentY);
        if (cell != null) {
          return cell.processKeyDownEvent(event);
        }
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
        processed = true;

        var cell = getCell(currentX, currentY);
        if (cell != null) {
          if (cell.cellEditorType != Cell.cellEditorTypeNone) {
            editing_ = true;
            if (cell.cellEditorType == Cell.cellEditorTypeSelect) {
              onShowEditDialog(cell);
            }
          }
        }
      }
    }
    notifyChanges();
    return processed;
  }

  int rowCount() {
    int maxRowIndex = -1;
    for (Cell c in _cells) {
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

  Cell setCell(int x, int y, String content) {
    Cell c = Cell(x, y, content);
    c.onNeedCloseEditor = () {
      editing_ = false;
      notifyChanges();
    };
    bool found = false;
    for (int i = 0; i < _cells.length; i++) {
      var c = _cells[i];
      if (c.x == x && c.y == y) {
        _cells[i] = c;
        found = true;
      }
    }
    if (!found) {
      _cells.add(c);
    }
    return c;
  }

  Cell? getCell(int x, int y) {
    for (var c in _cells) {
      if (c.x == x && c.y == y) {
        return c;
      }
    }
    return null;
  }

  bool dialogEditorIsActive() {
    if (!editing_) {
      return false;
    }
    Cell? cell = getCell(currentX, currentY);
    if (cell != null) {
      if (cell.cellEditorType == Cell.cellEditorTypeSelect) {
        return true;
      }
    }
    return false;
  }

  ScrollController hController = ScrollController();
  ScrollController vController = ScrollController();

  void scrollToItemY(int itemIndex) {
    final double itemPosition = itemIndex * rowHeight(0);
    final double scrollPosition = vController.position.pixels;
    final double viewportHeight = vController.position.viewportDimension;

    if (itemPosition < scrollPosition) {
      vController.jumpTo(itemPosition);
    } else if ((itemPosition + rowHeight(0)) >
        (scrollPosition + viewportHeight)) {
      vController.jumpTo(itemPosition + rowHeight(0) - viewportHeight);
    }
  }

  void scrollToItemX(int itemIndex) {
    double itemPosition = 0;
    double itemPositionPlusOne = 0;
    for (int i = 0; i < itemIndex; i++) {
      itemPosition += columns[i].width;
    }
    for (int i = 0; i < itemIndex + 1; i++) {
      itemPositionPlusOne += columns[i].width;
    }
    final double scrollPosition = hController.position.pixels;
    final double viewportWidth = hController.position.viewportDimension;

    if (itemPosition < scrollPosition) {
      hController.jumpTo(itemPosition);
    } else if ((itemPositionPlusOne) > (scrollPosition + viewportWidth)) {
      hController.jumpTo(itemPositionPlusOne - viewportWidth);
    }
  }

  Widget build(
      BuildContext context, double viewportWidth, double viewPortHeight) {
    //return Text("123");
    int rs = rowCount();
    int cs = columnCount();
    List<Widget> rows = [];
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

        BoxBorder border = Border.all(width: 0, color: Colors.transparent);

        if (cell != null) {
          if (x == currentX && y == currentY) {
            border = Border.all(width: 2, color: Colors.blue);
          } else {
            border = Border(
              left: BorderSide(
                color: cell.borderLeft.color,
                width: cell.borderLeft.width,
              ),
              right: BorderSide(
                color: cell.borderRight.color,
                width: cell.borderRight.width,
              ),
              top: BorderSide(
                color: cell.borderTop.color,
                width: cell.borderTop.width,
              ),
              bottom: BorderSide(
                color: cell.borderBottom.color,
                width: cell.borderBottom.width,
              ),
            );
          }

          Widget widget = Container();

          if (x == currentX && y == currentY && editing_) {
            CellEditor? editor = cell.buildEditor(() {
              editing_ = false;
            });
            if (editor == null) {
              Timer.run(() {
                editing_ = false;
                notifyChanges();
              });
            } else {
              if (!editor.inDialog) {
                widget = editor;
              }
            }
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
                  border: border,
                ),
                child: cell.buildViewer(),
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

    docWidget = ScrollbarTheme(
      data: ScrollbarThemeData(
        crossAxisMargin: 0, // Сдвигаем Scrollbar ближе к контенту
        thumbVisibility:
            MaterialStateProperty.all(true), // Всегда показываем ползунок
        thickness: MaterialStateProperty.all(20), // Толщина ползунка
        radius: Radius.circular(3), // Радиус скругления ползунка
      ),
      // Виджет Scrollbar
      child: Scrollbar(
        controller: vController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: vController,
          child: docWidget,
        ),
      ),
    );

    double w = docWidth();
    if (viewportWidth > w) {
      w = viewportWidth;
    }

    Widget fullWidget = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: w,
            child: headerRow,
          ),
          Expanded(
            child: SizedBox(
              width: w,
              child: docWidget,
            ),
          ),
        ],
      ),
    );

    Widget editorDialog = Container();

    if (dialogEditorIsActive()) {
      var cell = getCell(currentX, currentY);
      if (cell != null) {
        editorDialog = Center(
          child: Container(
            width: viewportWidth / 2,
            height: viewPortHeight / 2,
            color: Colors.cyan,
            child: cell.buildEditor(() {
              editing_ = false;
            }),
          ),
        );
      }
    }

    return Stack(
      children: [
        Container(
          width: viewportWidth,
          color: Colors.yellow.withOpacity(0.1),
          child: Container(
            child: Scrollbar(
              controller: hController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: hController,
                child: fullWidget,
              ),
            ),
          ),
        ),
        editorDialog,
      ],
    );
  }
}
