import 'package:do_an_1/add_screen.dart';
import 'package:do_an_1/database/database_helper.dart';
import 'package:flutter/material.dart';

class NotesListScreen extends StatefulWidget {
  final int userId;
  final String? searchKeyword;

  const NotesListScreen({Key? key, required this.userId, this.searchKeyword}) : super(key: key);

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  late Future<List<Map<String, dynamic>>> _notesFuture;

  @override
  void initState() {
    super.initState();
    refreshNotes(); // Gọi hàm refreshNotes khi trang được khởi tạo
  }

  // Phương thức để cập nhật danh sách ghi chú
  void refreshNotes() {
    setState(() {
      _notesFuture = DatabaseHelper().getNotesByUserId(widget.userId, keyword: widget.searchKeyword);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Notes'),
      // ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có ghi chú nào'));
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
                  imagePath: note['imagePath'],
                  isDone: note['is_done'] == 1,
                  isDeleted: note['is_deleted'] == 1,
                  createdAt: DateTime.parse(note['created_at']),
                  updatedAt: DateTime.parse(note['updated_at']),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class NoteWidget extends StatelessWidget {
  final int? noteId;
  final int userId;
  final String title;
  final String content;
  final String? imagePath;
  final bool isDone;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NoteWidget({
    Key? key,
    this.noteId,
    required this.userId,
    required this.title,
    required this.content,
    this.imagePath,
    this.isDone = false,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        //
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddScreen(
              userId: userId,
              noteId: noteId,
              title: title,
              content: content,
              imagePath: imagePath,
              isDone: isDone,
              isDeleted: isDeleted,
              createdAt: createdAt,
              updatedAt: updatedAt,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imagePath != null)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.asset(imagePath!),
                ),
              ListTile(
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  content,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
