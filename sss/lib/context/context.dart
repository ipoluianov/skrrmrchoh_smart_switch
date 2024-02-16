import 'package:flutter/services.dart';

class Context {
  static final Context _instance = Context._internal();

  factory Context() {
    return _instance;
  }

  Context._internal() {
    // init
  }

  Function onUpdate = () {};
  Function onRequestDefaultFocus = () {};

  bool processedLastKey = false;

  void notifyChanges() {
    onUpdate();
  }

  void requestDefaultFocus() {
    onRequestDefaultFocus();
  }

  void processKeyDown(RawKeyDownEvent event) {
    bool processed = false;
    if (event.logicalKey == LogicalKeyboardKey.f1) {
      print("F1");
      processed = true;
    }
    processedLastKey = processed;
  }
}
