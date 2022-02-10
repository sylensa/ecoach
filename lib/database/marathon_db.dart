import 'package:ecoach/database/database.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:sqflite/sqflite.dart';

class MarathonDB {
  Future<void> insert(Marathon marathon) async {
    // print(marathon.toJson());
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert(
        'marathons',
        marathon.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<void> insertProgress(MarathonProgress progress) async {
    // print(marathon.toJson());
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert(
        'marathon_progress',
        progress.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<Marathon?> getMarathonById(int id) async {
    final db = await DBProvider.database;

    var result = await db!.query("marathons", where: "id = ?", whereArgs: [id]);
    Marathon? marathon =
        result.isNotEmpty ? Marathon.fromJson(result.first) : null;

    return marathon;
  }

  Future<Marathon?> getMarathonByCourse(int courseId) async {
    final db = await DBProvider.database;

    var result = await db!.query("marathons",
        where: "course_id= ? AND type = ?", whereArgs: [courseId]);
    Marathon? marathon =
        result.isNotEmpty ? Marathon.fromJson(result.first) : null;

    return marathon;
  }

  Future<MarathonProgress?> getMarathonProgress(int courseId, int level) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('marathon_progress',
        orderBy: "name ASC",
        where: "course_id = ? AND level= ?",
        whereArgs: [courseId, level]);

    if (level > maps.length || level < 1) {
      return null;
    }

    return MarathonProgress.fromJson(maps[level - 1]);
  }

  Future<List<MarathonProgress>> getProgresses(int marathonId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('marathon_progress',
        where: "marathon_id = ?", whereArgs: [marathonId]);

    List<MarathonProgress> marathons = [];
    for (int i = 0; i < maps.length; i++) {
      MarathonProgress progress = MarathonProgress.fromJson(maps[i]);
      progress.question =
          await QuestionDB().getQuestionById(progress.questionId!);
      marathons.add(progress);
    }
    return marathons;
  }

  Future<void> insertAll(List<Marathon> marathons) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    marathons.forEach((element) {
      // print(element.toJson());
      batch.insert(
        'marathons',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<Marathon>> marathons() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('marathons', orderBy: "name ASC");

    List<Marathon> marathons = [];
    for (int i = 0; i < maps.length; i++) {
      Marathon marathon = Marathon.fromJson(maps[i]);
      marathons.add(marathon);
    }
    return marathons;
  }

  Future<List<Marathon>> courseMarathons(Course course) async {
    final Database? db = await DBProvider.database;
    print("course id = ${course.id}");
    final List<Map<String, dynamic>> maps = await db!.query('marathons',
        orderBy: "name ASC",
        where: "course_id = ? AND notes <> '' ",
        whereArgs: [course.id]);

    print('course len=${maps.length}');
    List<Marathon> marathons = [];
    for (int i = 0; i < maps.length; i++) {
      Marathon marathon = Marathon.fromJson(maps[i]);
      marathons.add(marathon);
    }
    return marathons;
  }

  Future<void> update(Marathon marathon) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'marathons',
      marathon.toJson(),
      where: "id = ?",
      whereArgs: [marathon.id],
    );
  }

  Future<void> updateProgress(MarathonProgress progress) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'marathon_progress',
      progress.toJson(),
      where: "id = ?",
      whereArgs: [progress.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'marathons',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
