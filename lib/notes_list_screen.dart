import 'package:do_an_1/add_screen.dart';
import 'package:do_an_1/database/database_helper.dart';
import 'package:flutter/material.dart';

import 'note_widget.dart';

class NotesListScreen extends StatefulWidget {
  final int userId;
  final String? searchKeyword;
  final bool? isChoiceMode;

  const NotesListScreen(
      {Key? key, required this.userId, this.searchKeyword, this.isChoiceMode})
      : super(key: key);

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  late Future<List<Map<String, dynamic>>> _notesFuture;
  bool isChoiceMode = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  void refreshNotes() {
    setState(() {
      _notesFuture = DatabaseHelper()
          .getNotesByUserId(widget.userId, keyword: widget.searchKeyword);
    });
  }

  void toggleChoiceMode() {
    setState(() {
      isChoiceMode = !isChoiceMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isChoiceMode ? _buildChoiceAppBar() : null,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notes available'));
          } else {
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteWidget(
                  noteId: note['note_id'],
                  userId: note['user_id'],
                  title: note['title'],
                  content: note['content'],
                  imagePath: note['image_path'],
                  isDone: note['is_done'] == 1,
                  isDeleted: note['is_deleted'] == 1,
                  createdAt: DateTime.parse(note['created_at']),
                  updatedAt: DateTime.parse(note['updated_at']),
                  isChoiceMode: isChoiceMode,
                  toggleChoiceMode: toggleChoiceMode,
                  onUpdate: refreshNotes,
                );
              },
            );
          }
        },
      ),
    );
  }

  AppBar _buildChoiceAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          setState(() {
            isChoiceMode = false;
          });
        },
      ),
      actions: [
        TextButton(
            onPressed: () {
              setState(() {
                isChoiceMode = false;
              });
            },
            child: Text(
              'Xong',
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ))
      ],
    );
  }
}
