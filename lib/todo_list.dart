import 'package:flutter/material.dart';
import 'dart:convert';

class ToDo {
  int id;
  String? imagePath;
  String? titleNode;
  String? contentNode;
  //bool isDone;

  ToDo(
      {required this.id,
      required this.imagePath,
      required this.titleNode,
      required this.contentNode
      // this.isDone = false,
      });
}

class ToDoList {
  static final ToDoList _instance = ToDoList._internal();

  factory ToDoList() {
    return _instance;
  }
  // void updateIDs() {
  //   for (int i = 0; i < todos.length; i++) {
  //     todos[i].id = i; // Cập nhật ID của ToDoNode
  //   }
  // }
  ToDoList._internal();

  List<ToDo> todos = [
    ToDo(
        id: 7,
        imagePath: null,
        titleNode: null,
        contentNode: 'Noi dung ghi chu 0'),
    ToDo(
        id: 12,
        imagePath: 'assets/violet.jpg',
        titleNode: 'Tieu de 1',
        contentNode: 'Noi dung ghi chu 1'),
    ToDo(
        id: 2,
        imagePath: 'assets/anh_doc.jpg',
        titleNode: 'Tieu de 2',
        contentNode: 'Noi dung ghi chu 2'),
    ToDo(
        id: 3,
        imagePath: 'assets/naruto.jpg',
        titleNode: 'Tieu de 3',
        contentNode: 'Noi dung ghi chu 3'),
    ToDo(id: 100,
        imagePath: 'assets/goku.jpg',
        titleNode: '',
        contentNode: '')
  ];


}
