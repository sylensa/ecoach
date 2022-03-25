import 'package:ecoach/database/answers.dart';
import 'package:ecoach/database/database.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/views/learn_mode.dart';
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

  Future<int?> insertProgress(AutopilotProgress progress) async {
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

  Future<AutopilotProgress?> getAutopilotProgress(
      int courseId, int questionId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
        'autopilot_progress',
        orderBy: "name ASC",
        where: "course_id = ? AND question_id= ?",
        whereArgs: [courseId, questionId]);

    return AutopilotProgress.fromJson(maps[0]);
  }

  Future<List<AutopilotProgress>> getProgresses(int autopilotId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
        'autopilot_progress',
        where: "autopilot_id = ?",
        whereArgs: [autopilotId]);

    List<AutopilotProgress> autopilots = [];
    for (int i = 0; i < maps.length; i++) {
      AutopilotProgress progress = AutopilotProgress.fromJson(maps[i]);
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

  Future<void> insertAllProgress(List<AutopilotProgress> progresses) async {
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

    await db!.update(
      'autopilots',
      autopilot.toJson(),
      where: "id = ?",
      whereArgs: [autopilot.id],
    );
  }

  Future<void> updateProgress(AutopilotProgress progress) async {
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
    db!.delete(
      'autopilots',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  deleteProgress(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'autopilot_progress',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
