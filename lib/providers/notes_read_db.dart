import 'dart:convert';

import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/notes_read.dart';
import 'package:ecoach/providers/database.dart';
import 'package:sqflite/sqflite.dart';

class NotesReadDB {
  Future<void> insert(NotesRead notesRead) async {
    if (notesRead == null) {
      return;
    }
    // print(notesRead.toJson());
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      await txn.insert(
        'notes_read',
        notesRead.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<NotesRead?> getNotesReadById(int id) async {
    final db = await DBProvider.database;
    var result =
        await db!.query("notes_read", where: "id = ?", whereArgs: [id]);
    NotesRead? notesRead =
        result.isNotEmpty ? NotesRead.fromJson(result.first) : null;

    return notesRead;
  }

  Future<void> insertAll(List<NotesRead> notesReads) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    notesReads.forEach((element) {
      // print(element.toJson());
      batch.insert(
        'notes_read',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<NotesRead>> notesReads() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('notes_read', orderBy: "name ASC");

    List<NotesRead> notesReads = [];
    for (int i = 0; i < maps.length; i++) {
      NotesRead notesRead = NotesRead.fromJson(maps[i]);
      notesReads.add(notesRead);
    }
    return notesReads;
  }

  Future<List<NotesRead>> courseNotesReads(Course course) async {
    final Database? db = await DBProvider.database;
    print("course id = ${course.id}");
    final List<Map<String, dynamic>> maps = await db!.query('notes_read',
        orderBy: "name ASC",
        where: "course_id = ? AND notes <> '' ",
        whereArgs: [course.id]);

    print('course len=${maps.length}');
    List<NotesRead> notesReads = [];
    for (int i = 0; i < maps.length; i++) {
      NotesRead notesRead = NotesRead.fromJson(maps[i]);
      notesReads.add(notesRead);
    }
    return notesReads;
  }

  Future<NotesRead?> lastNotesRead(int courseId) async {
    final Database? db = await DBProvider.database;

    var result = await db!.query('notes_read',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId],
        limit: 1);

    return result.isNotEmpty ? NotesRead.fromJson(result.last) : null;
  }

  Future<void> update(NotesRead notesRead) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'notes_read',
      notesRead.toJson(),
      where: "id = ?",
      whereArgs: [notesRead.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'notes_read',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
