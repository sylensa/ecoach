import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart' show kIsWeb;

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  static Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  static initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "church9.db");
    return await openDatabase(path, version: 5, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE friends_requests ("
          "id INTEGER PRIMARY KEY,"
          "user_id INTEGER,"
          "status TEXT,"
          "user_requested INTEGER,"
          "friend TEXT,"
          "user TEXT,"
          "created_at TEXT,"
          "updated_at TEXT"
          ")");

      await db.execute("CREATE TABLE messages ("
          "id INTEGER PRIMARY KEY,"
          "from_user TEXT,"
          "to_user TEXT,"
          "text TEXT,"
          "title TEXT,"
          "read INTEGER,"
          "reply_id INTEGER,"
          "created_at TEXT,"
          "updated_at TEXT"
          ")");

      await db.execute("CREATE TABLE notifications ("
          "id INTEGER PRIMARY KEY,"
          "data_id INTEGER,"
          "title TEXT,"
          "text TEXT,"
          "type TEXT,"
          "created_at TEXT"
          ")");
    });
  }
}
