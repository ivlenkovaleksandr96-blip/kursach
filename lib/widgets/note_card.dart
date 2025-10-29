// lib/widgets/note_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(
            note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        leading: Text(note.mood, style: const TextStyle(fontSize: 24)),
        trailing: Text(
          DateFormat('dd.MM.yy').format(note.createdAt),
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}