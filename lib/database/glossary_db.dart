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
  Future<List<GlossaryData>> getGlossariesByTopicId(int topicId) async {
    List<GlossaryData> glossaries = [];
    final db = await DBProvider.database;
    var  response = await db!.rawQuery("Select * from glossary where course_id = $topicId");
    print("response glossary course id:$topicId : $response");
    for(int i =0; i < response.length; i++){
      GlossaryData glossaryData = GlossaryData.fromJson(jsonDecode(response[i]["glossary_topic"].toString()));
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

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'glossary',
      where: "course_id = ?",
      whereArgs: [id],
    );
  }
  deleteGLossaryTopic(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'glossary_topic',
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
    db!.delete('glossary_topic');
  }
}
