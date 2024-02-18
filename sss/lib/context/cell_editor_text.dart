import 'package:flutter/material.dart';

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
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.black,
        contentPadding: EdgeInsets.all(0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
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
