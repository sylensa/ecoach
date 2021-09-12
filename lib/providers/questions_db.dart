import 'dart:convert';

import 'package:ecoach/models/question.dart';
import 'package:ecoach/providers/database.dart';
import 'package:sqflite/sqflite.dart';

class QuestionDB {
  Future<void> insert(Question question) async {
    if (question == null) {
      return;
    }
    final Database? db = await DBProvider.database;

    await db!.insert(
      'questions',
      question.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Question?> getMessageById(int id) async {
    final db = await DBProvider.database;
    var result = await db!.query("questions", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Question.fromJson(result.first) : null;
  }

  Future<void> insertAll(List<Question> questions) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    questions.forEach((element) {
      batch.insert(
        'questions',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<Question>> questions() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('questions', orderBy: "created_at DESC");

    return List.generate(maps.length, (i) {
      return Question(
        id: maps[i]["id"],
        courseId: maps[i]["course_id"],
        topicId: maps[i]["topic_id"],
        qid: maps[i]["qid"],
        text: maps[i]["text"],
        instructions: maps[i]["instructions"],
        resource: maps[i]["resource"],
        options: maps[i]["options"],
        position: maps[i]["position"],
        createdAt: DateTime.parse(maps[i]["created_at"]),
        updatedAt: DateTime.parse(maps[i]["updated_at"]),
        qtype: maps[i]["qtype"],
      );
    });
  }

  Future<void> update(Question question) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'questions',
      question.toJson(),
      where: "id = ?",
      whereArgs: [question.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'questions',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
