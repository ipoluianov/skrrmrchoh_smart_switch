import 'package:flutter/material.dart';
import 'package:sss/mainform/mainform.dart';
import 'package:sss/settings.dart';

void main() {
  Settings.setLight();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Settings.brightness,
        primarySwatch: Colors.blue,
      ),
      home: const MainForm(),
    );
  }
}
