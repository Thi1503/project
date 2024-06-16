import 'package:do_an_1/add_screen.dart';
import 'package:do_an_1/database/database_helper.dart';
import 'package:flutter/material.dart';

import 'database/note.dart';

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
  final VoidCallback onUpdate;

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
    required this.onUpdate,
  }) : super(key: key);

  @override
  _NoteWidgetState createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  void _toggleDone() async {
    Note note = Note(
      userId: widget.userId,
      noteId: widget.noteId,
      title: widget.title,
      content: widget.content,
      isDone: !widget.isDone,
      isDeleted: widget.isDeleted,
      createdAt: widget.createdAt,
      updatedAt: DateTime.now(),
    );

    await dbHelper.updateNote(note);
    widget.onUpdate();
  }

  void _deleteNote() async {
    if (widget.noteId != null) {
      await dbHelper.deleteNote(widget.userId, widget.noteId!);
      widget.onUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.isChoiceMode)
          Expanded(
            flex: 1,
            child: TextButton(
              onPressed: _toggleDone,
              child: widget.isDone
                  ? Icon(Icons.check_box_outlined)
                  : Icon(Icons.check_box_outline_blank),
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
              ).then((_) {
                widget.onUpdate();
              });
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 2),
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
                        style: widget.isDone
                            ? TextStyle(
                          decoration: TextDecoration.lineThrough,
                                fontSize: 24,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              )
                            : TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                      ),
                      subtitle: Text(
                        widget.content,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style: widget.isDone
                            ? TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 16,
                          color: Colors.grey,

                        )
                            : TextStyle(
                          fontSize: 16,
                          color: Colors.black,

                        ),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Xác nhận xóa'),
                      content: const Text(
                          'Bạn có chắc chắn muốn xóa ghi chú này không?'),
                      actions: [
                        TextButton(
                          child: const Text('Huỷ'),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Đóng hộp thoại mà không làm gì thêm
                          },
                        ),
                        TextButton(
                          child: const Text('Xóa'),
                          onPressed: () {
                            _deleteNote();
                            Navigator.of(context)
                                .pop(); // Đóng hộp thoại mà không làm gì thêm
                          },

                        ),
                      ],
                    );
                  },
                );
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



