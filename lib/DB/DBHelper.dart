import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper{
  Database db;
  String tableName = 'ThatDay';


  Future openDB(String path) async{
    db = await openDatabase(path,
        version: 1,
        onCreate:(Database db, int version)async {
      await db.execute('''
      create table $tableName ( 
  "id" integer primary key autoincrement, 
  "year" integer not null,
  "month" integer not null,
  "day" integer not null,
  "title" text not null,
  "content" text not null)
  ''');
        });
  }


  // todo 다음에는 insert,get , delete 를 구현하고 위에 db 에러를 해결 해야 한다.

}