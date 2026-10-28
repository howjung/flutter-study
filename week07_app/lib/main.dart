import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'note_store.dart';
import 'screens/subject_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(NoteApp(store: NoteStore(prefs)));
}

class NoteApp extends StatelessWidget {
  final NoteStore store;

  const NoteApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '필기 모아보기',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: SubjectListScreen(store: store),
    );
  }
}
