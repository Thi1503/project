import 'package:do_an_1/todo_list.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class AddScreen extends StatefulWidget {
  final int id;
  final String? imagePath;
  const AddScreen({super.key, required this.id, this.imagePath});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String? imagePath;
  @override
  void initState() {
    super.initState();
    if (widget.id < ToDoList().todos.length) {
      _titleController =
          TextEditingController(text: ToDoList().todos[widget.id].titleNode);
      _contentController =
          TextEditingController(text: ToDoList().todos[widget.id].contentNode);
      // imagePath = ToDoList().todos[widget.id].imagePath!;
    } else {
      _titleController = TextEditingController();
      _contentController = TextEditingController();
      // imagePath = null;
    }
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
                if (widget.imagePath !=
                    null) // Kiểm tra xem imagePath có giá trị không
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.asset(
                      widget.imagePath!,
                      fit: BoxFit
                          .cover, // hoặc BoxFit.fill tùy thuộc vào yêu cầu của bạn
                    ),
                  ),
                TextField(
                  controller: _titleController,
                  maxLines: null,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                  style:  const TextStyle(fontSize: 16),
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
          )),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
              onPressed: () {
                // Lưu dữ liệu vào cơ sở dữ liệu hoặc thực hiện hành động phù hợp ở đây
                String title = _titleController.text;
                String content = _contentController.text;
                // Thực hiện hành động khi lưu
              },
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Lưu',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  )))
        ],
      ),
    );
  }

  BottomAppBar _buildBottomAppBar(BuildContext context) {
    TimeOfDay now = TimeOfDay.now();
    String formattedTime = now.format(context);

    return BottomAppBar(
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Thêm hình ảnh'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.camera_alt_outlined),
                            title: Text('Chụp ảnh'),
                            onTap: () {
                              // Xử lý khi người dùng chọn chụp ảnh
                              // Thêm mã xử lý ở đây
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.image_outlined),
                            title: Text('Chọn từ thư viện'),
                            onTap: () {
                              // Xử lý khi người dùng chọn ảnh từ thư viện
                              // Thêm mã xử lý ở đây
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
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
                'Đã chỉnh sửa $formattedTime',
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
                      // title: Text('Thông báo'),
                      content: Text(
                        'Bạn có muốn xoá ghi chú này không ?',
                        style: TextStyle(fontSize: 20),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                          },
                          child: Text('Có'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Không'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi không cần thiết
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
