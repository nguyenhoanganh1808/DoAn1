import 'package:flutter/material.dart';
import 'package:generatelivecaption/home.dart';
import 'package:generatelivecaption/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generate Live Caption',
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
