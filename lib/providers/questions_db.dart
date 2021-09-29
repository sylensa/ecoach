import 'dart:convert';

import 'package:ecoach/models/question.dart';
import 'package:ecoach/providers/answers.dart';
import 'package:ecoach/providers/database.dart';
import 'package:sqflite/sqflite.dart';

class QuestionDB {
  Future<void> insert(Question question) async {
    if (question == null) {
      return;
    }
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      await txn.insert(
        'questions',
        question.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      List<Answer> answers = question.answers!;
      if (answers.length > 0) {
        answers.forEach((answer) {
          AnswerDB().insert(answer);
        });
      }
    });
  }

  Future<Question?> getQuestionById(int id) async {
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
      List<Answer> answers = element.answers!;
      if (answers.length > 0) {
        answers.forEach((answer) {
          AnswerDB().insert(answer);
        });
      }
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

  Future<Map<int, String>> questionTopics(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('questions',
        orderBy: "created_at DESC",
        columns: ["topic_id", "topic_name"],
        distinct: true,
        where: "course_id = ?",
        whereArgs: [courseId]);
    print(maps);
    Map<int, String> topicNames = Map();
    for (int i = 0; i < maps.length; i++) {
      topicNames[maps[i]['topic_id']] = maps[i]['topic_name'];
    }
    return topicNames;
  }

  Future<List<Question>> getTopicQuestions(List<int> topicIds, limit) async {
    final Database? db = await DBProvider.database;

    String amps = "";
    for (int i = 0; i < topicIds.length; i++) {
      amps += "?";
      if (i < topicIds.length - 1) {
        amps += ",";
      }
    }

    final List<Map<String, dynamic>> maps = await db!.query('questions',
        orderBy: "created_at DESC",
        where: "topic_id IN ($amps)",
        whereArgs: topicIds,
        limit: limit);

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getRandomQuestions(int courseId, int limit) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('questions',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId],
        limit: limit);

    return List.generate(maps.length, (i) {
      return Question.fromJson(maps[i]);
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
