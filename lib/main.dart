import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whatsapp Screen Saver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

// $2y$10$ME6xzJAaxIJpQVKsTaw9jOTJsm3SC4CFBjlnMyR07NL4uOlWQYoYq
// $2y$10$K7cc0U4jkdYaAqpBmk6kPu/Hr63a24/TRGMoodkQVwqa/quSBLxou

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
