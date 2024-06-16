import 'package:do_an_1/add_screen.dart';
import 'package:flutter/material.dart';
import 'notes_list_screen.dart';
import 'search_screen.dart';
import 'sign_in_screen.dart'; // Import NotesListScreen

class Home extends StatefulWidget {
  final int userId;
  final int? noteId;


  const Home({Key? key, required this.userId, this.noteId}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool isChoiceMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: NotesListScreen(userId: widget.userId),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchScreen(
                      userId: widget.userId,
                    )),
          );
        },
        title: const Text(
          'Tìm kiếm ghi chú',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        trailing: IconButton(
          onPressed: () {},
          iconSize: 40,
          icon: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.asset(
                'assets/violet.jpg',
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.asset(
                    'assets/violet.jpg',
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              title: Text(
                'Lê Đình Thi',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.black,
              ),
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.black),
              title: const Text('Tạo ghi chú'),
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddScreen(userId: widget.userId)),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              title: const Text('Cập nhật tài khoản'),
              selected: _selectedIndex == 2,
              onTap: () {
                // Handle settings
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: const Text('Đăng xuất'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
            ),
          ],
        ),
      )
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 10,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(
                //     Icons.check_box_outlined,
                //     color: Colors.black,
                //   ),
                // ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.draw_outlined,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.mic_none,
                    color: Colors.black,
                  ),
                ),
                IconButton(
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
                                  // Handle camera option
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.image_outlined),
                                title: Text('Chọn từ thư viện'),
                                onTap: () {
                                  // Handle gallery option
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
              ],
            ),
          ),
          Expanded(
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddScreen(userId: widget.userId)),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 40,
              ),
            ),
          )
        ],
      ),
    );
  }
}
