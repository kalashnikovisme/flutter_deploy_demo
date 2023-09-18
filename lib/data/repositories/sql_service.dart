import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLService {
  Database? _db;

  Future<Database?> get db async {
    _db ??= await _initDB();
    return _db;
  }

  Future<Database> _initDB() async {
    String dbPath = join(await getDatabasesPath(), "user_database.db");
    var charDB = await openDatabase(dbPath, version: 1, onCreate: _createDB);
    return charDB;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User (id INTEGER PRIMARY KEY, firebaseToken TEXT)
    ''');
  }

  Future<void> saveToken(String token) async {
    final db = await this.db;
    if (db != null) {
      await db.rawInsert(
        'INSERT INTO User (firebaseToken) VALUES(?)',
        [token],
      );
    } else {

      throw Exception("Database is null");
    }
  }

  Future<bool> isTokenExist() async {
    final db = await this.db;
    if (db != null) {
      final result = await db.rawQuery('SELECT COUNT(*) FROM User');
      return Sqflite.firstIntValue(result) == 1;
    } else {
      throw Exception("Database is null");
    }
  }
}
