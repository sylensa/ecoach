import 'dart:convert';
import 'package:ecoach/models/course_analysis.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/database/database.dart';
import 'package:sqflite/sqflite.dart';

class AnalysisDB {
  Future<void> insert(CourseAnalytic courseAnalytic) async {
    final Database? db = await DBProvider.database;

    print("++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print(courseAnalytic.toJson());
    await db!.insert(
      'analysis',
      courseAnalytic.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<CourseAnalytic?> getAnalysisById(int id) async {
    final db = await DBProvider.database;
    var result = await db!.query("analysis", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? CourseAnalytic.fromDB(result.last) : null;
  }

  Future<void> insertAll(List<CourseAnalytic> testsTaken) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    testsTaken.forEach((element) {
      batch.insert(
        'analysis',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<CourseAnalytic>> testsTaken() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('analysis', orderBy: "created_at DESC");

    return List.generate(maps.length, (i) {
      return CourseAnalytic.fromJson(maps[i]);
    });
  }

  Future<List<CourseAnalytic>> courseTestsTaken(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('analysis',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId]);

    return List.generate(maps.length, (i) {
      return CourseAnalytic.fromJson(maps[i]);
    });
  }

  Future<CourseAnalytic?> courseLastTest(int courseId) async {
    final Database? db = await DBProvider.database;

    var result = await db!.query('analysis',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId]);

    return result.isNotEmpty ? CourseAnalytic.fromJson(result.last) : null;
  }

  Future<void> update(CourseAnalytic courseAnalytic) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'analysis',
      courseAnalytic.toJson(),
      where: "id = ?",
      whereArgs: [courseAnalytic.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'analysis',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
