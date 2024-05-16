import 'package:do_an_1/todo_list.dart';
import 'package:do_an_1/todo_node.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: const TextField(
            style: TextStyle(fontSize: 20, color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Tìm kiếm ghi chú',
                hintStyle: TextStyle(fontSize: 20, color: Colors.grey))),
      )),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: ToDoList()
            .todos
            .map((todo) => ToDoNode(
                  id: todo.id,
                  imagePath: todo.imagePath,
                  contentNode: todo.contentNode,
                  titleNode: todo.titleNode,
                ))
            .toList(),
      ),
    );
  }
}
