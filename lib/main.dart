import 'package:flutter/material.dart';
import 'package:flutter_template/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: getTheme(),
      darkTheme: getTheme(brightness: Brightness.dark),
      home: const HomePage(),
    );
  }

  ThemeData getTheme({
    Color seedColor = Colors.blue,
    Brightness brightness = Brightness.light,
  }) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
      useMaterial3: true,
    );
  }
}
