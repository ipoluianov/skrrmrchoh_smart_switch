import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cell.dart';
import 'cell_editor.dart';
import 'col.dart';

class Sheet {
  String displayName = "Tab";
  List<Cell> _cells = [];
  int currentX = 0;
  int currentY = 0;

  List<Col> columns = [];
  List<Col> topHeaderColumns = [];

  void addColumn(String displayName, double width) {
    columns.add(Col(columns.length, displayName, width));
  }

  void addTopHeaderColumn(String displayName, double width) {
    topHeaderColumns.add(Col(columns.length, displayName, width));
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
    var cell = getCell(currentX, currentY);
    if (editing_) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        editing_ = false;
        processed = true;
      }
      if (dialogEditorIsActive()) {
        return cell.processKeyDownEvent(event);
      }
    } else {
      if (event.logicalKey == LogicalKeyboardKey.backspace ||
          event.logicalKey == LogicalKeyboardKey.delete) {
        if (cell.defaultValue != "!#NO#!") {
          cell.value = cell.defaultValue;
          notifyChanges();
          processed = true;
        }
      }

      for (var item in cell.shortcuts) {
        if (item.key == event.logicalKey) {
          cell.value = item.value;
          notifyChanges();
          processed = true;
          break;
        }
      }

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

        if (cell.cellEditorType != Cell.cellEditorTypeNone) {
          editing_ = true;
          if (cell.cellEditorType == Cell.cellEditorTypeSelect) {
            onShowEditDialog(cell);
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

  double sheetWidth() {
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

  Cell getCell(int x, int y) {
    for (var c in _cells) {
      if (c.x == x && c.y == y) {
        return c;
      }
    }
    return Cell(x, y, "");
  }

  bool dialogEditorIsActive() {
    if (!editing_) {
      return false;
    }
    Cell cell = getCell(currentX, currentY);
    if (cell.cellEditorType == Cell.cellEditorTypeSelect) {
      return true;
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

    for (int y = 0; y < rs; y++) {
      List<Widget> cellsInRow = [];
      for (int x = 0; x < cs; x++) {
        var cell = getCell(x, y);

        Widget widget = Container();
        if (x == currentX && y == currentY && editing_) {
          widget = buildEditor();
        } else {
          widget = buildCellViewer(cell);
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
      }

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cellsInRow,
        ),
      );
    }

    // Place rows to column of widgets
    Widget sheetWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );

    // Cover rows with Vertical Scroll View
    sheetWidget = ScrollbarTheme(
      data: ScrollbarThemeData(
        crossAxisMargin: 0,
        thumbVisibility: MaterialStateProperty.all(true),
        thickness: MaterialStateProperty.all(20),
        radius: const Radius.circular(3),
      ),
      child: Scrollbar(
        controller: vController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: vController,
          child: sheetWidget,
        ),
      ),
    );

    double w = sheetWidth();
    if (viewportWidth > w) {
      w = viewportWidth;
    }

    // Full Widget is
    // - Header
    // - Rows
    Widget fullWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: w,
          child: buildTopHeaderRow(),
        ),
        SizedBox(
          width: w,
          child: buildHeaderRow(),
        ),
        Expanded(
          child: SizedBox(
            width: w,
            child: sheetWidget,
          ),
        ),
      ],
    );

    // Sheet area
    // Stack of
    // - content
    // - edit dialog
    return Stack(
      children: [
        Container(
          width: viewportWidth,
          color: Colors.yellow.withOpacity(0.1),
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
        buildEditorDialog(viewportWidth * 0.75, viewPortHeight * 0.75),
      ],
    );
  }

  BoxBorder buildCellBorder(Cell cell) {
    BoxBorder border = Border.all(width: 0, color: Colors.transparent);
    if (cell.x == currentX && cell.y == currentY) {
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
    return border;
  }

  Widget buildCellViewer(Cell cell) {
    Widget widget = MouseRegion(
      onEnter: (event) {
        cell.hover = true;
        notifyChanges();
      },
      onExit: (event) {
        cell.hover = true;
        notifyChanges();
      },
      child: Listener(
        onPointerDown: (event) {
          setCurrentCell(cell.x, cell.y);
          editing_ = false;
        },
        child: GestureDetector(
          onDoubleTap: () {
            setCurrentCell(cell.x, cell.y);
            editing_ = true;
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white24,
              border: buildCellBorder(cell),
            ),
            child: cell.buildViewer(),
          ),
        ),
      ),
    );
    return widget;
  }

  Widget buildEditor() {
    Cell cell = getCell(currentX, currentY);

    if (cell.cellEditorType == Cell.cellEditorTypeSelect) {
      return Container();
    }
    Widget? editor = cell.buildEditor(columns[currentX].displayName, () {
      editing_ = false;
    });
    if (editor == null) {
      Timer.run(() {
        editing_ = false;
        notifyChanges();
      });
    }
    editor ??= Container();
    return editor;
  }

  Widget buildTopHeaderRow() {
    List<Widget> cellsInHeaderRow = [];
    for (int x = 0; x < topHeaderColumns.length; x++) {
      cellsInHeaderRow.add(
        SizedBox(
          width: topHeaderColumns[x].width,
          height: 20,
          child: Padding(
            padding: EdgeInsets.only(left: 0, right: 20),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.white30,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(0),
              child: Text(topHeaderColumns[x].displayName),
            ),
          ),
        ),
      );
    }
    Widget headerRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cellsInHeaderRow,
    );
    return headerRow;
  }

  Widget buildHeaderRow() {
    List<Widget> cellsInHeaderRow = [];
    for (int x = 0; x < columnCount(); x++) {
      cellsInHeaderRow.add(
        SizedBox(
          width: columnWidth(x),
          height: 30,
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
    return headerRow;
  }

  // Prepare editor dialog
  Widget buildEditorDialog(double width, double height) {
    Widget editorDialog = Container();
    if (dialogEditorIsActive()) {
      var cell = getCell(currentX, currentY);

      editorDialog = Center(
        child: Container(
          width: width,
          height: height,
          color: Colors.black38,
          child: cell.buildEditor(columns[currentX].displayName, () {
            editing_ = false;
          }),
        ),
      );
    }
    return editorDialog;
  }
}
