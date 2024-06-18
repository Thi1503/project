import 'package:flutter/material.dart';
import 'notes_list_screen.dart';

class SearchScreen extends StatefulWidget {
  final int userId;

  SearchScreen({Key? key, required this.userId});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  bool showNotes = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      showNotes = _searchController.text.trim().isNotEmpty;
    });
  }

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
      body: showNotes
          ? NotesListScreen(
        userId: widget.userId,
        searchKeyword: _searchController.text.trim(),
      )
          : Container(), // không hiển thị ghi chú khi không có từ khóa tìm kiếm
    );
  }
}
