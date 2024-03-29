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

  Future<int> insertKeywordTestTaken(TestTaken testTaken) async {
    final Database? db = await DBProvider.database;

    int id = await db!.insert(
      'keyword_test_taken',
      testTaken.toJson(),
    );
    return id;
  }

  Future<TestTaken?> getTestTakenById(int id) async {
    final db = await DBProvider.database;
    var result =
        await db!.query("tests_taken", where: "id = ?", whereArgs: [id]);

    return result.isNotEmpty ? TestTaken.fromJson(result.last) : null;
  }

  Future<List<TestTaken>> keywordTestsTakenByChallengeType(
      TestCategory challengeType,
      {int? courseId}) async {
    final Database? db = await DBProvider.database;
    List<Map<String, dynamic>> results = [];

    results = courseId != null
        ? await db!.query(
            'keyword_test_taken',
            where: "course_id = ? AND challenge_type = ?",
            whereArgs: [
              courseId,
              challengeType.toString(),
            ],
          )
        : await db!.query('keyword_test_taken',
            where: "challenge_type = ?", whereArgs: [challengeType.toString()]);

    List<TestTaken> tests = [];
    for (int i = 0; i < results.length; i++) {
      TestTaken test = TestTaken.fromJson(results[i]);
      tests.add(test);
    }
    return tests;
  }

  Future<List<TestTaken>> keywordTestsTakenByTopic(int topicId) async {
    final Database? db = await DBProvider.database;
    List<Map<String, dynamic>> results = [];

    results = await db!.query('keyword_test_taken',
        where: "topic_id = ?", whereArgs: [topicId]);

    List<TestTaken> tests = [];
    for (int i = 0; i < results.length; i++) {
      TestTaken test = TestTaken.fromJson(results[i]);
      // print(test.toJson().toString().substring(0, 100));
      tests.add(test);
    }
    return tests;
  }

  Future<List<TestTaken>> getKeywordTestsTakenByTestName(
      String testName) async {
    final Database? db = await DBProvider.database;
    List<Map<String, dynamic>> results = [];

    results = await db!.query('keyword_test_taken',
        where: "test_name = ?", whereArgs: [testName]);

    List<TestTaken> tests = [];
    for (int i = 0; i < results.length; i++) {
      TestTaken test = TestTaken.fromJson(results[i]);
      tests.add(test);
    }
    return tests;
  }

  Future<List<TestTaken>> getKeywordTestTaken(int courseId) async {
    List<Map<String, dynamic>> result = [];
    List<Map<String, dynamic>> response = [];
    List<Map<String, dynamic>> responseTotalQuestion = [];
    final db = await DBProvider.database;
    // var result = await db!.rawQuery("select keyword_test_taken");
    result = await db!.rawQuery(
        "Select *, SUM(score) as avg_score, count(*) total_test_taken,SUM(correct) correct,SUM(wrong) wrong,unattempted from keyword_test_taken where course_id = $courseId group by test_name");
    // print("result test_name:${result.last["test_name"]}");
    // print("result:${result.length}");
    List<TestTaken> tests = [];

    for (int i = 0; i < result.length; i++) {
      if (result[i]["id"] == null) {
        continue;
      }
      TestTaken test = TestTaken.fromJson(result[i]);
      response = await db
          .rawQuery("Select correct from keyword_test_taken where test_name = '"
              '${test.testname}'
              "' and course_id = $courseId ORDER by id desc limit 2");
      responseTotalQuestion = await db
          .rawQuery("Select * from keyword_test_taken where test_name = '"
              '${test.testname}'
              "' and course_id = $courseId ORDER by id asc limit 1");
      int scoreDiff;
      if (response.length > 1) {
        scoreDiff = response[1]["correct"] - response[0]["correct"];
      } else {
        scoreDiff = response[0]["correct"];
      }
      test.totalQuestions = responseTotalQuestion[0]["total_questions"];
      test.score = result[i]["avg_score"] / result[i]["total_test_taken"];
      test.total_test_taken = result[i]["total_test_taken"];
      test.scoreDiff = scoreDiff;
      tests.add(test);
    }
    return tests;
  }

  Future<List<TestTaken>> getKeywordTestTakenPeriod(
      String courseId, String period, String keyword) async {
    final Database? db = await DBProvider.database;
    List<Map<String, dynamic>> maps = [];
    if (period.toLowerCase() == 'all') {
      maps = await db!.rawQuery(
          "Select *, score as avg_score from keyword_test_taken where course_id = '" +
              courseId +
              "' and test_name = '" +
              keyword +
              "'");
    } else if (period.toLowerCase() == 'daily') {
      maps = await db!.rawQuery(
          "Select *, AVG(score) as avg_score from tests_taken where course_id = '" +
              courseId +
              "' and test_name = '" +
              keyword +
              "' and challenge_type IS NOT NULL  GROUP by Date(created_at)");
    } else if (period.toLowerCase() == 'weekly') {
      maps = await db!.rawQuery(
          "SELECT *, strftime('%Y-%W', created_at ), AVG(score) as avg_score FROM tests_taken where course_id = '" +
              courseId +
              "' and test_name = '" +
              keyword +
              "' and challenge_type IS NOT NULL GROUP BY strftime('%Y-%W', created_at ) ORDER BY AVG(score) desc");
    } else if (period.toLowerCase() == 'monthly') {
      maps = await db!.rawQuery(
          "SELECT *, strftime('%Y-%M', created_at ), AVG(score) as avg_score FROM tests_taken where course_id = '" +
              courseId +
              "' and test_name = '" +
              keyword +
              "' and challenge_type IS NOT NULL GROUP BY strftime('%Y-%M', Date(created_at) ) ORDER BY AVG(score) desc");
    }
    print("object maps:${maps.length}");
    List<TestTaken> tests = [];
    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      test.score = maps[i]["avg_score"];
      tests.add(test);
      print("object maps:${test.score}");
    }
    return tests;
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

  Future<List<TestTaken>> courseTestsTaken({int? courseId}) async {
    final Database? db = await DBProvider.database;
    final List<Map<String, dynamic>> maps;

    if (courseId != null) {
      maps = await db!.query('tests_taken',
          orderBy: "created_at DESC",
          where: "course_id = ?",
          whereArgs: [courseId]);
    } else {
      maps = await db!.query(
        'tests_taken',
        orderBy: "created_at DESC",
        groupBy: "course_id",
        distinct: true,
      );
    }

    List<TestTaken> tests = [];
    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      // print(test.toJson().toString().substring(0, 100));
      tests.add(test);
    }
    return tests;
  }

  Future<List<TestTaken>> ongoingCourseTestsTaken({int? courseId}) async {
    final Database? db = await DBProvider.database;
    final List<Map<String, dynamic>> maps;

    if (courseId != null) {
      maps = await db!.query('tests_taken',
          orderBy: "created_at DESC",
          where: "course_id = ?",
          whereArgs: [courseId]);
    } else {
      maps = await db!.query(
        'tests_taken',
        orderBy: "created_at DESC",
        groupBy: "course_id",
        distinct: true,
      );
    }

    List<TestTaken> tests = [];
    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      // print(test.toJson().toString().substring(0, 100));
      tests.add(test);
    }
    return tests;
  }

  Future<List<TestTaken>> getAllAverageScore(
      {String courseId = "0", int offset = 0}) async {
    final Database? db = await DBProvider.database;
    List<Map<String, dynamic>> maps = [];
    print("courseId:$courseId");
    if (courseId == "0") {
      maps = await db!.rawQuery(
          "Select *, score as avg_score from tests_taken limit 10 offset $offset");
    } else {
      maps = await db!.rawQuery(
          "Select *, score as avg_score from tests_taken where course_id = '" +
              courseId +
              "' limit 10 offset $offset");
    }
    // print("object maps len:${maps}");
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

  Future<List<TestTaken>> courseTestsTakenPeriod(String courseId, String period,
      {int? groupId = null}) async {
    final Database? db = await DBProvider.database;
    List<Map<String, dynamic>> maps = [];
    if (period.toLowerCase() == 'all') {
      if (groupId != null) {
        maps = await db!.rawQuery(
            "Select *, score as avg_score from tests_taken where course_id = '" +
                courseId +
                "' and group_id = $groupId and challenge_type IS NOT NULL");
      } else {
        maps = await db!.rawQuery(
            "Select *, score as avg_score from tests_taken where course_id = '" +
                courseId +
                "' and challenge_type IS NOT NULL");
      }
    } else if (period.toLowerCase() == 'daily') {
      maps = await db!.rawQuery(
          "Select *, AVG(score) as avg_score from tests_taken where course_id = '" +
              courseId +
              "' and challenge_type IS NOT NULL  GROUP by Date(created_at)");
    } else if (period.toLowerCase() == 'weekly') {
      maps = await db!.rawQuery(
          "SELECT *, strftime('%Y-%W', created_at ), AVG(score) as avg_score FROM tests_taken where course_id = '" +
              courseId +
              "' and challenge_type IS NOT NULL GROUP BY strftime('%Y-%W', created_at ) ORDER BY AVG(score) desc");
    } else if (period.toLowerCase() == 'monthly') {
      maps = await db!.rawQuery(
          "SELECT *, strftime('%Y-%M', created_at ), AVG(score) as avg_score FROM tests_taken where course_id = '" +
              courseId +
              "' and challenge_type IS NOT NULL GROUP BY strftime('%Y-%M', Date(created_at) ) ORDER BY AVG(score) desc");
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

  Future<List<TestTaken>> courseTestsTakenPeriodPoint(
      String courseId, String period) async {
    final Database? db = await DBProvider.database;
    List<Map<String, dynamic>> maps = [];
    if (period.toLowerCase() == 'all') {
      maps = await db!.rawQuery(
          "Select *, correct as avg_correct from tests_taken where course_id = '" +
              courseId +
              "'");
    } else if (period.toLowerCase() == 'daily') {
      maps = await db!.rawQuery(
          "Select *, AVG(correct) as avg_correct from tests_taken where course_id = '" +
              courseId +
              "'  GROUP by Date(created_at)");
    } else if (period.toLowerCase() == 'weekly') {
      maps = await db!.rawQuery(
          "SELECT *, strftime('%Y-%W', created_at ), AVG(correct) as avg_correct FROM tests_taken where course_id = '" +
              courseId +
              "' GROUP BY strftime('%Y-%W', created_at ) ORDER BY AVG(correct) desc");
    } else if (period.toLowerCase() == 'monthly') {
      maps = await db!.rawQuery(
          "SELECT *, strftime('%Y-%M', created_at ), AVG(correct) as avg_correct FROM tests_taken where course_id = '" +
              courseId +
              "' GROUP BY strftime('%Y-%M', Date(created_at) ) ORDER BY AVG(correct) desc");
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

  Future<List<TestTaken>> courseTestsTakenSpeedPoint(
      String courseId, String period) async {
    final Database? db = await DBProvider.database;
    List<Map<String, dynamic>> maps = [];
    if (period.toLowerCase() == 'all') {
      maps = await db!.rawQuery(
          "Select *, used_time as avg_used_time,total_questions as avg_total_questions  from tests_taken where course_id = '" +
              courseId +
              "'");
    } else if (period.toLowerCase() == 'daily') {
      maps = await db!.rawQuery(
          "Select *, AVG(used_time) as avg_used_time,AVG(total_questions) as avg_total_questions  from tests_taken where course_id = '" +
              courseId +
              "'  GROUP by Date(created_at)");
    } else if (period.toLowerCase() == 'weekly') {
      maps = await db!.rawQuery(
          "SELECT *, strftime('%Y-%W', created_at ), AVG(used_time) as avg_used_time,AVG(total_questions) as avg_total_questions FROM tests_taken where course_id = '" +
              courseId +
              "' GROUP BY strftime('%Y-%W', created_at ) ORDER BY AVG(used_time) desc");
    } else if (period.toLowerCase() == 'monthly') {
      maps = await db!.rawQuery(
          "SELECT *, strftime('%Y-%M', created_at ), AVG(used_time) as avg_used_time,AVG(total_questions) as avg_total_questions FROM tests_taken where course_id = '" +
              courseId +
              "' GROUP BY strftime('%Y-%M', Date(created_at) ) ORDER BY AVG(used_time) desc");
    }
    print("object maps:$maps");
    List<TestTaken> tests = [];
    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      // print(test.toJson().toString().substring(0, 100));
      test.score = maps[i]["avg_used_time"] / maps[i]["avg_total_questions"];
      tests.add(test);
      print("object maps avg_used_time:${test.score}");
    }
    return tests;
  }

  Future<List<TestTaken>> courseTestsTakenStrengthPoint(
      String courseId, String period) async {
    final Database? db = await DBProvider.database;
    List<Map<String, dynamic>> maps = [];
    if (period.toLowerCase() == 'all') {
      maps = await db!.rawQuery(
          "Select *, correct as avg_correct,total_questions as avg_total_questions  from tests_taken where course_id = '" +
              courseId +
              "'");
    } else if (period.toLowerCase() == 'daily') {
      maps = await db!.rawQuery(
          "Select *, AVG(correct) as avg_correct,AVG(total_questions) as avg_total_questions  from tests_taken where course_id = '" +
              courseId +
              "'  GROUP by Date(created_at)");
    } else if (period.toLowerCase() == 'weekly') {
      maps = await db!.rawQuery(
          "SELECT *, strftime('%Y-%W', created_at ), AVG(correct) as avg_correct,AVG(total_questions) as avg_total_questions FROM tests_taken where course_id = '" +
              courseId +
              "' GROUP BY strftime('%Y-%W', created_at ) ORDER BY AVG(correct) desc");
    } else if (period.toLowerCase() == 'monthly') {
      maps = await db!.rawQuery(
          "SELECT *, strftime('%Y-%M', created_at ), AVG(correct) as avg_correct,AVG(total_questions) as avg_total_questions FROM tests_taken where course_id = '" +
              courseId +
              "' GROUP BY strftime('%Y-%M', Date(created_at) ) ORDER BY AVG(correct) desc");
    }
    print("object maps:$maps");
    List<TestTaken> tests = [];
    for (int i = 0; i < maps.length; i++) {
      TestTaken test = TestTaken.fromJson(maps[i]);
      // print(test.toJson().toString().substring(0, 100));
      test.score = maps[i]["avg_correct"] / maps[i]["avg_total_questions"];
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

  deleteAll() async {
    final db = await DBProvider.database;
    db!.delete(
      'tests_taken',
    );
  }

  deleteAllKeywordTestTaken() async {
    final db = await DBProvider.database;
    db!.delete(
      'keyword_test_taken',
    );
  }

  deleteAllKeywordTestTakenByName(String testname) async {
    final db = await DBProvider.database;
    db!.rawQuery(
        'delete from keyword_test_taken where test_name = ' " '$testname'" '');
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

  Future<ReviewTestTaken?> getReviewTestTakenByTopicIdCourseId(
      {String topicId = "0", int? courseId, String category = ''}) async {
    final db = await DBProvider.database;
    var result = await db!.rawQuery(
        "Select * from review_test_taken where topic_id = '" +
            topicId +
            "' and category = '" +
            category +
            "' and course_id = $courseId");
    return result.isNotEmpty ? ReviewTestTaken.fromJson(result.last) : null;
  }

  Future<ReviewTestTaken?> getReviewTestTaken() async {
    final db = await DBProvider.database;
    var result = await db!.rawQuery("Select * from review_test_taken");
    return result.isNotEmpty ? ReviewTestTaken.fromJson(result.last) : null;
  }
}
