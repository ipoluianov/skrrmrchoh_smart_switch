import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sss/context/cell_editor.dart';

import 'cell.dart';

class CellEditorSelect extends CellEditor {
  final List<CellEditorSelectItem> items;
  const CellEditorSelect(Cell c, this.items, {super.key}) : super(c, true);

  @override
  State<StatefulWidget> createState() {
    return CellEditorSelectState();
  }
}

class CellEditorSelectItem {
  LogicalKeyboardKey? shortcut;
  String displayName;
  CellEditorSelectItem(this.displayName, this.shortcut);
}

class CellEditorSelectState extends State<CellEditorSelect> {
  @override
  void initState() {
    super.initState();

    widget.cell.onKeyDownEvent = (event) {
      Set<LogicalKeyboardKey> activeKeys = {};
      for (int i = 0; i < widget.items.length; i++) {
        if (widget.items[i].shortcut != null) {
          activeKeys.add(widget.items[i].shortcut!);
        }
      }
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        setState(() {
          rrr = "123";
        });
        return true;
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
    widget.cell.content = widget.items[index].displayName;
    widget.cell.closeEditor();
  }

  String rrr = "";

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildItem(CellEditorSelectItem item) {
    return Text(item.displayName);
  }

  Widget buildList() {
    List<Widget> wItems = [];
    for (int i = 0; i < widget.items.length; i++) {
      wItems.add(buildItem(widget.items[i]));
    }
    return Column(
      children: wItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildList();
  }
}
