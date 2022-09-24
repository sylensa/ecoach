import 'dart:convert';

import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/database/answers.dart';
import 'package:ecoach/database/database.dart';
import 'package:sqflite/sqflite.dart';

class QuestionDB {
  Future<void> insert(Question question) async {
    if (question == null) {
      return;
    }
    // print(question.toJson());
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert(
        'questions',
        question.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      Topic? topic = question.topic;
      if (topic != null) {
        await TopicDB().insert(topic);
      }
      List<Answer> answers = question.answers!;
      if (answers.length > 0) {
        for (int i = 0; i < answers.length; i++) {
          await AnswerDB().insert(answers[i]);
        }
      }
    });
  }

  Future<void> insertTestQuestion(Question question) async {
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert(
        'test_saved_questions',
        question.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<void> batchInsert(Batch batch, Question question) async {
    if (question == null) {
      return;
    }
    batch.insert(
      'questions',
      question.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    List<Answer> answers = question.answers!;
    if (answers.length > 0) {
      for (int i = 0; i < answers.length; i++) {
        await AnswerDB().batchInsert(batch, answers[i]);
      }
    }
  }

  Future<Question?> getQuestionById(int id) async {
    final db = await DBProvider.database;
    var result = await db!.query("questions", where: "id = ?", whereArgs: [id]);
    Question? question =
        result.isNotEmpty ? Question.fromJson(result.first) : null;
    if (question != null) {
      question.answers = await AnswerDB().questoinAnswers(question.id!);
    }

    return question;
  }

  Future<List<Question>> getSavedTestQuestion() async {
    final db = await DBProvider.database;
    List<Question> listQuestion = [];
    // await db!.rawQuery("Delete from test_saved_questions");
    List<Map<String, dynamic>> timelineResponse =
        await db!.rawQuery("Select * from test_saved_questions");
    print("timelineResponse:$timelineResponse");
    if (timelineResponse.isNotEmpty) {
      for (int i = 0; i < timelineResponse.length; i++) {
        Question? question = Question.fromJson(timelineResponse[i]);
        if (question != null) {
          question.answers = await AnswerDB().questoinAnswers(question.id!);
        }
        listQuestion.add(question);
      }
    }

    return listQuestion;
  }

  Future<Question?> getSavedTestQuestionById(int id) async {
    final db = await DBProvider.database;
    var result = await db!
        .query("test_saved_questions", where: "id = ?", whereArgs: [id]);
    Question? question =
        result.isNotEmpty ? Question.fromJson(result.first) : null;
    if (question != null) {
      question.answers = await AnswerDB().questoinAnswers(question.id!);
    }

    return question;
  }

  Future<List<Question>> getSavedTestQuestionsByType(int courseId,
      {int limit = 10}) async {
    final Database? db = await DBProvider.database;

    // final List<Map<String, dynamic>> maps = await db!.query('test_saved_questions',
    //     orderBy: "created_at DESC",
    //     where: "course_id = ?",
    //     whereArgs: [courseId],);

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM test_saved_questions WHERE course_id = $courseId ORDER BY RANDOM() LIMIT $limit");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<void> insertAll(List<Question> questions) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    questions.forEach((element) async {
      // print(element.toJson());
      batch.insert(
        'questions',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      Topic? topic = element.topic;
      if (topic != null) {
        await TopicDB().insert(topic);
      }
      List<Answer> answers = element.answers!;
      if (answers.length > 0) {
        answers.forEach((answer) async {
          await AnswerDB().insert(answer);
        });
      }
    });

    await batch.commit(noResult: true);
  }

  Future<List<Question>> questions() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('questions',
        where: "qtype = ?", whereArgs: ['SINGLE'], orderBy: "created_at DESC");

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
        orderBy: "topic_name ASC",
        columns: ["topic_id", "topic_name"],
        distinct: true,
        where: "course_id = ? AND qtype = ?",
        whereArgs: [courseId, 'SINGLE']);

    Map<int, String> topicNames = Map();
    for (int i = 0; i < maps.length; i++) {
      topicNames[maps[i]['topic_id']] = maps[i]['topic_name'];
    }
    return topicNames;
  }

  Future<int> getTopicCount(int topicId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
      'questions',
      where: "topic_id = ?",
      whereArgs: [topicId],
    );

    return maps.length;
  }

  Future<List<Question>> getTopicQuestions(List<int> topicIds, limit) async {
    final Database? db = await DBProvider.database;

    String amps = "";
    for (int i = 0; i < topicIds.length; i++) {
      amps += "${topicIds[i]}";
      if (i < topicIds.length - 1) {
        amps += ",";
      }
    }

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND topic_id IN ($amps) ORDER BY RANDOM() LIMIT $limit");

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

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND course_id = $courseId ORDER BY RANDOM() LIMIT $limit");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getMasteryQuestions(int courseId, int limit) async {
    final Database? db = await DBProvider.database;

    Course? course = await CourseDB().getCourseById(courseId);
    if (course == null) {
      return [];
    }
    List<Topic>? topics = await TopicDB().courseTopics(course);
    print("topic length=${topics.length}");
    List<Question> questions = [];
    for (int i = 0; i < topics.length; i++) {
      questions.addAll(await getMasteryTopicQuestions(topics[i].id!, 4));
    }

    return questions;
  }

  Future<List<Question>> getMasteryTopicQuestions(
      int topicId, int limit) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND topic_id = $topicId ORDER BY RANDOM() LIMIT $limit");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getMarathonQuestions(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
      "SELECT * FROM questions WHERE qtype = 'SINGLE' AND course_id = $courseId ORDER BY RANDOM()",
    );

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getMarathonTopicQuestions(int topicId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND topic_id = $topicId ORDER BY RANDOM()");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getTreadmillQuestions(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
      "SELECT * FROM questions WHERE qtype = 'SINGLE' AND course_id = $courseId ORDER BY RANDOM()",
    );

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getTreadmillTopicQuestions(int topicId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND topic_id = $topicId ORDER BY RANDOM()");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getTreadmillBankQuestions(int bankId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND bank_id = $bankId ORDER BY RANDOM()");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getAutopilotTopicQuestions(int topicId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND topic_id = $topicId ORDER BY RANDOM()");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getQuestionsByType(
    int courseId,
    String type,
    int limit,
  ) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('questions',
        orderBy: "created_at DESC",
        where: "course_id = ? AND qtype = ?",
        whereArgs: [courseId, type],
        limit: limit);

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<int> getTotalQuestionCount(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
      'questions',
      where: "course_id = ?",
      whereArgs: [courseId],
    );

    return maps.length;
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

  deleteAllQuestions() async {
    final db = await DBProvider.database;
    db!.delete('questions');
  }

  deleteSavedTest(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'test_saved_questions',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  deleteAllSavedTest() async {
    final db = await DBProvider.database;
    db!.delete('test_saved_questions');
  }

  deleteSavedTestByCourseId(int id) async {
    final db = await DBProvider.database;
    db!.rawQuery("Delete from test_saved_questions where course_id = $id");
  }

  // getRevisionLevelQuestions(Course course, ){

  // }
}
