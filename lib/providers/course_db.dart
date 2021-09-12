import 'dart:convert';

import 'package:ecoach/providers/database.dart';
import 'package:sqflite/sqflite.dart';

class CourseDB {
  // Future<void> insert(Course course) async {
  //   if (course == null) {
  //     return;
  //   }
  //   final Database? db = await DBProvider.database;

  //   await db!.insert(
  //     'courses',
  //     course.toJson(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // Future<Course?> getMessageById(int id) async {
  //   final db = await DBProvider.database;
  //   var result = await db!.query("courses", where: "id = ?", whereArgs: [id]);
  //   return result.isNotEmpty ? Course.fromJson(result.first) : null;
  // }

  // Future<void> insertAll(List<Course> courses) async {
  //   final Database? db = await DBProvider.database;
  //   Batch batch = db!.batch();
  //   courses.forEach((element) {
  //     batch.insert(
  //       'courses',
  //       element.toJson(),
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   });

  //   await batch.commit(noResult: true);
  // }

  // Future<List<Course>> courses() async {
  //   final Database? db = await DBProvider.database;

  //   final List<Map<String, dynamic>> maps =
  //       await db!.query('courses', orderBy: "created_at DESC");

  //   return List.generate(maps.length, (i) {
  //     return Course(
  //       id: maps[i]["id"],
  //       name: maps[i]["name"],
  //       code: maps[i]["code"],
  //       createdAt: DateTime.parse(maps[i]["created_at"]),
  //       updatedAt: DateTime.parse(maps[i]["updated_at"]),
  //       group: maps[i]["group"],
  //     );
  //   });
  // }

  // Future<void> update(Course course) async {
  //   // ignore: unused_local_variable
  //   final db = await DBProvider.database;

  //   await db!.update(
  //     'courses',
  //     course.toJson(),
  //     where: "id = ?",
  //     whereArgs: [course.id],
  //   );
  // }

  // delete(int id) async {
  //   final db = await DBProvider.database;
  //   db!.delete(
  //     'courses',
  //     where: "id = ?",
  //     whereArgs: [id],
  //   );
  // }
}
