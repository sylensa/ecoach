import 'dart:convert';

import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/glossary_model.dart';
import 'package:ecoach/models/glossary_progress_model.dart';
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
  Future<void> insertGlossaryTryProgress(GlossaryProgressData glossaryProgressData) async {
    final db = await DBProvider.database;
    db!.insert(
      'glossary_try_progress',
      glossaryProgressData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> insertGlossaryStudyProgress(GlossaryProgressData glossaryProgressData) async {
    final db = await DBProvider.database;
    db!.insert(
      'glossary_study_progress',
      glossaryProgressData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Future<GlossaryProgressData?> getGlossaryProgressByTopicId(int courseId,List topicId) async {
  //   String ids = "";
  //   for (int i = 0; i < topicId.length; i++) {
  //     ids += "${topicId[i]}";
  //     if (i < topicId.length - 1) {
  //       ids += ",";
  //     }
  //   }
  //   GlossaryProgressData? glossaryProgressData;
  //   final db = await DBProvider.database;
  //   var  response = await db!.rawQuery("Select * from glossary_progress where course_id = $courseId and topic_id = $topicId");
  //   print("response glossary_progress topic id:$topicId : $response");
  //    glossaryProgressData = GlossaryProgressData.fromJson(response.first);
  //   return glossaryProgressData;
  // }
  Future<List<GlossaryProgressData>> getGlossaryTryProgressByCourseId(int courseId) async {
    List<GlossaryProgressData> listGlossaryProgressData = [];
    final db = await DBProvider.database;
    var  response = await db!.rawQuery("Select * from glossary_try_progress where course_id = $courseId");
    print("response glossary_progress course id:$courseId : $response");
    if(response.isNotEmpty){
      for(int i =0; i < response.length; i++){
        GlossaryProgressData glossaryProgressData = GlossaryProgressData.fromJson(response[i]);
        listGlossaryProgressData.add(glossaryProgressData);
      }
    }
    return listGlossaryProgressData;
  }
  Future<List<GlossaryProgressData>> getGlossaryTryProgressByCourseIdTopicId(int courseId,int topicId) async {
    List<GlossaryProgressData> listGlossaryProgressData = [];
    final db = await DBProvider.database;
    var  response = await db!.rawQuery("Select * from glossary_try_progress where course_id = $courseId AND topic_id = $topicId");
    print("response glossary_progress course id:$courseId : $response");
    if(response.isNotEmpty){
      for(int i =0; i < response.length; i++){
        GlossaryProgressData glossaryProgressData = GlossaryProgressData.fromJson(response[i]);
        listGlossaryProgressData.add(glossaryProgressData);
      }
    }
    return listGlossaryProgressData;
  }
  Future<GlossaryProgressData?> getGlossaryStudyProgressByCourseId(int courseId) async {
    GlossaryProgressData? glossaryProgressData;
    final db = await DBProvider.database;
    var  response = await db!.rawQuery("Select * from glossary_study_progress where course_id = $courseId");
    print("response glossary_progress course id:$courseId : $response");
    if(response.isNotEmpty){
      glossaryProgressData = GlossaryProgressData.fromJson(response.last);
      return glossaryProgressData;
    }
    return glossaryProgressData;
  }
  Future<GlossaryProgressData?> getGlossaryStudyProgressByCourseIdTopicId(int courseId, int topicId,) async {
    GlossaryProgressData? glossaryProgressData;
    final db = await DBProvider.database;
    var  response = await db!.rawQuery("Select * from glossary_study_progress where course_id = $courseId AND topic_id = $topicId");
    print("response glossary_progress course id:$courseId : $response");
    if(response.isNotEmpty){
      glossaryProgressData = GlossaryProgressData.fromJson(response.last);
      return glossaryProgressData;
    }
    return glossaryProgressData;
  }
  Future<void> insertTopicGlossary(Batch batch,GlossaryData glossaryData) async {
    batch.insert(
      'glossary_topic', glossaryData.glossaryDataDataMap(),
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
      glossaryData.glossary = response[i]["glossary"].toString();
      glossaries.add(glossaryData);
    }
    return glossaries;
  }
  Future<List<GlossaryData>> getGlossariesByTopicId(int courseId,List topicId) async {
    String ids = "";
    for (int i = 0; i < topicId.length; i++) {
      ids += "${topicId[i]}";
      if (i < topicId.length - 1) {
        ids += ",";
      }
    }
    List<GlossaryData> glossaries = [];
    final db = await DBProvider.database;
    var  response = await db!.rawQuery("Select * from glossary_topic where course_id = $courseId and topic_id in ($ids)");
    print("response glossary course id:$topicId : $response");
    for(int i =0; i < response.length; i++){
      GlossaryData glossaryData = GlossaryData.fromJson(jsonDecode(response[i]["glossary"].toString()));
      glossaryData.glossary = response[i]["glossary"].toString();
      glossaries.add(glossaryData);
    }
    return glossaries;
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
  Future<void> updateGlossaryTopic(GlossaryData glossaryData) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'glossary_topic',
      glossaryData.glossaryDataDataMap(),
      where: "id = ?",
      whereArgs: [glossaryData.id],
    );
  }

  delete(Batch batch,int id) async {
    final db = await DBProvider.database;
    batch.delete(
      'glossary',
      where: "course_id = ?",
      whereArgs: [id],
    );
  }
  deleteGlossaryTopic(Batch batch,int id) async {
    final db = await DBProvider.database;
    batch.delete(
      'glossary_topic',
      where: "course_id = ?",
      whereArgs: [id],
    );
  }

  deleteGlossaryTryProgress(int id) async {
    final db = await DBProvider.database;
  db!.delete(
      'glossary_try_progress',
      where: "course_id = ?",
      whereArgs: [id],
    );
  }
  deleteGlossaryStudyProgress(int id) async {
    final db = await DBProvider.database;
  db!.delete(
      'glossary_study_progress',
      where: "course_id = ?",
      whereArgs: [id],
    );
  }

  deleteAll() async {
    final db = await DBProvider.database;
    db!.delete('glossary');
  }
  deleteAllGlossaryTopic() async {
    final db = await DBProvider.database;
    await db!.rawQuery('Delete from glossary_topic');
  }

  deleteAllGlossaryTryProgress() async {
    final db = await DBProvider.database;
    await db!.rawQuery('Delete from glossary_try_progress');
  }
  deleteAllGlossaryStudyProgress() async {
    final db = await DBProvider.database;
    await db!.rawQuery('Delete from glossary_study_progress');
  }
}
