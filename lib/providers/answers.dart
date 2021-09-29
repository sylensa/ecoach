import 'dart:convert';

import 'package:ecoach/models/question.dart';
import 'package:ecoach/providers/database.dart';
import 'package:sqflite/sqflite.dart';

class AnswerDB {
  Future<void> insert(Answer answer) async {
    if (answer == null) {
      return;
    }
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      await txn.insert(
        'answers',
        answer.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<Answer?> getAnswerById(int id) async {
    final db = await DBProvider.database;
    var result = await db!.query("answers", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Answer.fromJson(result.first) : null;
  }

  Future<void> insertAll(List<Answer> answers) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    answers.forEach((element) {
      print(element.toJson());
      batch.insert(
        'answers',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<Answer>> answers() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('answers', orderBy: "created_at DESC");

    return List.generate(maps.length, (i) {
      return Answer(
        id: maps[i]["id"],
        questionId: maps[i]["question_id"],
        value: maps[i]["value"],
        answerOrder: maps[i]["answer_order"],
        text: maps[i]["text"],
        solution: maps[i]["solution"],
        responses: maps[i]["responses"],
        flagged: maps[i]["flagged"],
        createdAt: DateTime.parse(maps[i]["created_at"]),
        updatedAt: DateTime.parse(maps[i]["updated_at"]),
      );
    });
  }

  Future<List<Answer>> questoinAnswers(int questionId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('answers',
        orderBy: "created_at DESC",
        where: 'question_id = ?',
        whereArgs: [questionId]);

    return List.generate(maps.length, (i) {
      return Answer(
        id: maps[i]["id"],
        questionId: maps[i]["question_id"],
        value: maps[i]["value"],
        answerOrder: maps[i]["answer_order"],
        text: maps[i]["text"],
        solution: maps[i]["solution"],
        responses: maps[i]["responses"],
        flagged: maps[i]["flagged"],
        createdAt: DateTime.parse(maps[i]["created_at"]),
        updatedAt: DateTime.parse(maps[i]["updated_at"]),
      );
    });
  }

  Future<void> update(Answer answer) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'answers',
      answer.toJson(),
      where: "id = ?",
      whereArgs: [answer.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'answers',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
