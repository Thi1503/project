import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';
import 'note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE Note (
        note_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        image_path TEXT,
        is_done BOOLEAN DEFAULT 0,
        is_deleted BOOLEAN DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES User(user_id)
      )
    ''');
  }

  // User methods
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('User', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('User');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'User',
      user.toMap(),
      where: 'user_id = ?',
      whereArgs: [user.userId],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'User',
      where: 'user_id = ?',
      whereArgs: [id],
    );
  }

  // Note methods
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('Note', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Note');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<List<Map<String, dynamic>>> getNotesByUserId(int userId, {String? keyword}) async {
    final db = await database;
    List<Map<String, dynamic>> result;

    // Kiểm tra nếu keyword được cung cấp
    if (keyword == null || keyword.isEmpty) {
      // Nếu không có keyword, chỉ truy vấn theo user ID
      result = await db.query(
        'Note',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } else {
      // Nếu có keyword, truy vấn theo user ID và keyword
      result = await db.query(
        'Note',
        where: 'user_id = ? AND (title LIKE ? OR content LIKE ?)',
        whereArgs: [userId, '%$keyword%', '%$keyword%'],
      );
    }

    print('Query result: $result');  // Thêm câu lệnh print để kiểm tra kết quả
    return result;
  }

  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
      'Note', // Sửa thành 'Note'
      note.toMap(),
      where: 'user_id = ? AND note_id = ?', // Thay 'userId' thành 'user_id' và 'noteId' thành 'note_id'
      whereArgs: [note.userId, note.noteId],
    );
  }

  Future<void> deleteNote(int userId, int noteId) async {
    final db = await database;
    await db.delete(
      'Note',
      where: 'user_id = ? AND note_id = ?',
      whereArgs: [userId, noteId],
    );
  }

  Future<int?> getUserIdByEmail(String email) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results = await db.query(
        'User',
        columns: ['user_id'], // Thay 'id' thành 'user_id'
        where: 'email = ?',
        whereArgs: [email],
      );
      if (results.isNotEmpty) {
        return results.first['user_id']; // Thay 'id' thành 'user_id'
      } else {
        return null; // Không tìm thấy email trong cơ sở dữ liệu
      }
    } catch (ex) {
      print('Error: $ex');
      return null;
    }
  }

  Future<String?> getUserNameByUserID(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'User',
      columns: ['username'],
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (results.isNotEmpty) {
      return results.first['username'] as String?;
    } else {
      return null; // Không tìm thấy user với user_id tương ứng
    }
  }
  Future<User?> getUserByUserId(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'User',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    } else {
      return null; // Không tìm thấy user với user_id tương ứng
    }
  }



  Future<int?> getMaxNoteIdByUserId(int userId) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results = await db.rawQuery('''
        SELECT MAX(note_id) AS max_id FROM Note WHERE user_id = ?
      ''', [userId]);

      // Lấy giá trị note_id lớn nhất từ kết quả truy vấn
      int? maxId = results.first['max_id'];

      return maxId;
    } catch (ex) {
      print('Error: $ex');
      return null;
    }
  }

  Future<bool> checkLogin(String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'User', // Thay 'users' thành 'User' để khớp với tên bảng trong cơ sở dữ liệu
      where: 'email = ? AND password = ?',
      whereArgs: [username, password],
    );

    return results.isNotEmpty;
  }

  Future<bool> checkSignUp(String username) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'User',
      where: 'email = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty;
  }
}
