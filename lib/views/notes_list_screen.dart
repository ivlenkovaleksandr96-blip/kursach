// lib/views/notes_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/notes_viewmodel.dart';
import '../widgets/note_card.dart';
import 'add_edit_note_screen.dart';
import '../models/note_model.dart'; // Импортируем модель

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем ViewModel один раз, чтобы не пересоздавать его
    final notesViewModel = Provider.of<NotesViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой дневник'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                // Вызываем метод поиска из ViewModel
                notesViewModel.searchNotes(value);
              },
              decoration: InputDecoration(
                hintText: 'Поиск...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: Consumer<NotesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.notes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.notes.isEmpty) {
            return const Center(
              child: Text(
                'Записей не найдено.\nНажмите "+", чтобы добавить первую.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: viewModel.notes.length,
            itemBuilder: (context, index) {
              final note = viewModel.notes[index];
              return NoteCard(
                note: note,
                onTap: () {
                  // При нажатии на карточку переходим на экран редактирования
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddEditNoteScreen(note: note),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // При нажатии на "+" переходим на экран создания
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
