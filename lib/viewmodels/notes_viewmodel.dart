// lib/viewmodels/notes_viewmodel.dart

import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/database_helper.dart';

class NotesViewModel extends ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  NotesViewModel() {
    loadNotes();
  }

  // Метод для загрузки ВСЕХ записей
  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();
    _notes = await DatabaseHelper.instance.readAllNotes();
    _isLoading = false;
    notifyListeners();
  }

  // Новый метод для ПОИСКА записей через базу данных
  Future<void> searchNotes(String query) async {
    _isLoading = true;
    notifyListeners();
    if (query.isEmpty) {
      // Если запрос пустой, загружаем все записи
      await loadNotes();
    } else {
      // Иначе, выполняем поиск в БД
      _notes = await DatabaseHelper.instance.searchNotes(query);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await DatabaseHelper.instance.create(note);
    await loadNotes(); // Перезагружаем все записи, чтобы список был актуален
  }

  Future<void> updateNote(Note note) async {
    await DatabaseHelper.instance.update(note);
    await loadNotes(); // Перезагружаем
  }

  Future<void> deleteNote(int id) async {
    await DatabaseHelper.instance.delete(id);
    await loadNotes(); // Перезагружаем
  }
}
