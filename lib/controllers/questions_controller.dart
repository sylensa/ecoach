import 'package:ecoach/models/api_response.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/questions_db.dart';
import 'package:ecoach/providers/test_taken_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestController {
  loadDiagnoticQuestion(Level level, Course course) async {
    User? user = await UserPreferences().getUser();
    print(user!.token!);
    Map<String, dynamic> queryParams = {
      'level_id': jsonEncode(level.id),
      'course_id': jsonEncode(course.id),
      'limit': jsonEncode(5)
    };
    print(queryParams);
    print(AppUrl.questions + '?' + Uri(queryParameters: queryParams).query);
    http.Response response = await http.get(
      Uri.parse(
          AppUrl.questions + '?' + Uri(queryParameters: queryParams).query),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'api-token': user.token!
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      // print(responseData);
      if (responseData["status"] == true) {
        print("messages returned");
        print(response.body);

        return ApiResponse<Question>.fromJson(response.body, (dataItem) {
          print("it's fine here");
          return Question.fromJson(dataItem);
        });
      } else {
        print("not successful event");
      }
    } else {
      print("Failed ....");
      print(response.statusCode);
      print(response.body);
    }
  }

  saveQuestionsLocally(List<Question> questions) {
    QuestionDB().insertAll(questions);
  }

  saveTestTaken(TestTaken test) {
    TestTakenDB().insert(test);
  }

  Future<Map<String, List<TestAnswer>>> topicsAnalysis(TestTaken test) async {
    Map<String, List<TestAnswer>> topicsMap = Map();

    String responses = test.responses;
    print("respones:");

    responses = responses.replaceAll("(", "").replaceAll(")", "");
    // responses = jsonEncode(responses);
    print(responses);
    Map<String, dynamic> res = json.decode(responses);
    print(res.runtimeType);
    List<TestAnswer>? answers = fromMap(res, (answer) {
      print(answer);
      return TestAnswer.fromJson(answer);
    });

    answers!.forEach((answer) {
      topicsMap.update("${answer.topicName}", (list) {
        list.add(answer);
        return list;
      }, ifAbsent: () {
        return [answer];
      });
    });

    return topicsMap;
  }

  fromMap(Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    List<TestAnswer> data = [];
    json.forEach((k, v) {
      print(k);
      data.add(create(v));
    });

    print(data);
    return data;
  }

  getMockTests(Course course) {}

  getExamTests(Course course) {}

  getTopics(Course course) {}

  getEssays(Course course) {}

  getSavedTests(Course course) {}

  getBankTest(Course course) {}
}
