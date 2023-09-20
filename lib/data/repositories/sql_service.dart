import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test_intern/domain/models/result_model.dart';

class SQLService {
  Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDB();
      if (_db == null) {
        throw Exception("Database is null");
      }
    }
    return _db;
  }

  Future<Database> _initDB() async {
    final String dbPath = join(await getDatabasesPath(), "user_database.db");
    final charDB = await openDatabase(dbPath, version: 1, onCreate: _createDB);
    return charDB;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User (id INTEGER PRIMARY KEY AUTOINCREMENT, firebaseToken TEXT)
    ''');
    await db.execute('''
    CREATE TABLE characters (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      image BLOB 
    )
  ''');
  }

  Future<void> insertPaginatedList(List<ResultModel>? character) async {
    final db = await this.db;
    for (final char in character ?? []) {
      await db?.insert(
        'characters',
        {
          'id': char.id,
          'name': char.name,
          'image': char.image,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<ResultModel>?> getCachedList() async {
    final db = await this.db;
    var result = await db?.query("characters");
    return result?.map((map) {
      return ResultModel(
        id: map['id'] as int,
        name: map['name'] as String,
        image: map['image'] as String,
      );
    }).toList();
  }

  Future<void> saveToken(String token) async {
    final db = await this.db;
    await db?.rawInsert(
      'INSERT INTO User (firebaseToken) VALUES(?)',
      [token],
    );
  }

  Future<bool> isTokenExist() async {
    final db = await this.db;
    final result = await db?.rawQuery('SELECT COUNT(*) FROM User');
    return Sqflite.firstIntValue(result ?? []) == 1;
  }
}
