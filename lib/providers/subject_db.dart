import 'dart:convert';

import 'package:ecoach/models/subjects.dart';
import 'package:ecoach/providers/database.dart';
import 'package:sqflite/sqflite.dart';

class SubjectDB {
  Future<void> insert(Subject subject) async {
    if (subject == null) {
      return;
    }
    final Database? db = await DBProvider.database;

    await db!.insert(
      'subjects',
      subject.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Subject?> getMessageById(int id) async {
    final db = await DBProvider.database;
    var result = await db!.query("subjects", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Subject.fromJson(result.first) : null;
  }

  Future<void> insertAll(List<Subject> subjects) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    subjects.forEach((element) {
      batch.insert(
        'subjects',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<Subject>> subjects() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('subjects', orderBy: "created_at DESC");

    return List.generate(maps.length, (i) {
      return Subject(
        id: maps[i]["id"],
        name: maps[i]["name"],
      );
    });
  }

  Future<void> update(Subject subject) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'subjects',
      subject.toJson(),
      where: "id = ?",
      whereArgs: [subject.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'subjects',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
