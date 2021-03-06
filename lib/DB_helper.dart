import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  static const _dbVersion = 1;
  static const _dbName = 'myDatabase.db';
  static const _tableName = 'myTable';
  static const columnId = '_id';

  static final columnUserEmail = '_email';
  static final columnUserPassword = '_password';
  static final columnUserDOB = '_DOB';
  static final columnUserLocation = '_location';
  static final columnUserGender = '_gender';

  DataBaseHelper._privateConstructor();
  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future? _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE $_tableName (
        $columnId INTEGER PRIMARY KEY
        $columnUserEmail TEXT NOT NULL
        /* $columnUserPassword TEXT NOT NULL,
        $columnUserDOB TEXT NOT NULL,
         $columnUserLocation TEXT NOT NULL,
          $columnUserGender TEXT NOT NULL */

      ''');
  }

  Future insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    print(db);
    // return db;

    return await db!.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database? db = await instance.database;
    return await db!.query(_tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!
        .update(_tableName, row, where: '$columnId=?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;

    return await db!.delete(_tableName, where: '$columnId=?', whereArgs: [id]);
  }
}
