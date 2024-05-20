import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';
import 'note.dart';
import 'label.dart';

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
        is_done BOOLEAN DEFAULT 0,
        is_deleted BOOLEAN DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES User(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Label (
        label_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        name TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES User(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Note_Label (
        note_id INTEGER,
        label_id INTEGER,
        FOREIGN KEY (note_id) REFERENCES Note(note_id),
        FOREIGN KEY (label_id) REFERENCES Label(label_id)
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

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'Note',
      note.toMap(),
      where: 'note_id = ?',
      whereArgs: [note.noteId],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'Note',
      where: 'note_id = ?',
      whereArgs: [id],
    );
  }

  // Label methods
  Future<int> insertLabel(Label label) async {
    final db = await database;
    return await db.insert('Label', label.toMap());
  }

  Future<List<Label>> getLabels() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Label');
    return List.generate(maps.length, (i) => Label.fromMap(maps[i]));
  }

  Future<int> updateLabel(Label label) async {
    final db = await database;
    return await db.update(
      'Label',
      label.toMap(),
      where: 'label_id = ?',
      whereArgs: [label.labelId],
    );
  }

  Future<int> deleteLabel(int id) async {
    final db = await database;
    return await db.delete(
      'Label',
      where: 'label_id = ?',
      whereArgs: [id],
    );
  }

  // Note_Label methods
  Future<int> insertNoteLabel(int noteId, int labelId) async {
    final db = await database;
    return await db.insert('Note_Label', {
      'note_id': noteId,
      'label_id': labelId,
    });
  }

  Future<List<Map<String, dynamic>>> getNoteLabels() async {
    final db = await database;
    return await db.query('Note_Label');
  }

  Future<int> deleteNoteLabel(int noteId, int labelId) async {
    final db = await database;
    return await db.delete(
      'Note_Label',
      where: 'note_id = ? AND label_id = ?',
      whereArgs: [noteId, labelId],
    );
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
