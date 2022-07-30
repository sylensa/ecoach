import 'dart:convert';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/review_taken.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/database.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class TestTakenDB {
  Future<int> insert(TestTaken testTaken) async {
    final Database? db = await DBProvider.database;

    int id = await db!.insert(
      'tests_taken',
      testTaken.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<TestTaken?> getTestTakenById(int id) async {
    final db = await DBProvider.database;
    var result =
        await db!.query("tests_taken", where: "id = ?", whereArgs: [id]);

    return result.isNotEmpty ? TestTaken.fromJson(result.last) : null;
  }

  Future<double> getAverageScore(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
      'tests_taken',
      orderBy: "created_at DESC",
      where: "course_id = ?",
      whereArgs: [courseId],
    );

    double totalScores = 0;

    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      totalScores += test.score!;
    }

    if (maps.length == 0) return 0;
    return totalScores / maps.length;
  }

  Future<double> getExamAverageScore(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
      'tests_taken',
      orderBy: "created_at DESC",
      where:
          "course_id = ? AND challenge_type = ${TestCategory.EXAM.toString()}",
      whereArgs: [courseId],
    );

    double totalScores = 0;

    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      totalScores += test.score!;
    }

    if (maps.length == 0) return 0;
    return totalScores / maps.length;
  }

  Future<void> insertAll(List<TestTaken> testsTaken) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    testsTaken.forEach((element) {
      batch.insert(
        'tests_taken',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<TestTaken>> testsTaken({String? search, int? limit}) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!
        .query('tests_taken', orderBy: "created_at DESC", limit: limit);

    List<TestTaken> tests = [];
    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      Course? course = await CourseDB().getCourseById(test.courseId!);

      if (course != null) {
        test.courseName = course.name!;
        tests.add(test);
      }
    }

    if (search != null) {
      tests = tests
          .where((test) =>
              test.testname!.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    return tests;
  }

  Future<List<TestTaken>> courseTestsTaken(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('tests_taken',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId]);

    List<TestTaken> tests = [];
    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      // print(test.toJson().toString().substring(0, 100));
      tests.add(test);
    }
    return tests;
  }
  Future<List<TestTaken>> courseTestsTakenPeriod(String courseId,String period) async {
    final Database? db = await DBProvider.database;
     List<Map<String, dynamic>> maps = [];
    if(period.toLowerCase() == 'all'){
    maps = await db!.rawQuery("Select *, score as avg_score from tests_taken where course_id = '"+ courseId +"'");
    }else if(period.toLowerCase() == 'daily'){
      maps = await db!.rawQuery("Select *, AVG(score) as avg_score from tests_taken where course_id = '"+ courseId +"'  group by Date(created_at)");
    }else if(period.toLowerCase() == 'weekly'){
    maps = await db!.rawQuery("SELECT *, strftime('%Y-%W', created_at ), AVG(score) as avg_score FROM tests_taken where course_id = '"+ courseId +"' GROUP BY strftime('%Y-%W', created_at ) ORDER BY AVG(score) desc");
    }else if(period.toLowerCase() == 'monthly'){
      maps = await db!.rawQuery("SELECT *, strftime('%Y-%M', created_at ), AVG(score) as avg_score FROM tests_taken where course_id = '"+ courseId +"' GROUP BY strftime('%Y-%M', Date(created_at) ) ORDER BY AVG(score) desc");
    }
    print("object maps:$maps");
    List<TestTaken> tests = [];
    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      // print(test.toJson().toString().substring(0, 100));
      test.score = maps[i]["avg_score"];
      tests.add(test);
      print("object maps:${test.score}");
    }
    return tests;
  }
  Future<List<TestTaken>> courseTestsTakenPeriodPoint(String courseId,String period) async {
    final Database? db = await DBProvider.database;
     List<Map<String, dynamic>> maps = [];
    if(period.toLowerCase() == 'all'){
    maps = await db!.rawQuery("Select *, correct as avg_correct from tests_taken where course_id = '"+ courseId +"'");
    }else if(period.toLowerCase() == 'daily'){
      maps = await db!.rawQuery("Select *, AVG(correct) as avg_correct from tests_taken where course_id = '"+ courseId +"'  group by Date(created_at)");
    }else if(period.toLowerCase() == 'weekly'){
    maps = await db!.rawQuery("SELECT *, strftime('%Y-%W', created_at ), AVG(correct) as avg_correct FROM tests_taken where course_id = '"+ courseId +"' GROUP BY strftime('%Y-%W', created_at ) ORDER BY AVG(correct) desc");
    }else if(period.toLowerCase() == 'monthly'){
      maps = await db!.rawQuery("SELECT *, strftime('%Y-%M', created_at ), AVG(correct) as avg_correct FROM tests_taken where course_id = '"+ courseId +"' GROUP BY strftime('%Y-%M', Date(created_at) ) ORDER BY AVG(correct) desc");
    }
    print("object maps:$maps");
    List<TestTaken> tests = [];
    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      // print(test.toJson().toString().substring(0, 100));
      test.score = maps[i]["avg_correct"];
      tests.add(test);
      print("object maps avg_correct:${test.score}");
    }
    return tests;
  }
  Future<List<TestTaken>> courseTestsTakenSpeedPoint(String courseId,String period) async {
    final Database? db = await DBProvider.database;
     List<Map<String, dynamic>> maps = [];
    if(period.toLowerCase() == 'all'){
    maps = await db!.rawQuery("Select *, used_time as avg_used_time,total_questions as avg_total_questions  from tests_taken where course_id = '"+ courseId +"'");
    }else if(period.toLowerCase() == 'daily'){
      maps = await db!.rawQuery("Select *, AVG(used_time) as avg_used_time,AVG(total_questions) as avg_total_questions  from tests_taken where course_id = '"+ courseId +"'  group by Date(created_at)");
    }else if(period.toLowerCase() == 'weekly'){
    maps = await db!.rawQuery("SELECT *, strftime('%Y-%W', created_at ), AVG(used_time) as avg_used_time,AVG(total_questions) as avg_total_questions FROM tests_taken where course_id = '"+ courseId +"' GROUP BY strftime('%Y-%W', created_at ) ORDER BY AVG(used_time) desc");
    }else if(period.toLowerCase() == 'monthly'){
      maps = await db!.rawQuery("SELECT *, strftime('%Y-%M', created_at ), AVG(used_time) as avg_used_time,AVG(total_questions) as avg_total_questions FROM tests_taken where course_id = '"+ courseId +"' GROUP BY strftime('%Y-%M', Date(created_at) ) ORDER BY AVG(used_time) desc");
    }
    print("object maps:$maps");
    List<TestTaken> tests = [];
    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      // print(test.toJson().toString().substring(0, 100));
      test.score = maps[i]["avg_used_time"]/maps[i]["avg_total_questions"] ;
      tests.add(test);
      print("object maps avg_used_time:${test.score}");
    }
    return tests;
  }
  Future<List<TestTaken>> courseTestsTakenStrengthPoint(String courseId,String period) async {
    final Database? db = await DBProvider.database;
     List<Map<String, dynamic>> maps = [];
    if(period.toLowerCase() == 'all'){
    maps = await db!.rawQuery("Select *, correct as avg_correct,total_questions as avg_total_questions  from tests_taken where course_id = '"+ courseId +"'");
    }else if(period.toLowerCase() == 'daily'){
      maps = await db!.rawQuery("Select *, AVG(correct) as avg_correct,AVG(total_questions) as avg_total_questions  from tests_taken where course_id = '"+ courseId +"'  group by Date(created_at)");
    }else if(period.toLowerCase() == 'weekly'){
    maps = await db!.rawQuery("SELECT *, strftime('%Y-%W', created_at ), AVG(correct) as avg_correct,AVG(total_questions) as avg_total_questions FROM tests_taken where course_id = '"+ courseId +"' GROUP BY strftime('%Y-%W', created_at ) ORDER BY AVG(correct) desc");
    }else if(period.toLowerCase() == 'monthly'){
      maps = await db!.rawQuery("SELECT *, strftime('%Y-%M', created_at ), AVG(correct) as avg_correct,AVG(total_questions) as avg_total_questions FROM tests_taken where course_id = '"+ courseId +"' GROUP BY strftime('%Y-%M', Date(created_at) ) ORDER BY AVG(correct) desc");
    }
    print("object maps:$maps");
    List<TestTaken> tests = [];
    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      // print(test.toJson().toString().substring(0, 100));
      test.score = maps[i]["avg_correct"]/maps[i]["avg_total_questions"] ;
      tests.add(test);
      print("object maps avg_used_time:${test.score}");
    }
    return tests;
  }

  Future<TestTaken?> courseLastTest(int courseId) async {
    final Database? db = await DBProvider.database;

    var result = await db!.query('tests_taken',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId]);

    return result.isNotEmpty ? TestTaken.fromJson(result.last) : null;
  }

  Future<void> update(TestTaken testTaken) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'tests_taken',
      testTaken.toJson(),
      where: "id = ?",
      whereArgs: [testTaken.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'tests_taken',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> insertReviewTest(ReviewTestTaken reviewTestTaken) async {
    final Database? db = await DBProvider.database;

    int id = await db!.insert(
      'review_test_taken',
      reviewTestTaken.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }
  Future<void> updateReviewTest(ReviewTestTaken reviewTestTaken) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'review_test_taken',
      reviewTestTaken.toJson(),
      where: "id = ?",
      whereArgs: [reviewTestTaken.id],
    );
  }

  Future<ReviewTestTaken?> getReviewTestTakenByTopicIdCourseId({String topicId = "0",int? courseId,String category = ''}) async {
    final db = await DBProvider.database;
    var result =
    await db!.rawQuery("Select * from review_test_taken where topic_id = '"+ topicId +"' and category = '"+ category +"' and course_id = $courseId");
    return result.isNotEmpty ? ReviewTestTaken.fromJson(result.last) : null;
  }

  Future<ReviewTestTaken?> getReviewTestTaken() async {
    final db = await DBProvider.database;
    var result =
    await db!.rawQuery("Select * from review_test_taken");
    return result.isNotEmpty ? ReviewTestTaken.fromJson(result.last) : null;
  }

}
