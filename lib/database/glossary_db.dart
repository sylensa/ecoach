import 'dart:convert';

import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/glossary_model.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/database/analysis_db.dart';
import 'package:ecoach/database/database.dart';
import 'package:sqflite/sqflite.dart';

class GlossaryDB {

  Future<void> insert(Batch batch,GlossaryData glossaryData) async {
    batch.insert(
      'glossary', glossaryData.glossaryDataDataMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<GlossaryData>> getGlossariesById(int courseId) async {
    List<GlossaryData> glossaries = [];
    final db = await DBProvider.database;
    var  response = await db!.rawQuery("Select * from glossary where course_id = $courseId");
    print("response glossary course id:$courseId : $response");
    for(int i =0; i < response.length; i++){
      GlossaryData glossaryData = GlossaryData.fromJson(jsonDecode(response[i]["glossary"].toString()));
      glossaries.add(glossaryData);
    }
    return glossaries;
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


  Future<List<Course>> coursesByCourseID(List<String> courseId) async {
    final Database? db = await DBProvider.database;
    List<Course> courses = [];
    for(int i = 0 ; i < courseId.length; i++){
      print("courseId:${courseId[i]}");
      final List<Map<String, dynamic>> maps = await db!.rawQuery('SELECT * FROM courses WHERE  courseID like "${courseId[i]}%"');
      print("maps:$maps");
      if(maps.isNotEmpty){
        for(int i = 0; i < maps.length; i++){
          Course course = Course.fromJson(maps[i]);
          print(course.toJson());
          if (course != null) {
            print(course.toJson());
            courses.add(course);
          }
        }

      }

    }
    return courses;
  }

  Future<void> update(GlossaryData glossaryData) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'glossary',
      glossaryData.glossaryDataDataMap(),
      where: "id = ?",
      whereArgs: [glossaryData.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'glossary',
      where: "course_id = ?",
      whereArgs: [id],
    );
  }

  deleteAll(int id) async {
    final db = await DBProvider.database;
    db!.delete('glossary');
  }
}
