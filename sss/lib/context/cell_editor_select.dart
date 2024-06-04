import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sss/context/cell_editor.dart';
import 'package:sss/settings.dart';

import 'cell.dart';

class CellEditorSelect extends CellEditor {
  final List<CellEditorSelectItem> items;
  final String header;
  const CellEditorSelect(Cell c, this.header, this.items, {super.key})
      : super(c, true);

  @override
  State<StatefulWidget> createState() {
    return CellEditorSelectState();
  }
}

class CellEditorSelectItem {
  LogicalKeyboardKey? shortcut;
  String value;
  //String displayName;
  CellEditorSelectItem(this.value, this.shortcut);
}

class CellEditorSelectState extends State<CellEditorSelect> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.items.length; i++) {
      if (widget.items[i].value == widget.cell.value) {
        currentIndex = i;
        Timer.run(() {
          scrollToItemY(currentIndex);
        });
        break;
      }
    }
    widget.cell.onKeyDownEvent = (event) {
      Set<LogicalKeyboardKey> activeKeys = {};
      for (int i = 0; i < widget.items.length; i++) {
        if (widget.items[i].shortcut != null) {
          activeKeys.add(widget.items[i].shortcut!);
        }
      }
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        selectItem(currentIndex);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          if (currentIndex < widget.items.length - 1) {
            currentIndex++;
            scrollToItemY(currentIndex);
          }
        });
      }

      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          if (currentIndex > 0) {
            currentIndex--;
            scrollToItemY(currentIndex);
          }
        });
      }
      if (activeKeys.contains(event.logicalKey)) {
        for (int i = 0; i < widget.items.length; i++) {
          if (widget.items[i].shortcut == event.logicalKey) {
            selectItem(i);
            return true;
          }
        }
      }
      return false;
    };
  }

  void selectItem(int index) {
    widget.cell.value = widget.items[index].value;
    widget.cell.closeEditor();
  }

  String rrr = "";

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildItem(CellEditorSelectItem item, int index) {
    Color col = Colors.transparent;
    if (index == currentIndex) {
      col = Settings.selectionColor;
    }
    return SizedBox(
      height: rowHeight,
      child: Listener(
        onPointerDown: (event) {
          setState(() {
            currentIndex = index;
            scrollToItemY(currentIndex);
          });
        },
        child: GestureDetector(
          onDoubleTap: () {
            selectItem(index);
            scrollToItemY(currentIndex);
          },
          child: Container(
            color: col,
            padding: const EdgeInsets.all(3),
            child: Text(
              widget.cell.displayNameSource(item.value),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList() {
    List<Widget> wItems = [];
    for (int i = 0; i < widget.items.length; i++) {
      wItems.add(buildItem(widget.items[i], i));
    }
    return Expanded(
      child: Scrollbar(
        thumbVisibility: true,
        controller: vController,
        child: ListView(
          controller: vController,
          children: wItems,
        ),
      ),
    );
  }

  ScrollController vController = ScrollController();

  double rowHeight = 40;

  void scrollToItemY(int itemIndex) {
    final double itemPosition = itemIndex * rowHeight;
    final double scrollPosition = vController.position.pixels;
    final double viewportHeight = vController.position.viewportDimension;

    if (itemPosition < scrollPosition) {
      vController.jumpTo(itemPosition);
    } else if ((itemPosition + rowHeight) > (scrollPosition + viewportHeight)) {
      vController.jumpTo(itemPosition + rowHeight - viewportHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Settings.backColor,
          border: Border.all(
            color: Settings.borderColor,
            width: 2,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Text(widget.header),
          ),
          buildList(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: OutlinedButton(
                  onPressed: () {
                    selectItem(currentIndex);
                  },
                  child: const SizedBox(
                    width: 70,
                    child: Center(
                      child: Text("OK"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: OutlinedButton(
                  onPressed: () {
                    widget.cell.closeEditor();
                  },
                  child: const SizedBox(
                    width: 70,
                    child: Center(
                      child: Text("Cancel"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
