import 'dart:convert';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/database.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class TestTakenDB {
  Future<int> insert(TestTaken testTaken) async {
    final Database? db = await DBProvider.database;

    int id = await db!.insert(
      'tests_taken',
      testTaken.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<TestTaken?> getTestTakenById(int id) async {
    final db = await DBProvider.database;
    var result =
        await db!.query("tests_taken", where: "id = ?", whereArgs: [id]);

    return result.isNotEmpty ? TestTaken.fromJson(result.last) : null;
  }

  Future<double> getAverageScore(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
      'tests_taken',
      orderBy: "created_at DESC",
      where: "course_id = ?",
      whereArgs: [courseId],
    );

    double totalScores = 0;

    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      totalScores += test.score!;
    }

    if (maps.length == 0) return 0;
    return totalScores / maps.length;
  }

  Future<double> getExamAverageScore(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
      'tests_taken',
      orderBy: "created_at DESC",
      where:
          "course_id = ? AND challenge_type = ${TestCategory.EXAM.toString()}",
      whereArgs: [courseId],
    );

    double totalScores = 0;

    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      totalScores += test.score!;
    }

    if (maps.length == 0) return 0;
    return totalScores / maps.length;
  }

  Future<void> insertAll(List<TestTaken> testsTaken) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    testsTaken.forEach((element) {
      batch.insert(
        'tests_taken',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<TestTaken>> testsTaken({String? search, int? limit}) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!
        .query('tests_taken', orderBy: "created_at DESC", limit: limit);

    List<TestTaken> tests = [];
    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      Course? course = await CourseDB().getCourseById(test.courseId!);

      if (course != null) {
        test.courseName = course.name!;
        tests.add(test);
      }
    }

    if (search != null) {
      tests = tests
          .where((test) =>
              test.testname!.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    return tests;
  }

  Future<List<TestTaken>> courseTestsTaken(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('tests_taken',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId]);

    List<TestTaken> tests = [];
    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      print(test.toJson().toString().substring(0, 100));
      tests.add(test);
    }
    return tests;
  }

  Future<TestTaken?> courseLastTest(int courseId) async {
    final Database? db = await DBProvider.database;

    var result = await db!.query('tests_taken',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId]);

    return result.isNotEmpty ? TestTaken.fromJson(result.last) : null;
  }

  Future<void> update(TestTaken testTaken) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'tests_taken',
      testTaken.toJson(),
      where: "id = ?",
      whereArgs: [testTaken.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'tests_taken',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
