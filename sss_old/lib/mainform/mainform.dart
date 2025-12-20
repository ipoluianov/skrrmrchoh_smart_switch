import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sss/context/context.dart';
import 'package:sss/settings.dart';

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

    ctx.onDefaultFocus = () {
      Timer.run(() {
        focusNode.requestFocus();
      });
    };

    Timer.run(() {
      focusNode.requestFocus();
    });
    RawKeyboard.instance.addListener(_handleKey);
  }

  void _handleKey(RawKeyEvent event) {
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Focus(
      focusNode: focusNode,
      onKey: (node, event) {
        if (ctx.processedLastKey) return KeyEventResult.handled;
        return KeyEventResult.ignored;
      },
      child: Container(
        child: ctx.build(context, screenWidth, screenHeight),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Settings.backColor,
        child: Container(
          child: buildContent(context),
        ),
      ),
    );
  }
}
