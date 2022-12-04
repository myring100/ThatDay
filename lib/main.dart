import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:that_day/screen/firstPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'That Day(D-Day)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirstPage(null),
    );
  }
}
