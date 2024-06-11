import 'package:flutter/material.dart';
import 'package:do_an_1/home.dart';
import 'package:do_an_1/database/database_helper.dart';
import 'package:do_an_1/database/note.dart';
import 'package:intl/intl.dart';

class AddScreen extends StatefulWidget {
  final int? noteId;
  final int userId;
  final String? title;
  final String? content;
  final String? imagePath;
  final bool isDone;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AddScreen({
    Key? key,
    this.noteId,
    required this.userId,
    this.title,
    this.content,
    this.imagePath,
    this.isDone = false,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  }) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  DateTime now = DateTime.now();

  int? maxNoteId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
    _loadMaxNoteId();
  }

  Future<void> _loadMaxNoteId() async {
    maxNoteId = await dbHelper.getMaxNoteIdByUserId(widget.userId);
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                maxLines: null,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Tiêu đề',
                  hintStyle: TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _contentController,
                maxLines: null,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nội dung',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            onPressed: () async {
              String title = _titleController.text;
              String content = _contentController.text;

              if (widget.noteId != null) {
                // Nếu noteId không null, có nghĩa là đang chỉnh sửa ghi chú
                Note note = Note(
                  userId: widget.userId,
                  noteId: widget.noteId,
                  title: title,
                  content: content,
                  isDone: widget.isDone,
                  isDeleted: widget.isDeleted,
                  createdAt: widget.createdAt,
                  updatedAt: now, // Cập nhật thời gian mới
                );

                await dbHelper.updateNote(note);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(userId: widget.userId)),
                );
              } else {
                // Ngược lại, đang tạo mới ghi chú
                int? noteId;
                if (maxNoteId != null) {
                  noteId = maxNoteId! + 1;
                }

                Note note = Note(
                  userId: widget.userId,
                  noteId: noteId,
                  title: title,
                  content: content,
                  isDone: false,
                  isDeleted: false,
                  createdAt: now,
                  updatedAt: now,
                );

                await dbHelper.insertNote(note);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(userId: widget.userId)),
                );
              }
            },
            child: const Text(
              'Lưu',
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }

  BottomAppBar _buildBottomAppBar(BuildContext context) {
    String formattedDateTime = formatDateTime(now);

    return BottomAppBar(
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: () {
                // Xử lý khi người dùng thêm hình ảnh
                // Thêm mã xử lý ở đây
              },
              icon: Icon(
                Icons.image_outlined,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Đã chỉnh sửa $formattedDateTime',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
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
                          onPressed: () async {
                            if (widget.noteId != null) {
                              // Nếu noteId không null, có nghĩa là đang chỉnh sửa ghi chú
                              await dbHelper.deleteNote(
                                  widget.userId, widget.noteId!);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Home(userId: widget.userId)),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
