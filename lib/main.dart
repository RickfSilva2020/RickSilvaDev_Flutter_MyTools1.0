import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RF ToolTec',
      theme: ThemeData(
        primarySwatch: Colors.green, // Cor primária para o tema
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
    );
  }
}
