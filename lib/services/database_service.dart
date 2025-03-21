import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(path, version: 2, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT,
        category TEXT NOT NULL,
        categoryColor INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', {
      'title': note.title,
      'content': note.content,
      'category': note.category,
      'created_at': DateTime.now().toIso8601String(),
      'categoryColor': note.categoryColor,
    });
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<List<String>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      distinct: true,
      columns: ['category'],
    );
    return List.generate(maps.length, (i) => maps[i]['category'] as String);
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      {
        'title': note.title,
        'content': note.content,
        'category': note.category,
        'categoryColor': note.categoryColor,
      },
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(String title) async {
    final db = await database;
    return await db.delete('notes', where: 'title = ?', whereArgs: [title]);
  }

  Future<List<Map<String, dynamic>>> getCategoryColors() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT DISTINCT category, categoryColor FROM notes
    ''');
    return result;
  }

  Future<void> updateCategoryColor(String category, int color) async {
    final db = await database;
    await db.rawUpdate(
      '''
      UPDATE notes 
      SET categoryColor = ? 
      WHERE category = ?
    ''',
      [color, category],
    );
  }
}
