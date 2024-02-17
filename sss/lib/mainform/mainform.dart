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
  Context ctx = Context();

  @override
  void initState() {
    super.initState();

    ctx.onUpdate = () {
      setState(() {});
    };

    RawKeyboard.instance.addListener(_handleKey);
  }

  void _handleKey(RawKeyEvent event) {
    //print("_handleKey ${event.logicalKey}");
    setState(() {
      if (event is RawKeyDownEvent) {
        ctx.processKeyDown(event);
      }
    });
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKey);
    super.dispose();
  }

  Widget buildContent(BuildContext context) {
    //print("MainForm Build State:");
    return Focus(
      focusNode: focusNode,
      onKey: (node, event) {
        if (ctx.processedLastKey) return KeyEventResult.handled;
        return KeyEventResult.ignored;
      },
      child: Expanded(
        child: ctx.build(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Container(
          child: buildContent(context),
        ),
      ),
    );
  }
}
