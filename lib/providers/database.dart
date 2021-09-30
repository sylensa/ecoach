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
    String path = join(documentsDirectory.path, "ecoach31.db");
    return await openDatabase(path, version: 8, onOpen: (db) {},
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
        'id' INTEGER PRIMARY KEY,
        'name' varchar(50) NOT NULL,
        'code' varchar(10) NOT NULL,
        'category' varchar(50) NOT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'questions' (
        'id' INTEGER PRIMARY KEY,
        'course_id' int NOT NULL,
        'topic_id' int NOT NULL,
        'topic_name' text NULL,
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
        'deleted' int NOT NULL DEFAULT '0'
      ) """);

      await db.execute("""CREATE TABLE 'courses' (
        'id' INTEGER PRIMARY KEY,
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
        'level_id' int DEFAULT NULL
      )""");

      await db.execute("""CREATE TABLE 'plans' (
        'id' INTEGER PRIMARY KEY,
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
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'answers' (
        'id' INTEGER PRIMARY KEY,
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

      await db.execute("""CREATE TABLE 'subscriptions' (
        'id' INTEGER PRIMARY KEY,
        'tag' varchar(255) NOT NULL,
        'subscriber_type' varchar(255) NOT NULL,
        'subscriber_id' bigint unsigned NOT NULL,
        'plan_id' int unsigned DEFAULT NULL,
        'name' varchar(255) DEFAULT NULL,
        'description' varchar(255) DEFAULT NULL,
        'price' decimal(8,2) NOT NULL DEFAULT '0.00',
        'currency' varchar(3) NOT NULL,
        'invoice_period' smallint unsigned NOT NULL DEFAULT '1',
        'invoice_interval' varchar(255) NOT NULL DEFAULT 'month',
        'tier' mediumint unsigned NOT NULL DEFAULT '0',
        'trial_ends_at' timestamp NULL DEFAULT NULL,
        'starts_at' timestamp NULL DEFAULT NULL,
        'ends_at' timestamp NULL DEFAULT NULL,
        'cancels_at' timestamp NULL DEFAULT NULL,
        'canceled_at' timestamp NULL DEFAULT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      )""");

      await db.execute("""CREATE TABLE 'subscription_items' (
        'id' INTEGER PRIMARY KEY,
        'tag' varchar(255) NOT NULL,
        'plan_id' int unsigned NOT NULL,
        'name' varchar(255) NOT NULL,
        'description' varchar(255) DEFAULT NULL,
        'value' varchar(255) NOT NULL,
        'resettable_period' smallint unsigned NOT NULL DEFAULT '0',
        'resettable_interval' varchar(255) NOT NULL DEFAULT 'month',
        'sort_order' mediumint unsigned NOT NULL DEFAULT '0',
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'quizzes' (
        'id' INTEGER PRIMARY KEY,
        'course_id' int NOT NULL,
        'topic_id' int NOT NULL,
        'testID' varchar(50) DEFAULT '0000000000',
        'type' varchar(20) NOT NULL DEFAULT 'DEFINED',
        'name' varchar(50) NOT NULL,
        'author' varchar(50) NOT NULL DEFAULT 'content@ecoachsolutions.com',
        'time' int NOT NULL DEFAULT '0',
        'description' text NULL,
        'category' varchar(255) NOT NULL,
        'instructions' text NOT NULL,
        'start_time' datetime NOT NULL,
        'end_time' datetime NOT NULL,
        'created_at' datetime NOT NULL,
        'updated_at' datetime NOT NULL,
        'confirmed' int NOT NULL DEFAULT '0',
        'public' int NOT NULL DEFAULT '0'
      ) """);

      await db.execute("""CREATE TABLE 'quiz_items' (
        'id' INTEGER PRIMARY KEY,
        'question_id' int NOT NULL,
        'quiz_id' int NOT NULL
      ) """);

      await db.execute("""CREATE TABLE 'tests_taken' (
        'id' INTEGER PRIMARY KEY,
        'user_id' int NOT NULL,
        'date_time' varchar(255) NOT NULL,
        'course_id' int NOT NULL,
        'test_name' varchar(255) DEFAULT NULL,
        'test_type' varchar(255) DEFAULT NULL,
        'test_id' int DEFAULT NULL,
        'test_time' int DEFAULT NULL,
        'used_time' int DEFAULT NULL,
        'pause_duration' int DEFAULT NULL,
        'total_questions' int NOT NULL,
        'score' double NOT NULL,
        'correct' int NOT NULL,
        'wrong' int NOT NULL,
        'unattempted' int NOT NULL,
        'responses' LONGTEXT NOT NULL,
        'comment' text DEFAULT NULL,
        'user_rank' int NULL,
        'total_rank' int NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE notifications (
          id INTEGER PRIMARY KEY,
          data_id INTEGER,
          title TEXT,
          text TEXT,
          type TEXT,
          created_at TEXT
          )""");

      await db.execute("""
            CREATE TABLE courses_levels (
              id INTEGER PRIMARY KEY, 
              course_id INTEGER NOT NULL,
              level_id INTEGER NOT NULL,
              FOREIGN KEY (course_id) REFERENCES courses (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION,
              FOREIGN KEY (level_id) REFERENCES levels (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
            )""");
    }, onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < newVersion) {
        // you can execute drop table and create table
      }
    });
  }
}
