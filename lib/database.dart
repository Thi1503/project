import 'dart:io';
import 'package:do_an_1/todo_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:do_an_1/todo_model.dart';

import 'dart:convert';

class ToDo {
  int id;
  String? imagePath;
  String? titleNode;
  String? contentNode;

  ToDo({
    required this.id,
    required this.imagePath,
    required this.titleNode,
    required this.contentNode,
  });

  factory ToDo.fromMap(Map<String, dynamic> json) => ToDo(
    id: json["id"],
    imagePath: json["imagePath"],
    titleNode: json["titleNode"],
    contentNode: json["contentNode"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "imagePath": imagePath,
    "titleNode": titleNode,
    "contentNode": contentNode,
  };


}

ToDo todoFromJson(String str) {
  final jsonData = json.decode(str);
  return ToDo.fromMap(jsonData);
}

String todoToJson(ToDo data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}


class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
   static late Database _database;

  Future<void> insertInitialData() async {
    // Khởi tạo danh sách ToDo mẫu
    List<ToDo> initialTodos = [
      ToDo(
        id: 7,
        imagePath: null,
        titleNode: null,
        contentNode: 'Noi dung ghi chu 0',
      ),
      ToDo(
        id: 1,
        imagePath: 'assets/violet.jpg',
        titleNode: 'Tieu de 1',
        contentNode: 'Noi dung ghi chu 1',
      ),
      ToDo(
        id: 2,
        imagePath: 'assets/anh_doc.jpg',
        titleNode: 'Tieu de 2',
        contentNode: 'Noi dung ghi chu 2',
      ),
      ToDo(
        id: 3,
        imagePath: 'assets/naruto.jpg',
        titleNode: 'Tieu de 3',
        contentNode: 'Noi dung ghi chu 3',
      ),
      ToDo(
          id: 100,
          imagePath: 'assets/goku.jpg',
          titleNode: '',
          contentNode: 'Tieu de cuoi',
      ),
    ];

    final db = await database;
    // Thêm từng ToDo vào cơ sở dữ liệu
    initialTodos.forEach((todo) async {
      await db.insert('ToDo', todo.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }


  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;

  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Todo.db");
    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    await insertInitialData(); // Thêm dữ liệu mẫu
    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Todo ("
        "id INTEGER PRIMARY KEY,"
        "imagePath TEXT,"
        "titleNode TEXT,"
        "contentNode TEXT" // Use INTEGER for boolean type.
        ")");
  }

  newClient(ToDo newTodo) async {
    final db = await database;
    // Tìm ID mới cho ToDo
    var table = await db.rawQuery("SELECT COALESCE(MAX(id), 0) + 1 as id FROM ToDo");
    int id = table.first["id"] as int ?? 1; // Nếu không có dòng nào trong bảng, sử dụng ID đầu tiên là 1

    // Chèn dữ liệu mới vào bảng ToDo
    var raw = await db.rawInsert(
        "INSERT INTO ToDo (id, image_path, title_node, content_node) VALUES (?, ?, ?, ?)",
        [id, newTodo.imagePath, newTodo.titleNode, newTodo.contentNode]
    );
    return raw;
  }

  getToDo(int id) async {
    final db = await database;
    var res =await  db.query("ToDo", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? ToDo.fromMap(res.first) : Null ;
  }

  Future<List<ToDo>> getAllTodo() async {
    final db = await database;
    var res = await db.query("ToDo");
    List<ToDo> todos = res.isNotEmpty ? res.map((todo) => ToDo.fromMap(todo)).toList() : [];
    return todos;
  }

}
