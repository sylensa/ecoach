import 'package:ecoach/api/api_response.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/test_type.dart';
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

  Future<List<Question>> getQuizQuestions(int quizId, {int? limit = 40}) {
    return QuizDB().getQuestions(quizId, limit!);
  }

  Future<List<Question>> getMockQuestions(int courseId, {int? limit = 40}) {
    return QuestionDB().getRandomQuestions(courseId, limit!);
  }

  Future<List<Question>> getTopicQuestions(List<int> topicIds,
      {int? limit = 40}) {
    return QuestionDB().getTopicQuestions(topicIds, limit!);
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

  getMockTests(Course course, {limit = 40}) async {
    List<Question> questions =
        await QuestionDB().getRandomQuestions(course.id!, limit);

    return questions;
  }

  getExamTests(Course course) async {
    List<Quiz> quizzes = await QuizDB().getQuizzesByType(course.id!, "EXAM");

    List<TestNameAndCount> testNames = [];
    for (int i = 0; i < quizzes.length; i++) {
      Quiz quiz = quizzes[i];
      int totalCount = await QuizDB().getQuestionsCount(quiz.id!);
      testNames.add(TestNameAndCount(quiz.name!, 0, totalCount,
          id: quiz.id, category: TestCategory.EXAM));
    }

    return testNames;
  }

  getTopics(Course course) async {
    Map<int, String> topics = await QuestionDB().questionTopics(course.id!);

    List<TestNameAndCount> testNames = [];
    for (int i = 0; i < topics.length; i++) {
      int id = topics.keys.toList()[i];
      String name = topics.values.toList()[i];

      int count =
          await getTopicAnsweredCount(course.id!, id, onlyAttempted: true);
      int totalCount = await QuestionDB().getTopicCount(id);

      print("$name c=$count totat count=$totalCount");
      testNames.add(TestNameAndCount(name, count, totalCount,
          id: id, category: TestCategory.TOPIC));
    }
    topics.forEach((id, name) async {});

    return testNames;
  }

  getTopicsAndNotes(Course course) async {
    List<Topic> topics = await TopicDB().courseTopics(course);
    print("topics and notes");
    print(topics);
    return topics;
  }

  getEssays(Course course) async {
    List<Quiz> quizzes = await QuizDB().getQuizzesByType(course.id!, "ESSAY");

    List<TestNameAndCount> testNames = [];
    for (int i = 0; i < quizzes.length; i++) {
      Quiz quiz = quizzes[i];
      int totalCount = await QuizDB().getQuestionsCount(quiz.id!);
      testNames.add(TestNameAndCount(quiz.name!, 0, totalCount,
          id: quiz.id, category: TestCategory.ESSAY));
    }

    return testNames;
  }

  Future<List<Question>> getSavedTests(Course course) async {
    // List<Quiz> quizzes = await QuizDB().getQuizzesByType(course.id!, "SAVED");

    // List<TestNameAndCount> testNames = [];
    // quizzes.forEach((quiz) {
    //   testNames.add(TestNameAndCount(quiz.name!, 3, 12,
    //       id: quiz.id, category: TestCategory.SAVED));
    // });

    return [];
  }

  getBankTest(Course course) async {
    List<Quiz> quizzes = await QuizDB().getQuizzesByName(course.id!, "BANK");

    List<TestNameAndCount> testNames = [];
    for (int i = 0; i < quizzes.length; i++) {
      Quiz quiz = quizzes[i];
      int totalCount = await QuizDB().getQuestionsCount(quiz.id!);
      testNames.add(TestNameAndCount(quiz.name!, 0, totalCount,
          id: quiz.id, category: TestCategory.BANK));
    }

    return testNames;
  }

  Future<int> getTopicAnsweredCount(int courseId, int topicId,
      {bool onlyAttempted = false, bool onlyCorrect = false}) async {
    List<TestTaken> tests = await TestTakenDB().courseTestsTaken(courseId);
    Map<String, dynamic> responses = Map();
    tests.forEach((test) {
      responses.addAll(jsonDecode(test.responses));
    });

    List<Map<String, dynamic>> testAnswers = [];
    // print(responses.toString());
    responses.forEach((key, value) {
      testAnswers.add(value);
    });

    List<int> topicIds = [];
    testAnswers.forEach((answer) {
      int tId = answer['topic_id'];
      if (tId == topicId) {
        if ((onlyCorrect && answer['status'] == 'correct') ||
            (onlyAttempted && answer['status'] != 'unattempted') ||
            (!onlyCorrect && !onlyAttempted)) {
          topicIds.add(tId);
        }
      }
    });

    return topicIds.length;
  }

  Future<int> getQuestionsAnsweredCount(int courseId,
      {bool onlyAttempted = false, bool onlyCorrect = false}) async {
    List<TestTaken> tests = await TestTakenDB().courseTestsTaken(courseId);
    print("number of test= ${tests.length}");
    Map<String, dynamic> responses = Map();
    tests.forEach((test) {
      responses.addAll(jsonDecode(test.responses));
    });

    List<Map<String, dynamic>> testAnswers = [];
    // print(responses.toString());
    responses.forEach((key, value) {
      testAnswers.add(value);
    });

    List<int> questionIds = [];
    testAnswers.forEach((answer) {
      int quesId = answer['question_id'];
      if (!questionIds.contains(quesId)) {
        if ((onlyCorrect && answer['status'] == 'correct') ||
            (onlyAttempted && answer['status'] != 'unattempted') ||
            (!onlyCorrect && !onlyAttempted)) {
          questionIds.add(quesId);
        }
      }
    });

    return questionIds.length;
  }

  Future<double> getCourseProgress(courseId) async {
    int totalTaken =
        await getQuestionsAnsweredCount(courseId, onlyAttempted: true);
    int totalQuestions = await QuestionDB().getTotalQuestionCount(courseId);
    if (totalQuestions == 0) totalQuestions = 1;
    return totalTaken / totalQuestions;
  }

  Future<List<TestTaken>> getTestTaken(String tag) {
    return TestTakenDB().courseTestsTaken(int.parse(tag));
  }

  Future<List<Question>> getCustomizedQuestions(
      Course course, int numberOfQuestions) async {
    List<Question> questions =
        await QuestionDB().getRandomQuestions(course.id!, numberOfQuestions);

    return questions;
  }
}
