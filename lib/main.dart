import 'package:flutter/material.dart';
import 'package:butik_stylish/screens/home_page.dart';
import 'package:butik_stylish/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Butik Stylish',
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
