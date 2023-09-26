import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:test_intern/domain/models/result_model.dart';

class SQLService {
  Database? _db;

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
    final String dbPath =
        path.join(await getDatabasesPath(), "user_database.db");
    final charDB = await openDatabase(dbPath, version: 1, onCreate: _createDB);
    return charDB;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE User (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      firebaseToken TEXT,
      userEmail TEXT UNIQUE
    )
  ''');

    await db.execute('''
    CREATE TABLE characters (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      image BLOB,
      userEmail TEXT,
      liked INTEGER
    )
  ''');
    await db.execute('''CREATE TABLE user_characters (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  character_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (character_id) REFERENCES characters(id)
);''');
  }

  Future<List<ResultModel>?> getFavoriteCharacters(String userEmail) async {
    final db = await this.db;

    final result = await db?.rawQuery('''
    SELECT characters.*, user_characters.id AS liked
    FROM characters
    LEFT JOIN user_characters ON characters.id = user_characters.character_id
      AND user_characters.user_id = ?
    WHERE characters.userEmail = ?
  ''', [userEmail, userEmail]);

    print(result?.map((e) => e));
    print(userEmail);
    return result?.map((map) {
      return ResultModel(
          id: map['id'] as int,
          name: map['name'] as String,
          image: map['image'] as String,
          isLiked: map['liked'] == 1);
    }).toList();
  }

  Future<void> saveToFavourite(ResultModel character, String userEmail) async {
    final db = await this.db;

    final existingCharacter = await db?.query(
      'characters',
      where: 'name = ? AND userEmail = ?',
      whereArgs: [character.name, userEmail],
    );

    if (existingCharacter != null && existingCharacter.isNotEmpty) {
      print('вот тут чекаем есть ли такой перс, чтобы не было дублей');
      final isCharacterLiked = await db?.query(
        'user_characters',
        where: 'user_id = ? AND character_id = ?',
        whereArgs: [userEmail, existingCharacter[0]['id']],
      );

      if (isCharacterLiked != null && isCharacterLiked.isNotEmpty) {
        print('уже в избранном, угомонись, не дублируется');
      } else {
        await db?.insert(
          'user_characters',
          {
            'user_id': userEmail,
            'character_id': existingCharacter[0]['id'],
          },
        );
      }
    } else {
      print('вот тут добавляешь, если нет такого перса');
      final characterId = await db?.insert(
        'characters',
        {
          'name': character.name,
          'image': character.image,
          'userEmail': userEmail,
          'liked': character.isLiked ? 1 : 0
        },
      );

      if (characterId != null) {
        print('вот тут добавлена связь(!!!) в таблицу');
        await db?.insert(
          'user_characters',
          {
            'user_id': userEmail,
            'character_id': characterId,
          },
        );
      }
    }
  }

  Future<void> delete(ResultModel character, String userEmail) async {
    final db = await this.db;

    final existingCharacter = await db?.query(
      'characters',
      where: 'name = ? AND userEmail = ?',
      whereArgs: [character.name, userEmail],
    );

    if (existingCharacter != null && existingCharacter.isNotEmpty) {
      print('чекаем и удаляем запись(!!!!!) о персонаже');
      await db?.delete(
        'characters',
        where: 'id = ?',
        whereArgs: [existingCharacter[0]['id']],
      );
      print('вообще совсем удаляем связь (!!!!) из таблицы');
      await db?.delete(
        'user_characters',
        where: 'user_id = ? AND character_id = ?',
        whereArgs: [userEmail, existingCharacter[0]['id']],
      );
    }
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
    final result = await db?.query("characters");
    return result?.map((map) {
      return ResultModel(
        id: map['id'] as int,
        name: map['name'] as String,
        image: map['image'] as String,
      );
    }).toList();
  }

  Future<void> close() async {
    Database? db = await this.db;
    db?.close();
  }
}
