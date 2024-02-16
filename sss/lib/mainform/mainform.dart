import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sss/context/context.dart';
import 'package:sss/tabEEPROM/tab_eeprom.dart';

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

    RawKeyboard.instance.addListener(_handleKey);
  }

  void _handleKey(RawKeyEvent event) {
    //print("_handleKey ${event.logicalKey}");

    if (event is RawKeyDownEvent) {
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
    //print("MainForm Build State:");
    return Focus(
      focusNode: focusNode,
      onKey: (node, event) {
        if (Context().processedLastKey) return KeyEventResult.handled;
        return KeyEventResult.ignored;
      },
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: TabEEPROM(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            child: Text("BOTTOM"),
          ),
        ],
      ),
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
