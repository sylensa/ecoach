import 'dart:convert';

import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/database/analysis_db.dart';
import 'package:ecoach/database/database.dart';
import 'package:sqflite/sqflite.dart';

class CourseDB {
  Future<void> insert(Batch batch, Course course) async {
    batch.insert(
      'courses',
      course.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    List<Question> questions = course.questions!;
    if (questions.length > 0) {
      for (int i = 0; i < questions.length; i++) {
        Question question = questions[i];
        batch.insert(
          'questions',
          question.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        Topic? topic = question.topic;
        if (topic != null) {
          batch.insert(
            'topics',
            topic.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        List<Answer> answers = question.answers!;
        if (answers.length > 0) {
          for (int i = 0; i < answers.length; i++) {
            batch.insert(
              'answers',
              answers[i].toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        }
        // await Future.delayed(Duration(milliseconds: 90));
      }
    }
  }

  Future<Course?> getCourseById(int id) async {
    final db = await DBProvider.database;
    var result = await db!.query("courses", where: "id = ?", whereArgs: [id]);
    Course? course;
    if (result.isNotEmpty) {
      course = Course.fromJson(result.first);
      course.analytic = await AnalysisDB().getAnalysisById(course.id!);
    }
    return course;
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
      List<Level> levels = element.levels!;
      if (levels.length > 0) {
        levels.forEach((level) {
          print({'course_id': element.id, 'level_id': level.id});
          db.delete(
            'courses_levels',
            where: "course_id = ? AND level_id = ?",
            whereArgs: [element.id, level.id],
          );
          batch.insert(
            "courses_levels",
            {'course_id': element.id, 'level_id': level.id},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        });
      }
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
        time: maps[i]["time"],
      );
    });
  }

  Future<List<Course>> levelCourses(int levelId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!
        .query('courses_levels', where: "level_id = ?", whereArgs: [levelId]);

    List<Course> courses = [];
    for (int i = 0; i < maps.length; i++) {
      Course? course = await getCourseById(maps[i]["course_id"]);
      if (course != null) {
        print(course.toJson());
        courses.add(course);
      }
    }

    return courses;
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
