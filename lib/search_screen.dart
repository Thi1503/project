import 'package:flutter/material.dart';
import 'package:do_an_1/todo_node.dart'; // Import NotesListScreen

class SearchScreen extends StatefulWidget {
  final int userId;

  SearchScreen({Key? key, required this.userId});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      // Cập nhật giá trị của searchKeyword mỗi khi TextField thay đổi
      setState(() {
        searchKeyword = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi không cần thiết
    _searchController.dispose();
    super.dispose();
  }

  String searchKeyword = ''; // Khởi tạo searchKeyword ở đây

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: TextField(
            controller: _searchController,
            style: TextStyle(fontSize: 20, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Tìm kiếm ghi chú',
              hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ),
        ),
      ),
      body: NotesListScreen(
        userId: widget.userId,
        searchKeyword: searchKeyword, // Truyền searchKeyword đã cập nhật vào NotesListScreen
      ),
    );
  }
}
