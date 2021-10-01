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
      return TestTaken.fromJson(maps[i]);
    });
  }

  Future<List<TestTaken>> courseTestsTaken(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('tests_taken',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId]);

    return List.generate(maps.length, (i) {
      return TestTaken.fromJson(maps[i]);
    });
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
