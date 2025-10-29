// lib/views/add_edit_note_screen.dart

import 'package:flutter/material.dart';
// Вот исправленный импорт
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../viewmodels/notes_viewmodel.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  late String _mood;
  final List<String> _moods = ['😊', '😢', '😠', '😐', '😍'];
  bool _isSaving = false; // Состояние для предотвращения двойных нажатий

  @override
  void initState() {
    super.initState();
    _title = widget.note?.title ?? '';
    _content = widget.note?.content ?? '';
    _mood = widget.note?.mood ?? _moods.first;
  }

  // Сделали метод асинхронным и добавили обработку состояния загрузки
  Future<void> _saveNote() async {
    // Проверяем, не идет ли уже сохранение
    if (_isSaving) return;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSaving = true; // Начинаем сохранение
      });

      final viewModel = Provider.of<NotesViewModel>(context, listen: false);

      final newNote = Note(
        id: widget.note?.id,
        title: _title,
        content: _content,
        mood: _mood,
        createdAt: widget.note?.createdAt ?? DateTime.now(),
      );

      // Используем `await`, чтобы дождаться завершения операции
      if (widget.note == null) {
        await viewModel.addNote(newNote);
      } else {
        await viewModel.updateNote(newNote);
      }

      // Проверяем, что виджет все еще в дереве, прежде чем вызывать Navigator
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  // Сделали метод асинхронным для ожидания удаления
  Future<void> _deleteNote() async {
    if (widget.note != null) {
      final viewModel = Provider.of<NotesViewModel>(context, listen: false);
      // Дожидаемся завершения удаления
      await viewModel.deleteNote(widget.note!.id!);

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Новая запись' : 'Редактировать'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteNote, // Вызываем асинхронный метод
            ),
          // Показываем индикатор загрузки во время сохранения
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white)),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveNote, // Вызываем асинхронный метод
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Заголовок не может быть пустым' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 20),
              const Text('Настроение:', style: TextStyle(fontSize: 16)),
              Wrap(
                spacing: 8.0,
                children: _moods.map((mood) {
                  return ChoiceChip(
                    label: Text(mood, style: const TextStyle(fontSize: 24)),
                    selected: _mood == mood,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _mood = mood;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _content,
                decoration: const InputDecoration(
                  labelText: 'Содержание',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
                validator: (value) =>
                value!.isEmpty ? 'Содержание не может быть пустым' : null,
                onSaved: (value) => _content = value!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
