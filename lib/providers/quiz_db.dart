import 'dart:convert';

import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/providers/database.dart';
import 'package:ecoach/providers/questions_db.dart';
import 'package:sqflite/sqflite.dart';

class QuizDB {
  Future<void> insert(Quiz quiz) async {
    if (quiz == null) {
      return;
    }
    final Database? db = await DBProvider.database;

    await db!.insert(
      'quizzes',
      quiz.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Quiz?> getQuizById(int id) async {
    final db = await DBProvider.database;
    var result = await db!.query("quizzes", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Quiz.fromJson(result.first) : null;
  }

  Future<void> insertAll(List<Quiz> quizzes) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    quizzes.forEach((element) {
      batch.insert(
        'quizzes',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      List<Question> questions = element.questions!;
      if (questions.length > 0) {
        questions.forEach((question) {
          print({'quiz_id': element.id, 'question_id': question.id});
          db.delete(
            'quiz_items',
            where: "quiz_id = ? AND question_id = ?",
            whereArgs: [element.id, question.id],
          );
          batch.insert(
            "courses_levels",
            {'quiz_id': element.id, 'question_id': question.id},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          QuestionDB().insert(question);
        });
      }
    });

    await batch.commit(noResult: true);
  }

  Future<List<Quiz>> quizzes() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('quizzes', orderBy: "created_at DESC");

    return List.generate(maps.length, (i) {
      return Quiz(
        id: maps[i]["id"],
        courseId: maps[i]["course_id"],
        topicId: maps[i]["topic_id"],
        name: maps[i]["qid"],
        description: maps[i]["description"],
        instructions: maps[i]["instructions"],
        type: maps[i]["type"],
        time: maps[i]["time"],
        startTime: maps[i]["start_time"],
        endTime: maps[i]["end_time"],
        author: maps[i]["author"],
        testId: maps[i]["test_id"],
        confirmed: maps[i]["confirmed"],
        category: maps[i]["category"],
        createdAt: DateTime.parse(maps[i]["created_at"]),
        updatedAt: DateTime.parse(maps[i]["updated_at"]),
      );
    });
  }

  Future<void> update(Quiz quiz) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'quizzes',
      quiz.toJson(),
      where: "id = ?",
      whereArgs: [quiz.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'quizzes',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
