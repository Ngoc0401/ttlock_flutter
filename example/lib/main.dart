import 'package:flutter/material.dart';
import 'package:ttlock_flutter_example/cam.dart';
import 'home_page.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginApp(),
    );
  }
}
