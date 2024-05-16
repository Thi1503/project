import 'package:do_an_1/todo_list.dart';
import 'package:flutter/material.dart';

import 'add_screen.dart';

class ToDoNode extends StatefulWidget {
  final int id;
  final String? imagePath;
  final String? contentNode;
  final String? titleNode;

  const ToDoNode(
      {Key? key,
      required this.id,
      this.imagePath,
      this.contentNode,
      this.titleNode})
      : super(key: key);

  @override
  _ToDoNodeState createState() => _ToDoNodeState();
}

class _ToDoNodeState extends State<ToDoNode> {
  MaterialColor _borderColor = Colors.grey;
  double _borderWidth = 1.0;

  @override
  Widget build(BuildContext context) {
    return _gestureDetector();
  }

  GestureDetector _gestureDetector() {

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _borderColor = Colors.blue;
          _borderWidth = 5;
        });
      },
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (widget.id < ToDoList().todos.length) {
                return AddScreen(
                  id: ToDoList().todos[widget.id].id,
                  imagePath: ToDoList().todos[widget.id].imagePath,
                );
              } else {
                return AddScreen(id: ToDoList().todos.length);
              }
            },
          ),
        );
        setState(() {
          _borderColor = Colors.grey;
          _borderWidth = 1;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 8.0), // Khoảng cách giữa các ToDoNode
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _borderColor,
              width: _borderWidth,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.imagePath !=
                  null) // Kiểm tra xem imagePath có giá trị không
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.asset(widget.imagePath!),
                ),
              if (widget.contentNode != null || widget.titleNode != null)
                ListTile(
                  title: widget.titleNode != null
                      ? Text(
                          '${widget.titleNode}',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                  subtitle: widget.contentNode != null
                      ? Text(
                          '${widget.contentNode}',
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
