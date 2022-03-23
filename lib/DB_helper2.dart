import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testing_storing_device/DB_model.dart';

class DBHelper2 {
  static final DBHelper2 instance = DBHelper2._init();
  static Database? _database;
  DBHelper2._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    await db.execute(''' 
      CREATE TABLE $tableDB (
        ${DBField.id}$idType,
        ${DBField.userDOB}$textType,
        ${DBField.userEmail}$textType,
        ${DBField.userGender}$textType,
        ${DBField.userLocation}$textType,
        ${DBField.userPassword}$textType,
      )
      ''');
  }

  Future<DBModel> create(DBModel userSignInDetail) async {
    final db = await instance.database;
    final id = await db.insert(tableDB, userSignInDetail.toJson());
    return userSignInDetail.copy(id: id);
  }

  Future<DBModel> readDB(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableDB,
      columns: DBField.values,
      where: '${DBField.id}= ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return DBModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<DBModel>> readAllDB() async {
    final db = await instance.database;
    final orderBy = '${DBField.userDOB} ASC';
    final result = await db.query(tableDB, orderBy: orderBy);
    return result.map((json) => DBModel.fromJson(json)).toList();
  }

  Future<int> update(DBModel userSignInDetail) async {
    final db = await instance.database;
    return db.update(
      tableDB,
      userSignInDetail.toJson(),
      where: '${DBField.id}=?',
      whereArgs: [userSignInDetail.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableDB,
      where: '${DBField.id}=?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
