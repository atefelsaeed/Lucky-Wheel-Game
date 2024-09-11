import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucky_draw/screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: LuckyDrawApp()));
}

class LuckyDrawApp extends StatelessWidget {
  const LuckyDrawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lucky Draw Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LuckyDrawGame(),
    );
  }
}
