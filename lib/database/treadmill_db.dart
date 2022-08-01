import 'package:ecoach/database/answers.dart';
import 'package:ecoach/database/database.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:sqflite/sqflite.dart';

class TreadmillDB {
  Future<int> insert(Treadmill treadmill) async {
    int id = 0;
    final Database? db = await DBProvider.database;
    await db!.transaction((txn) async {
      id = await txn.insert(
        'treadmills',
        treadmill.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    return id;
  }

  Future<int?> insertProgress(TreadmillProgress progress) async {
    int id = 0;
    final Database? db = await DBProvider.database;
    await db!.transaction((txn) async {
      id = await txn.insert(
        'treadmill_progress',
        progress.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    return id;
  }

  Future<Treadmill?> getTreadmillById(int id) async {
    final db = await DBProvider.database;

    var result = await db!.query(
      "treadmills",
      where: "id = ?",
      whereArgs: [id],
    );
    Treadmill? treadmill = result.isNotEmpty
        ? Treadmill.fromJson(
            result.first,
          )
        : null;

    return treadmill;
  }

  Future<Treadmill?> getTreadmillByCourse(int courseId) async {
    final db = await DBProvider.database;

    var result = await db!.query(
      "treadmills",
      where: "course_id= ? AND type = ?",
      whereArgs: [courseId],
    );
    Treadmill? treadmill = result.isNotEmpty
        ? Treadmill.fromJson(
            result.first,
          )
        : null;

    return treadmill;
  }

  Future<Treadmill?> getAllTreadmill() async {
    final db = await DBProvider.database;

    var result = await db!.query("treadmills");
    Treadmill? treadmill = result.isNotEmpty
        ? Treadmill.fromJson(
            result.first,
          )
        : null;

    return treadmill;
  }

  Future<TreadmillProgress?> getTreadmillProgress(
      int courseId, int questionId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
      'treadmill_progress',
      orderBy: "name ASC",
      where: "course_id = ? AND question_id= ?",
      whereArgs: [courseId, questionId],
    );

    return TreadmillProgress.fromJson(maps[0]);
  }

  Future<List<TreadmillProgress>> getProgresses(int treadmillId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
      'treadmill_progress',
      where: "treadmill_id = ?",
      whereArgs: [treadmillId],
    );

    List<TreadmillProgress> treadmills = [];
    for (int i = 0; i < maps.length; i++) {
      TreadmillProgress progress = TreadmillProgress.fromJson(maps[i]);
      progress.question = await QuestionDB().getQuestionById(
        progress.questionId!,
      );
      if (progress.question != null) {
        if (progress.selectedAnswerId != null) {
          progress.question!.selectedAnswer = await AnswerDB().getAnswerById(
            progress.selectedAnswerId!,
          );
        }
        treadmills.add(progress);
      }
    }
    return treadmills;
  }

  Future<void> insertAll(List<Treadmill> treadmills) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    treadmills.forEach((element) {
      batch.insert(
        'treadmills',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<void> insertAllProgress(List<TreadmillProgress> progresses) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    progresses.forEach((element) {
      batch.insert(
        'treadmill_progress',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<Treadmill>> treadmills() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
      'treadmills',
      orderBy: "name ASC",
    );

    List<Treadmill> treadmills = [];
    for (int i = 0; i < maps.length; i++) {
      Treadmill treadmill = Treadmill.fromJson(maps[i]);
      treadmills.add(treadmill);
    }
    return treadmills;
  }

  Future<Treadmill?> getCurrentTreadmill(Course course) async {
    final db = await DBProvider.database;

    var result = await db!.query(
      "treadmills",
      where: "course_id= ? AND status <> ?  ",
      whereArgs: [course.id!, TreadmillStatus.COMPLETED.toString()],
    );

    Treadmill? treadmill = result.isNotEmpty
        ? Treadmill.fromJson(
            result.first,
          )
        : null;

    return treadmill;
  }

  Future<List<Treadmill>> courseTreadmills(Course course) async {
    final Database? db = await DBProvider.database;
    print("course id = ${course.id}");
    final List<Map<String, dynamic>> maps = await db!.query('treadmills',
        orderBy: "start_time DESC",
        where: "course_id = ? ",
        whereArgs: [course.id]);

    print('course len=${maps.length}');
    List<Treadmill> treadmills = [];
    for (int i = 0; i < maps.length; i++) {
      Treadmill treadmill = Treadmill.fromJson(maps[i]);
      treadmills.add(treadmill);
    }
    return treadmills;
  }

  Future<List<Treadmill>> completedTreadmills(Course course) async {
    final Database? db = await DBProvider.database;
    print("course id = ${course.id}");
    final List<Map<String, dynamic>> maps = await db!.query('treadmills',
        orderBy: "start_time DESC",
        where: "course_id = ? AND status = ? ",
        whereArgs: [course.id, TreadmillStatus.COMPLETED.toString()]);

    print('course len=${maps.length}');
    List<Treadmill> treadmills = [];
    for (int i = 0; i < maps.length; i++) {
      Treadmill treadmill = Treadmill.fromJson(maps[i]);
      treadmills.add(treadmill);
    }
    return treadmills;
  }

  Future<void> update(Treadmill treadmill) async {
    final db = await DBProvider.database;

    await db!.update(
      'treadmills',
      treadmill.toJson(),
      where: "id = ?",
      whereArgs: [treadmill.id],
    );
  }

  Future<void> updateProgress(TreadmillProgress progress) async {
    final db = await DBProvider.database;

    await db!.update(
      'treadmill_progress',
      progress.toJson(),
      where: "id = ?",
      whereArgs: [progress.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'treadmills',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  deleteAll() async {
    final db = await DBProvider.database;
    db!.rawQuery('delete from treadmills');
  }

  deleteProgress(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'treadmill_progress',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
