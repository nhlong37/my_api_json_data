import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:product_management/home.dart';
import 'package:product_management/listcolor/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: HomeScreen(serverURL: kIsWeb ? "http://127.0.0.1" : "http://10.0.2.2"),
    );
  }
}
