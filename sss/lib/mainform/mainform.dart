import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sss/context/context.dart';

import '../context/cell.dart';

class MainForm extends StatefulWidget {
  const MainForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return MainFormState();
  }
}

class MainFormState extends State<MainForm> {
  FocusNode focusNode = FocusNode();
  Context ctx1 = Context();
  Context ctx2 = Context();

  int currentDoc = 0;

  @override
  void initState() {
    super.initState();

    ctx1.onUpdate = () {
      setState(() {});
    };
    ctx2.onUpdate = () {
      setState(() {});
    };

    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < 10; x++) {
        ctx1.cells.add(Cell(x, y, "item $x $y"));
      }
    }

    ctx1.getCell(5, 5)!.borderWidth = 1;
    ctx1.getCell(5, 5)!.borderColor = Colors.red;

    for (int y = 0; y < 5; y++) {
      for (int x = 0; x < 5; x++) {
        ctx2.cells.add(Cell(x, y, "item $x $y"));
      }
    }

    ctx2.getCell(2, 2)!.borderWidth = 1;
    ctx2.getCell(2, 2)!.borderColor = Colors.red;

    RawKeyboard.instance.addListener(_handleKey);
  }

  void _handleKey(RawKeyEvent event) {
    //print("_handleKey ${event.logicalKey}");

    Context ctx = ctx1;
    if (currentDoc == 0) {
      ctx = ctx1;
    }
    if (currentDoc == 1) {
      ctx = ctx2;
    }

    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.f1) {
        setState(() {
          currentDoc = 0;
        });
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.f2) {
        setState(() {
          currentDoc = 1;
        });
        return;
      }

      setState(() {
        ctx.processKeyDown(event);
      });
    }
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKey);
    super.dispose();
  }

  Widget buildContent(BuildContext context) {
    Context ctx = ctx1;
    if (currentDoc == 0) {
      ctx = ctx1;
    }
    if (currentDoc == 1) {
      ctx = ctx2;
    }
    //print("MainForm Build State:");
    return Column(
      children: [
        OutlinedButton(
            onPressed: () {
              setState(() {
                currentDoc = 0;
              });
            },
            child: Text("DOC1")),
        OutlinedButton(
            onPressed: () {
              setState(() {
                currentDoc = 1;
              });
            },
            child: Text("DOC2")),
        Focus(
          focusNode: focusNode,
          onKey: (node, event) {
            if (ctx.processedLastKey) return KeyEventResult.handled;
            return KeyEventResult.ignored;
          },
          child: ctx.build(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Container(
          color: Colors.white12,
          child: buildContent(context),
        ),
      ),
    );
  }
}
