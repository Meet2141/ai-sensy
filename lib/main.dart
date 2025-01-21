import 'package:aisensy/src/core/constants/string_constants.dart';
import 'package:aisensy/src/features/home/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StringConstants.appName,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
