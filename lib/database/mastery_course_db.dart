import 'package:ecoach/database/database.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/mastery_course.dart';
import 'package:ecoach/models/study.dart';
import 'package:sqflite/sqflite.dart';

class MasteryCourseDB {
  Future<void> insert(MasteryCourse mc) async {
    // print(study.toJson());
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert(
        'mastery_courses',
        mc.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<void> insertProgress(MasteryCourse progress) async {
    // print(study.toJson());
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert(
        'mastery_courses',
        progress.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<MasteryCourse?> getMasteryCourse(int studyId, int level) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('mastery_courses',
        orderBy: "level ASC",
        where: "study_id = ? AND level= ?",
        whereArgs: [studyId, level]);

    if (level > maps.length || level < 1) {
      return null;
    }

    return MasteryCourse.fromJson(maps[level - 1]);
  }

  Future<List<MasteryCourse>> getMasteryTopics(int studyId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('mastery_courses',
        orderBy: "created_at ASC",
        where: "study_id = ? AND passed = false",
        whereArgs: [studyId]);

    List<MasteryCourse> mc = [];
    for (int i = 0; i < maps.length; i++) {
      MasteryCourse progress = MasteryCourse.fromJson(maps[i]);
      mc.add(progress);
    }
    return mc;
  }

  Future<MasteryCourse?> getCurrentTopic(int studyId) async {
    final Database? db = await DBProvider.database;

    var result = await db!.query('mastery_courses',
        orderBy: "created_at DESC",
        where: "study_id = ? AND passed = ?",
        whereArgs: [studyId, false],
        limit: 1);

    MasteryCourse? progress =
        result.isNotEmpty ? MasteryCourse.fromJson(result.first) : null;
    return progress;
  }

  Future<void> insertAll(List<MasteryCourse> masteryCourses) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    masteryCourses.forEach((element) {
      // print(element.toJson());
      batch.insert(
        'mastery_courses',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<Study>> courseTopics(Course course) async {
    final Database? db = await DBProvider.database;
    print("course id = ${course.id}");
    final List<Map<String, dynamic>> maps = await db!.query('mastery_courses',
        orderBy: "created_at ASC",
        where: "course_id = ? AND notes <> '' ",
        whereArgs: [course.id]);

    print('course len=${maps.length}');
    List<Study> mc = [];
    for (int i = 0; i < maps.length; i++) {
      Study study = Study.fromJson(maps[i]);
      mc.add(study);
    }
    return mc;
  }

  Future<void> updateProgress(MasteryCourse mc) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'mastery_courses',
      mc.toJson(),
      where: "id = ?",
      whereArgs: [mc.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'mastery_courses',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
