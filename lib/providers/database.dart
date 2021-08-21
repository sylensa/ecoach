import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  AuthController authController = Get.find<AuthController>();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    User user = authController.user();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "${user.uuid}.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE questions ("
          "id INTEGER PRIMARY KEY,"
          "question TEXT,"
          "subject_id INTEGER,"
          "topic_id INTEGER,"
          "type TEXT,"
          ")");

      await db.execute("CREATE TABLE answers ("
          "id INTEGER PRIMARY KEY,"
          "question_id TEXT,"
          "answer TEXT,"
          "is_correct INTEGER,"
          "type TEXT,"
          ")");
    });
  }

  Future<void> insertQuestion(Question question) async {
    final Database db = await database;

    await db.insert(
      'questions',
      question.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Question>> questions() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('questions');

    return List.generate(maps.length, (i) {
      return Question(
        id: maps[i]['id'],
        question: maps[i]['question'],
        subjectId: maps[i]['subjectId'],
        type: maps[i]['type'],
        topicId: maps[i]['topicId'],
      );
    });
  }

  Future<void> updateQuestion(Question question) async {
    final db = _database;

    await db.update(
      'questions',
      question.toMap(),
      where: "id = ?",
      whereArgs: [question.id],
    );
  }

  Future<void> deleteQuestion(int id) async {
    final db = _database;
    await db.delete(
      'questions',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
