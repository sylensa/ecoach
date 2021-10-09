import 'dart:convert';

import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/providers/database.dart';
import 'package:ecoach/providers/questions_db.dart';
import 'package:sqflite/sqflite.dart';

import 'answers.dart';

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

  Future<List<Quiz>> getQuizzesByType(int courseId, String type) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('quizzes',
        orderBy: "name ASC",
        where: "type = ? AND course_id = ?",
        whereArgs: [type, courseId]);
    print(courseId);
    return List.generate(maps.length, (i) {
      print(maps[i]);
      return Quiz.fromJson(maps[i]);
    });
  }

  Future<List<Quiz>> getQuizzesByName(int courseId, String name) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('quizzes',
        orderBy: "name ASC",
        where: "type LIKE ? AND course_id = ?",
        whereArgs: [name + "%", courseId]);
    print(courseId);
    return List.generate(maps.length, (i) {
      print(maps[i]);
      return Quiz.fromJson(maps[i]);
    });
  }

  Future<void> insertAll(List<Quiz> quizzes) async {
    final Database? db = await DBProvider.database;
    await db!.transaction((txn) async {
      for (int i = 0; i < quizzes.length; i++) {
        Quiz element = quizzes[i];
        txn.insert(
          'quizzes',
          element.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        List<Question> questions = element.questions!;
        if (questions.length > 0) {
          for (int i = 0; i < questions.length; i++) {
            Question question = questions[i];
            // await txn.delete(
            //   'quiz_items',
            //   where: "quiz_id = ? AND question_id = ?",
            //   whereArgs: [element.id, question.id],
            // );
            txn.insert(
              "quiz_items",
              {'quiz_id': element.id, 'question_id': question.id},
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
            txn.insert(
              'questions',
              question.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
            List<Answer> answers = question.answers!;
            if (answers.length > 0) {
              for (int i = 0; i < answers.length; i++) {
                txn.insert(
                  'answers',
                  answers[i].toJson(),
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );
              }
            }
          }
        }
      }
    });
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

  Future<List<Question>> getQuestions(int quizId, int limit) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM quiz_items WHERE quiz_id = $quizId ORDER BY RANDOM() LIMIT $limit");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question? question =
          await QuestionDB().getQuestionById(maps[i]['question_id']);
      if (question != null) {
        questions.add(question);
      }
    }

    return questions;
  }

  Future<int> getQuestionsCount(int quizId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!
        .query('quiz_items', where: "quiz_id = ?", whereArgs: [quizId]);

    return maps.length;
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
