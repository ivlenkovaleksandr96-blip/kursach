// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/notes_viewmodel.dart';
import 'views/notes_list_screen.dart';

void main() {
  // Убеждаемся, что Flutter инициализирован перед запуском асинхронных операций
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider должен быть в корне, чтобы ViewModel был доступен всем экранам
    return ChangeNotifierProvider(
      create: (context) => NotesViewModel(),
      child: MaterialApp(
        title: 'Личный дневник',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const NotesListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
