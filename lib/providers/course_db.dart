import 'dart:convert';

import 'package:ecoach/models/course.dart';
import 'package:ecoach/providers/database.dart';
import 'package:sqflite/sqflite.dart';

class CourseDB {
  Future<void> insert(Course course) async {
    if (course == null) {
      return;
    }
    final Database? db = await DBProvider.database;

    await db!.insert(
      'courses',
      course.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Course?> getMessageById(int id) async {
    final db = await DBProvider.database;
    var result = await db!.query("courses", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Course.fromJson(result.first) : null;
  }

  Future<void> insertAll(List<Course> courses) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    courses.forEach((element) {
      batch.insert(
        'courses',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<Course>> courses() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('courses', orderBy: "created_at DESC");

    return List.generate(maps.length, (i) {
      return Course(
        id: maps[i]["id"],
        name: maps[i]["name"],
        courseId: maps[i]["courseID"],
        author: maps[i]["author"],
        packageCode: maps[i]["package_code"],
        category: maps[i]["category"],
        confirmed: maps[i]["confirmed"],
        description: maps[i]["description"],
        levelId: maps[i]["level_id"],
        createdAt: maps[i]["created_at"],
        updatedAt: maps[i]["update_at"],
        time: maps[i]["time"],
      );
    });
  }

  Future<void> update(Course course) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'courses',
      course.toJson(),
      where: "id = ?",
      whereArgs: [course.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'courses',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
