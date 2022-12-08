import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

import 'DBDao.dart';

class DBHelper {
  late Database db;
  String tableName = 'ThatDay';

  Future openDB() async {
    db = await openDatabase('ThatDay.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $tableName ( 
      "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "year" integer not null,
  "month" integer not null,
  "day" integer not null,
  "title" text not null,
  "content" text not null)
  ''');
    });
  }
  Future<void> insert(DBDao dbDao) async {
    await openDB();
    await db.insert(tableName, dbDao.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    close();
  }
  Future<List<Map<String, Object?>>> getDao() async {
    await openDB();
    List<Map<String, Object?>> records = await db.query(tableName);
    close();
    return records;
  }

  //todo need to finish delete function.
  Future delete() async {
    await openDB();
    close();
  }

  //todo modify table later
  Future modify(int id , DBDao dbDao) async {
    String updateQuery  =
        "UPDATE $tableName SET year = '${dbDao.year}',month = '${dbDao.month}'"
        ",day = '${dbDao.day}', title = '${dbDao.title}', content = '${dbDao.content}'"
        "WHERE id = '$id'";


    await openDB();
    db.rawQuery(updateQuery);
    close();
  }

  Future close() async => db.close();
}
