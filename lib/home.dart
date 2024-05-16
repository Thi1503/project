import 'package:do_an_1/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:do_an_1/add_screen.dart';
import 'package:do_an_1/todo_node.dart';
import 'package:do_an_1/todo_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _updateIDs(); // Cập nhật ID trước khi build
  }

  void _updateIDs() {
    ToDoList().updateIDs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(),
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
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        },
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30),
        // ),
        // tileColor: const Color.fromARGB(255, 225, 214, 214),
        // leading: IconButton(
        //   onPressed: () {
        //     Scaffold.of(context).openDrawer();
        //   },
        //   icon: const Icon(
        //     Icons.menu,
        //     color: Colors.black,
        //     size: 30,
        //   ),
        // ),
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
    int _selectedIndex = 0;
    const TextStyle optionStyle =
        TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          Container(
            // color: Colors.blue,
            padding: EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 20), // Điều chỉnh kích thước của DrawerHeader
          ),
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
          // DrawerHeader(
          //   decoration: BoxDecoration(
          //     color: Colors.blue,
          //   ),
          //
          //   child: ListTile(
          //     leading: CircleAvatar(
          //       backgroundColor: Colors.transparent,
          //       child: ClipOval(
          //         child: Image.asset(
          //           'assets/violet.jpg',
          //           fit: BoxFit.cover,
          //           width: 40,
          //           height: 40,
          //         ),
          //       ),
          //     ),
          //   )
          // ),
          ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.black,
              ),
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {}),
          ListTile(
            leading: Icon(Icons.add, color: Colors.black),
            title: const Text('Tạo ghi chú'),
            selected: _selectedIndex == 1,
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: const Text('Cài đặt'),
            selected: _selectedIndex == 2,
            onTap: () {},
          ),
          ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: const Text('Đăng xuất'),
              onTap: () {}),
        ],
      ),
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.check_box_outlined,
                    color: Colors.black,
                  ),
                ),
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
              ],
            ),
          ),
          Expanded(
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddScreen(id: ToDoList().todos.length)),
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
