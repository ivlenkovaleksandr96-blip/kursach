// lib/models/note_model.dart

class Note {
  int? id;
  String title;
  String content;
  String mood; // Будем хранить смайлик как строку
  DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.createdAt,
  });

  // Метод для конвертации объекта Note в Map (для записи в БД)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mood': mood,
      'createdAt': createdAt.toIso8601String(), // Храним дату как строку ISO
    };
  }

  // Метод для конвертации Map в объект Note (для чтения из БД)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      mood: map['mood'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}