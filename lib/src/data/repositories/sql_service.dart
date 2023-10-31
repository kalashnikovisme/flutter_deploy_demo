import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:test_intern/src/data/dtos/result.dart';
import 'package:test_intern/src/data/mappers/rick_and_morty_mapper.dart';
import 'package:test_intern/src/domain/models/result_model.dart';

class SQLService {
  Database? _db;

  static const String userDb = 'User';
  static const String charactersDb = 'characters';
  static const String characterUserDb = 'user_characters';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDB();
      if (_db == null) {
        throw Exception("Database is null");
      }
    }
    return _db;
  }

  Future<Database> initDB() async {
    final String dbPath;
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      dbPath = 'my_web_web.db';
    } else {
      dbPath = path.join(await getDatabasesPath(), "user_database.db");
    }

    final db = await openDatabase(dbPath, version: 6, onCreate: _createDB);
    return db;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $userDb (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userEmail TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE $charactersDb (
      id INTEGER PRIMARY KEY,
      name TEXT,
      image BLOB
    )
  ''');
    await db.execute('''CREATE TABLE $characterUserDb (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  character_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (character_id) REFERENCES characters(id)
);''');
  }

  Future<List<ResultModel>?> getFavoriteCharacters(String userEmail) async {
    final db = await this.db;

    final user = await db?.query(
          userDb,
          where: 'userEmail = ?',
          whereArgs: [userEmail],
        ) ??
        [];

    if (user.isEmpty) {
      return [];
    }

    final result = await db?.rawQuery('''
    SELECT * FROM $charactersDb WHERE id IN
    (SELECT character_id FROM user_characters WHERE user_id = ?)
  ''', [user[0]['id']]);

    return result?.map((map) {
      return ResultDto.fromJson(map).toDomain();
    }).toList();
  }

  Future<void> saveToFavourite(ResultModel character, String userEmail) async {
    final db = await this.db;

    final user = await _fetchDB(userEmail);

    if (user.isEmpty) {
      return;
    }

    final isCharacterLiked = await db?.query(
      characterUserDb,
      where: 'user_id = ? AND character_id = ?',
      whereArgs: [user[0]['id'], character.id],
    );

    if (isCharacterLiked != null && isCharacterLiked.isNotEmpty) {
    } else {
      await db?.insert(
        characterUserDb,
        {
          'user_id': user[0]['id'],
          'character_id': character.id,
        },
      );
    }
  }

  Future<List<Map<String, Object?>>> _fetchDB(String userEmail) async {
    final db = await this.db;
    final results = await db?.query(
      userDb,
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    );

    return results ?? [];
  }

  Future<void> delete(ResultModel character, String userEmail) async {
    final db = await this.db;

    final user = await _fetchDB(userEmail);

    if (user.isEmpty) {
      return;
    }

    await db?.delete(
      characterUserDb,
      where: 'user_id = ? AND character_id = ?',
      whereArgs: [user[0]['id'], character.id],
    );
  }

  Future<void> saveToken(String email) async {
    final db = await this.db;
    await db?.insert(
      userDb,
      {'userEmail': email},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertPaginatedList(List<ResultModel>? character) async {
    final db = await this.db;
    for (final char in character ?? []) {
      await db?.insert(
        charactersDb,
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
    final result = await db?.query(charactersDb);
    return result?.map((map) {
      return ResultDto.fromJson(map).toDomain();
    }).toList();
  }

  Future<void> close() async {
    Database? db = await this.db;
    db?.close();
  }
}
