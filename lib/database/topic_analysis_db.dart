import 'dart:convert';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/review_taken.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/database.dart';
import 'package:ecoach/models/topic_analysis.dart';
import 'package:ecoach/models/topic_analysis_model.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class TopicAnalysisDB {
  Future<int> insert(TopicAnalysisList testTaken) async {
    final Database? db = await DBProvider.database;

    int id = await db!.insert(
      'topic_analysis',
      testTaken.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<List<TopicAnalysisList>> getTopicsAnalysisAverageScore() async {
    final Database? db = await DBProvider.database;
    List<Map<String, dynamic>> maps = [];
      maps = await db!.rawQuery(
          "Select *, AVG(correctly_answered) as avg_score from topic_analysis group by topic_id");

      print("object maps:$maps");
      List<TopicAnalysisList> tests = [];
      for (int i = 0; i < maps.length; i++) {
        TopicAnalysisList test = TopicAnalysisList.fromJson(maps[i]);
        // print(test.toJson().toString().substring(0, 100));
        test.correctlyAnswered = maps[i]["avg_score"];
        // test.totalQuestions = maps[i]["sum_questions"];
        tests.add(test);
        print("object maps:${test.correctlyAnswered}");
      }
      return tests;

  }
  Future<List<TopicAnalysisList>> getTopicsAnalysisAverageScorExam(String topicId) async {
    final Database? db = await DBProvider.database;
    List<Map<String, dynamic>> maps = [];
      maps = await db!.rawQuery("Select * from topic_analysis where topic_id = '" + topicId + "'");
      print("object maps:$maps");
      List<TopicAnalysisList> tests = [];
      for (int i = 0; i < maps.length; i++) {
        TopicAnalysisList test = TopicAnalysisList.fromJson(maps[i]);
        tests.add(test);
        print("object maps test:${test.testScore}");
      }
      return tests;

  }



  Future<void> insertAll(List<TopicAnalysisList> testsTaken) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    testsTaken.forEach((element) {
      batch.insert(
        'topic_analysis',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  delete() async {
    final db = await DBProvider.database;
    db!.rawQuery("DELETE FROM topic_analysis");
  }

}
