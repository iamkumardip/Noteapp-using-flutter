import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noteapp/pages/notes_page.dart';
import 'dart:ffi';

void main()  {
  /*WidgetsFlutterBinding.ensureInitialized;
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Notes SQLite',
      debugShowCheckedModeBanner: false,
      //themeMode: ThemeMode.dark,
      
      home: NotesPage(),
    );
  }
}

