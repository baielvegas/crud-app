import 'package:blocsqlitecrud/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _db;

  DatabaseProvider._init();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _useDatabase('goods.db');
    return _db!;
  }

  Future<Database> _useDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'goods.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE notes (id INTEGER PRIMARY KEY, name TEXT, price BLOB)');
      },
      version: 1,
    );
  }

  Future<List<Note>> buscarNotas() async {
    final db = await instance.db;
    final result = await db.rawQuery('SELECT * FROM notes ORDER BY id');
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note> save(Note note) async {
    final db = await instance.db;
    final id = await db.rawInsert(
        'INSERT INTO notes (name, price) VALUES (?,?)',
        [note.name, note.price]);
    return note.copy(id: id);
  }

  Future<Note> update(Note note) async {
    final db = await instance.db;
    await db.rawUpdate('UPDATE notes SET name = ?, price = ? WHERE id = ?',
        [note.name, note.price, note.id]);

    return note;
  }

  Future<int> deleteAll() async {
    final db = await instance.db;
    final result = await db.rawDelete('DELETE FROM notes');
    return result;
  }

  Future<int> delete(int noteId) async {
    final db = await instance.db;
    final result =
        await db.rawDelete('DELETE FROM notes WHERE id = ?', [noteId]);
    return result;
  }

  Future close() async {
    final db = await instance.db;
    db.close();
  }
}
