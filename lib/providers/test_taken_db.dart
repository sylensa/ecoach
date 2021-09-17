import 'dart:convert';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/providers/database.dart';
import 'package:sqflite/sqflite.dart';

class TestTakenDB {
  Future<void> insert(TestTaken testTaken) async {
    final Database? db = await DBProvider.database;

    await db!.insert(
      'tests_taken',
      testTaken.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<TestTaken?> getTestTakenById(int id) async {
    final db = await DBProvider.database;
    var result =
        await db!.query("tests_taken", where: "id = ?", whereArgs: [id]);

    return result.isNotEmpty ? TestTaken.fromJson(result.last) : null;
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

  Future<List<TestTaken>> testsTaken() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('tests_taken', orderBy: "created_at DESC");

    return List.generate(maps.length, (i) {
      return TestTaken(
        id: maps[i]["id"],
        courseId: maps[i]["course_id"],
        testname: maps[i]["test_name"],
        testType: maps[i]["test_type"],
        testId: maps[i]["test_id"],
        userId: maps[i]["user_id"],
        datetime: maps[i]["date_time"],
        pauseduration: maps[i]["pause_duration"],
        usedtime: maps[i]["used_time"],
        testTime: maps[i]["test_time"],
        totalQuestions: maps[i]["total_questions"],
        score: maps[i]["score"],
        wrong: maps[i]["wrong"],
        unattempted: maps[i]["unattempted"],
        responses: maps[i]["responses"],
        comment: maps[i]["comment"],
      );
    });
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
