import 'package:do_an_1/add_screen.dart';
import 'package:do_an_1/database/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotesListScreen extends StatefulWidget {
  final int userId;
  final String? searchKeyword;

  const NotesListScreen({Key? key, required this.userId, this.searchKeyword})
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
    refreshNotes(); // Gọi hàm refreshNotes khi trang được khởi tạo
  }

  // Phương thức để cập nhật danh sách ghi chú
  void refreshNotes() {
    print('key ben note : ${widget.searchKeyword}');
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
                  imagePath: note['image_path'], // Đảm bảo khớp tên cột
                  isDone: note['is_done'] == 1,
                  isDeleted: note['is_deleted'] == 1,
                  createdAt: DateTime.parse(note['created_at']),
                  updatedAt: DateTime.parse(note['updated_at']),
                  isChoiceMode: isChoiceMode,
                  toggleChoiceMode: toggleChoiceMode,
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

class NoteWidget extends StatefulWidget {
  final int? noteId;
  final int userId;
  final String title;
  final String content;
  final String? imagePath;
  final bool isDone;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isChoiceMode;
  final VoidCallback toggleChoiceMode;

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
    required this.isChoiceMode,
    required this.toggleChoiceMode,
  }) : super(key: key);

  @override
  _NoteWidgetState createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.isChoiceMode)
          Expanded(
            flex: 1,
            child: TextButton(
              onPressed: () {},
              child: Icon(Icons.check_box_outline_blank),
            ),
          ),
        Expanded(
          flex: 8,
          child: GestureDetector(
            onLongPress: widget.toggleChoiceMode,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddScreen(
                    userId: widget.userId,
                    noteId: widget.noteId,
                    title: widget.title,
                    content: widget.content,
                    imagePath: widget.imagePath,
                    isDone: widget.isDone,
                    isDeleted: widget.isDeleted,
                    createdAt: widget.createdAt,
                    updatedAt: widget.updatedAt,
                  ),
                ),
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.imagePath != null)
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.asset(widget.imagePath!),
                      ),
                    ListTile(
                      title: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        widget.content,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.isChoiceMode)
          Expanded(
            flex: 1,
            child: TextButton(
              onPressed: () {
                // Xử lý sự kiện xóa
              },
              child: Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}
