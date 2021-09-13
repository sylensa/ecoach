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
    String path = join(documentsDirectory.path, "ecoach.db");
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

      await db.execute("""CREATE TABLE 'course_levels' (
        'id' int NOT NULL,
        'name' varchar(50) NOT NULL,
        'code' varchar(10) NOT NULL,
        'group' varchar(50) NOT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL,
        PRIMARY KEY ('id')
      ) """);

      await db.execute("""CREATE TABLE 'questions' (
        'id' int NOT NULL,
        'course_id' int NOT NULL,
        'topic_id' int NOT NULL,
        'qid' varchar(50) NOT NULL,
        'text' text NOT NULL,
        'instructions' text NOT NULL,
        'resource' text NOT NULL,
        'options' text NOT NULL,
        'position' int NOT NULL,
        'created_at' datetime NOT NULL,
        'updated_at' datetime NOT NULL,
        'qtype' varchar(10) DEFAULT 'SINGLE',
        'confirmed' int NOT NULL DEFAULT '0',
        'public' int NOT NULL DEFAULT '0',
        'flagged' int NOT NULL DEFAULT '0',
        'deleted' int NOT NULL DEFAULT '0',
        'editors' varchar(128) NOT NULL DEFAULT '[]'
      ) """);

      await db.execute("""CREATE TABLE 'courses' (
        'id' int NOT NULL,
        'package_code' varchar(11) NOT NULL,
        'courseID' varchar(20) NOT NULL,
        'name' varchar(50) NOT NULL,
        'description' text NOT NULL,
        'category' varchar(50) NOT NULL,
        'author' varchar(50) NOT NULL DEFAULT 'content@ecoachsolutions.com',
        'time' int NOT NULL DEFAULT '60',
        'created_at' datetime NOT NULL,
        'updated_at' datetime NOT NULL,
        'confirmed' int NOT NULL DEFAULT '0',
        'public' int NOT NULL DEFAULT '0',
        'N' int NOT NULL DEFAULT '0',
        'p' int NOT NULL DEFAULT '0',
        'editors' varchar(128) NOT NULL DEFAULT '[]',
        'level_id' int DEFAULT NULL,
        'subject_id' int NOT NULL
      )""");

      await db.execute("""CREATE TABLE 'plans' (
        'id' int unsigned NOT NULL,
        'tag' varchar(255)  NOT NULL,
        'name' varchar(255)  NOT NULL,
        'description' varchar(255)  DEFAULT NULL,
        'is_active' tinyint(1) NOT NULL DEFAULT '1',
        'price' decimal(8,2) NOT NULL DEFAULT '0.00',
        'signup_fee' decimal(8,2) NOT NULL DEFAULT '0.00',
        'currency' varchar(3)  NOT NULL,
        'trial_period' smallint unsigned NOT NULL DEFAULT '0',
        'trial_interval' varchar(255)  NOT NULL DEFAULT 'day',
        'invoice_period' smallint unsigned NOT NULL DEFAULT '1',
        'invoice_interval' varchar(255)  NOT NULL DEFAULT 'month',
        'tier' mediumint unsigned NOT NULL DEFAULT '0',
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL,
        'deleted_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'answers' (
        'id' int NOT NULL,
        'question_id' int NOT NULL,
        'text' text NOT NULL,
        'value' int DEFAULT '0',
        'solution' text NULL,
        'created_at' datetime NOT NULL,
        'updated_at' datetime NULL,
        'answer_order' int DEFAULT '0',
        'responses' int NULL DEFAULT '0',
        'flagged' int NOT NULL DEFAULT '0',
        'editors' varchar(128) NOT NULL DEFAULT '[]'
      )""");

      await db.execute("""CREATE TABLE notifications (
          id INTEGER PRIMARY KEY,
          data_id INTEGER,
          title TEXT,
          text TEXT,
          type TEXT,
          created_at TEXT
          )""");
    });
  }
}
