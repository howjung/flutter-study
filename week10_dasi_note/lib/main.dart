import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DasiNoteApp());
}

class DasiNoteApp extends StatelessWidget {
  const DasiNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '다시노트',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomeScreen(),
    );
  }
}
