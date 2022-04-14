import 'package:ecoach/database/answers.dart';
import 'package:ecoach/database/database.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/views/learn/learn_mode.dart';
import 'package:sqflite/sqflite.dart';
// TODO: remove marathon imports

import 'package:ecoach/models/autopilot.dart';

class AutopilotDB {
  Future<int> insert(Autopilot autopilot) async {
    // print(autopilot.toJson());
    int id = 0;
    final Database? db = await DBProvider.database;
    await db!.transaction((txn) async {
      id = await txn.insert(
        'autopilots',
        autopilot.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    return id;
  }

  Future<int?> insertProgress(AutopilotQuestion progress) async {
    // print(autopilot.toJson());
    int id = 0;
    final Database? db = await DBProvider.database;
    await db!.transaction((txn) async {
      id = await txn.insert(
        'autopilot_progress',
        progress.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    return id;
  }

  Future<int?> insertAutopilotTopic(AutopilotTopic topic) async {
    int id = 0;
    final Database? db = await DBProvider.database;
    await db!.transaction((txn) async {
      id = await txn.insert(
        'autopilot_topics',
        topic.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    return id;
  }

  Future<Autopilot?> getAutopilotById(int id) async {
    final db = await DBProvider.database;

    var result =
        await db!.query("autopilots", where: "id = ?", whereArgs: [id]);
    Autopilot? autopilot =
        result.isNotEmpty ? Autopilot.fromJson(result.first) : null;

    return autopilot;
  }

  Future<Autopilot?> getAutopilotByCourse(int courseId) async {
    final db = await DBProvider.database;

    var result = await db!.query("autopilots",
        where: "course_id= ? AND type = ?", whereArgs: [courseId]);
    Autopilot? autopilot =
        result.isNotEmpty ? Autopilot.fromJson(result.first) : null;

    return autopilot;
  }

  Future<List<AutopilotTopic>> getAutoPilotTopics(int autopilotId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('autopilot_topics',
        where: "autopilot_id = ?", whereArgs: [autopilotId]);

    List<AutopilotTopic> autopilots = [];
    for (int i = 0; i < maps.length; i++) {
      AutopilotTopic topic = AutopilotTopic.fromJson(maps[i]);
      topic.topic = await TopicDB().getTopicById(topic.topicId!);
      if (topic.topic != null) {
        autopilots.add(topic);
      }
    }
    return autopilots;
  }

  Future<AutopilotQuestion?> getAutopilotProgress(
      int courseId, int questionId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
        'autopilot_progress',
        orderBy: "name ASC",
        where: "course_id = ? AND question_id= ?",
        whereArgs: [courseId, questionId]);

    return AutopilotQuestion.fromJson(maps[0]);
  }

  Future<List<AutopilotQuestion>> getProgresses(int topicId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
        'autopilot_progress',
        where: "topic_id = ?",
        whereArgs: [topicId]);

    List<AutopilotQuestion> autopilots = [];
    for (int i = 0; i < maps.length; i++) {
      AutopilotQuestion progress = AutopilotQuestion.fromJson(maps[i]);
      progress.question =
          await QuestionDB().getQuestionById(progress.questionId!);
      if (progress.question != null) {
        if (progress.selectedAnswerId != null) {
          progress.question!.selectedAnswer =
              await AnswerDB().getAnswerById(progress.selectedAnswerId!);
        }

        autopilots.add(progress);
      }
    }
    return autopilots;
  }

  Future<List<AutopilotQuestion>> getTopicProgresses(int topicId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
        'autopilot_progress',
        where: "topic_id = ?",
        whereArgs: [topicId]);

    List<AutopilotQuestion> autopilots = [];
    for (int i = 0; i < maps.length; i++) {
      AutopilotQuestion progress = AutopilotQuestion.fromJson(maps[i]);
      progress.question =
          await QuestionDB().getQuestionById(progress.questionId!);
      if (progress.question != null) {
        if (progress.selectedAnswerId != null) {
          progress.question!.selectedAnswer =
              await AnswerDB().getAnswerById(progress.selectedAnswerId!);
        }

        autopilots.add(progress);
      }
    }
    return autopilots;
  }

  Future<void> insertAll(List<Autopilot> autopilots) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    autopilots.forEach((element) {
      // print(element.toJson());
      batch.insert(
        'autopilots',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<void> insertAllProgress(List<AutopilotQuestion> progresses) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    progresses.forEach((element) {
      // print(element.toJson());
      batch.insert(
        'autopilot_progress',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<Autopilot>> autopilot() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('autopilots', orderBy: "name ASC");

    List<Autopilot> autopilots = [];
    for (int i = 0; i < maps.length; i++) {
      Autopilot autopilot = Autopilot.fromJson(maps[i]);
      autopilots.add(autopilot);
    }
    return autopilots;
  }

  Future<Autopilot?> getCurrentAutopilot(Course course) async {
    final db = await DBProvider.database;

    var result = await db!.query("autopilots",
        where: "course_id= ? AND status <> ? ",
        whereArgs: [course.id!, AutopilotStatus.COMPLETED.toString()]);

    Autopilot? autopilot =
        result.isNotEmpty ? Autopilot.fromJson(result.first) : null;

    return autopilot;
  }

  Future<List<Autopilot>> courseAutopilots(Course course) async {
    final Database? db = await DBProvider.database;
    print("course id = ${course.id}");
    final List<Map<String, dynamic>> maps = await db!.query('autopilots',
        orderBy: "start_time DESC",
        where: "course_id = ? ",
        whereArgs: [course.id]);

    print('course len=${maps.length}');
    List<Autopilot> autopilots = [];
    for (int i = 0; i < maps.length; i++) {
      Autopilot autopilot = Autopilot.fromJson(maps[i]);
      autopilots.add(autopilot);
    }
    return autopilots;
  }

  Future<List<Autopilot>> completedAutopilots(Course course) async {
    final Database? db = await DBProvider.database;
    print("course id = ${course.id}");
    final List<Map<String, dynamic>> maps = await db!.query('autopilots',
        orderBy: "start_time DESC",
        where: "course_id = ? AND status = ? ",
        whereArgs: [course.id, AutopilotStatus.COMPLETED.toString()]);

    print('course len=${maps.length}');
    List<Autopilot> autopilots = [];
    for (int i = 0; i < maps.length; i++) {
      Autopilot autopilot = Autopilot.fromJson(maps[i]);
      autopilots.add(autopilot);
    }
    return autopilots;
  }

  Future<void> update(Autopilot autopilot) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;
    print("ending topic and updating...");
    print(autopilot.toJson());
    await db!.update(
      'autopilots',
      autopilot.toJson(),
      where: "id = ?",
      whereArgs: [autopilot.id],
    );
  }

  Future<void> updateTopic(AutopilotTopic autopilot) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'autopilot_topics',
      autopilot.toJson(),
      where: "id = ?",
      whereArgs: [autopilot.id],
    );
  }

  Future<void> updateProgress(AutopilotQuestion progress) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'autopilot_progress',
      progress.toJson(),
      where: "id = ?",
      whereArgs: [progress.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    await db!.delete(
      'autopilots',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  deleteTopic(int id) async {
    final db = await DBProvider.database;
    int num = await db!.delete(
      'autopilot_topics',
      where: "topic_id = ?",
      whereArgs: [id],
    );
    print("$num topics deleted");
    return num;
  }

  deleteProgress(int id) async {
    final db = await DBProvider.database;
    await db!.delete(
      'autopilot_progress',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
