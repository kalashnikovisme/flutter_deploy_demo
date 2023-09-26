import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:test_intern/data/dtos/result.dart';
import 'package:test_intern/data/mappers/rick_and_morty_mapper.dart';
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
    final charDB = await openDatabase(dbPath, version: 4, onCreate: _createDB);
    return charDB;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE User (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userEmail TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE characters (
      id INTEGER PRIMARY KEY,
      name TEXT,
      image BLOB
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

    final user = await db?.query(
      'User',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    ) ?? [];

    if(user.isEmpty){
      print('user is not found');
      return [];
    }

    final result = await db?.rawQuery('''
    SELECT *
    FROM characters
    LEFT JOIN user_characters ON characters.id = user_characters.character_id
      AND user_characters.user_id = ?
  ''', [user[0]['id']]);

    print(result?.map((e) => e));
    print(userEmail);
    return result?.map((map) {
      return ResultDto.fromJson(
          map
         ).toDomain();
    }).toList();
  }

  Future<void> saveToFavourite(ResultModel character, String userEmail) async {
    final db = await this.db;

    final user = await db?.query(
      'User',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    ) ?? [];

    if(user.isEmpty){
      print('user is not found');
      return;
    }

      print('вот тут чекаем есть ли такой перс, чтобы не было дублей');
      final isCharacterLiked = await db?.query(
        'user_characters',
        where: 'user_id = ? AND character_id = ?',
        whereArgs: [user[0]['id'], character.id],
      );

      if (isCharacterLiked != null && isCharacterLiked.isNotEmpty) {
        print('уже в избранном, угомонись, не дублируется');
      } else {
        await db?.insert(
          'user_characters',
          {
            'user_id': user[0]['id'],
            'character_id': character.id,
          },
        );
      }
    }


  Future<void> delete(ResultModel character, String userEmail) async {
    final db = await this.db;

    print('local db');
    print((await db?.query("user_characters"))?.map((e) => (e['user_id']?? '').toString()  + ' ' + (e['character_id']?? '').toString()));
    final user = await db?.query(
      'User',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    ) ?? [];
    if(user.isEmpty){
      print('user is not found');
      return;
    }


      print('вообще совсем удаляем связь (!!!!) из таблицы');
      await db?.delete(
        'user_characters',
        where: 'user_id = ? AND character_id = ?',
        whereArgs:  [user[0]['id'], character.id],
      );
    }

  Future<void> saveToken(String email) async {
    final db = await this.db;
    await db?.rawInsert(
      'INSERT INTO User (userEmail) VALUES(?)',
      [email],
    );
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
