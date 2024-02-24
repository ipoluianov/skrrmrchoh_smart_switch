import 'package:flutter/material.dart';
import 'package:sss/settings.dart';

import 'cell.dart';
import 'cell_editor.dart';

class CellEditorText extends CellEditor {
  final Function() onAccept;

  const CellEditorText(Cell c, this.onAccept, {super.key}) : super(c, false);

  @override
  State<StatefulWidget> createState() {
    return CellEditorTextState();
  }
}

class CellEditorTextState extends State<CellEditorText> {
  @override
  void initState() {
    super.initState();
    currentTextEditingController_.text = widget.cell.value;
    currentFocusNode_.requestFocus();
    currentTextEditingController_.selection = TextSelection(
        baseOffset: 0, extentOffset: currentTextEditingController_.text.length);
  }

  @override
  void dispose() {
    super.dispose();
  }

  FocusNode currentFocusNode_ = FocusNode();
  TextEditingController currentTextEditingController_ = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: currentTextEditingController_,
      focusNode: currentFocusNode_,
      style: const TextStyle(
        fontSize: 12,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Settings.backColor,
        contentPadding: const EdgeInsets.all(0),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
      ),
      onSubmitted: (value) {
        widget.cell.value = value;
        widget.onAccept();
      },
    );
  }
}
