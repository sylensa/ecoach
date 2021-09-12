import 'dart:convert';

import 'package:ecoach/models/level.dart';
import 'package:ecoach/providers/database.dart';
import 'package:sqflite/sqflite.dart';

class LevelDB {
  Future<void> insert(Level level) async {
    if (level == null) {
      return;
    }
    final Database? db = await DBProvider.database;

    await db!.insert(
      'course_levels',
      level.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Level?> getMessageById(int id) async {
    final db = await DBProvider.database;
    var result =
        await db!.query("course_levels", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Level.fromJson(result.first) : null;
  }

  Future<void> insertAll(List<Level> course_levels) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    course_levels.forEach((element) {
      batch.insert(
        'course_levels',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<Level>> levels() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('course_levels', orderBy: "created_at DESC");

    return List.generate(maps.length, (i) {
      return Level(
        id: maps[i]["id"],
        name: maps[i]["name"],
        code: maps[i]["code"],
        createdAt: DateTime.parse(maps[i]["created_at"]),
        updatedAt: DateTime.parse(maps[i]["updated_at"]),
        group: maps[i]["group"],
      );
    });
  }

  Future<void> update(Level level) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'course_levels',
      level.toJson(),
      where: "id = ?",
      whereArgs: [level.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'course_levels',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
