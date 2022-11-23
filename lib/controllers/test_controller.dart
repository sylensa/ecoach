import 'package:ecoach/api/api_response.dart';
import 'package:ecoach/database/answers.dart';
import 'package:ecoach/database/conquest_test_taken_db.dart';
import 'package:ecoach/database/marathon_db.dart';
import 'package:ecoach/database/treadmill_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/marathon.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/test/test_type.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestController {
  loadDiagnoticQuestion(Level level, Course course) async {
    User? user = await UserPreferences().getUser();
    // print(user!.token!);
    Map<String, dynamic> queryParams = {
      'level_id': jsonEncode(level.id),
      'course_id': jsonEncode(course.id),
      'limit': jsonEncode(20)
    };
    // print(queryParams);
    // print(AppUrl.questions + '?' + Uri(queryParameters: queryParams).query);
    http.Response response = await http.get(
      Uri.parse(
          AppUrl.questions + '?' + Uri(queryParameters: queryParams).query),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'api-token': user!.token!
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      // print(responseData);
      if (responseData["status"] == true) {
        // print("messages returned");
        // print(response.body);

        return ApiResponse<Question>.fromJson(response.body, (dataItem) {
          Question question = Question.fromJson(dataItem);
          Map<String, dynamic> json = question.toJson();
          List<Map<String, dynamic>> jsonAnswer = [];
          question.answers!.forEach((answer) {
            jsonAnswer.add(answer.toJson());
          });
          json.addAll({'answers': jsonAnswer});
          return Question.fromJson(json);
        });
      } else {
        // print("not successful event");
      }
    } else {
      // print("Failed ....");
      // print(response.statusCode);
      // print(response.body);
    }
  }

  loadDiagnoticQuestionAnnex(Course course) async {
    User? user = await UserPreferences().getUser();
    // print(user!.token!);
    Map<String, dynamic> queryParams = {
      // 'level_id': jsonEncode(level.id),
      'course_id': jsonEncode(course.id),
      'limit': jsonEncode(20)
    };
    // print(queryParams);
    // print(AppUrl.questions + '?' + Uri(queryParameters: queryParams).query);
    http.Response response = await http.get(
      Uri.parse(
          AppUrl.questions + '?' + Uri(queryParameters: queryParams).query),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'api-token': user!.token!
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      // print(responseData);
      if (responseData["status"] == true) {
        // print("messages returned");
        // print(response.body);

        return ApiResponse<Question>.fromJson(response.body, (dataItem) {
          Question question = Question.fromJson(dataItem);
          Map<String, dynamic> json = question.toJson();
          List<Map<String, dynamic>> jsonAnswer = [];
          question.answers!.forEach((answer) {
            jsonAnswer.add(answer.toJson());
          });
          json.addAll({'answers': jsonAnswer});
          return Question.fromJson(json);
        });
      } else {
        // print("not successful event");
      }
    } else {
      // print("Failed ....");
      // print(response.statusCode);
      // print(response.body);
    }
  }

//  saveQuestionsLocally (List<Question> questions) {
//     QuestionDB().insertAll(questions);
//   }

  saveTestTaken(TestTaken test) {
    TestTakenDB().insert(test);
  }

  saveConquestTestTaken(TestTaken test) {
    ConquestTestTakenDB().conquestInsert(test);
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

  Future<int> getQuestionsCount(int courseId) async {
    return await QuestionDB().getTotalQuestionCount(courseId);
  }

  Future<Map<String, List<TestAnswer>>> topicsAnalysis(TestTaken test) async {
    Map<String, List<TestAnswer>> topicsMap = Map();

    String responses = test.responses;
    // print("respones:${test.responses}");

    responses = responses.replaceAll("(", "").replaceAll(")", "");
    // responses = jsonEncode(responses);
    // print(responses);
    Map<String, dynamic> res = json.decode(responses);
    // print(res.runtimeType);
    List<TestAnswer>? answers = fromMap(res, (answer) {
      // print(answer);
      return TestAnswer.fromJson(answer);
    });

    answers!.forEach((answer) {
      //  print("answer.topicName:${answer.topicName}");
      topicsMap.update("${answer.topicName}", (list) {
        list.add(answer);
        return list;
      }, ifAbsent: () {
        return [answer];
      });
    });

    return topicsMap;
  }

  Future<List<Question>> getAllQuestions(TestTaken test, {int? topicId}) async {
    String responses = test.responses;
    // print("respones:");

    responses = responses.replaceAll("(", "").replaceAll(")", "");
    // responses = jsonEncode(responses);
    // print(responses);
    Map<String, dynamic> res = json.decode(responses);
    // print(res.runtimeType);
    List<TestAnswer>? answers = fromMap(res, (answer) {
      // print(answer);
      return TestAnswer.fromJson(answer);
    });

    List<Question> questions = [];
    for (int i = 0; i < answers!.length; i++) {
      TestAnswer answer = answers[i];
      //  print("answer questionId:${answer.questionId}");
      Question? question;
      if (topicId == null) {
        question = await QuestionDB().getQuestionById(answer.questionId!);
      } else {
        question = await QuestionDB()
            .getQuestionByIdTopicId(answer.questionId!, topicId);
      }
      if (question != null) {
        if (answer.selectedAnswerId != null) {
          question.selectedAnswer =
              await AnswerDB().getAnswerById(answer.selectedAnswerId!);
        }

        questions.add(question);
      }
    }

    print("questions:${questions.length}");
    return questions;
  }

  fromMap(Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    List<TestAnswer> data = [];
    json.forEach((k, v) {
      // print(k);
      data.add(create(v));
    });

    // print(data);
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

  getEssayTests(Course course) async {
    List<Quiz> quizzes = await QuizDB().getQuizzesByType(course.id!, "ESSAY");

    List<TestNameAndCount> testNames = [];
    for (int i = 0; i < quizzes.length; i++) {
      Quiz quiz = quizzes[i];
      int totalCount = await QuizDB().getQuestionsCount(quiz.id!);
      testNames.add(
        TestNameAndCount(
          quiz.name!,
          0,
          totalCount,
          id: quiz.id,
          category: TestCategory.ESSAY,
        ),
      );
    }

    return testNames;
  }

  getLevelTopic(Course course, int? level) {
    return TopicDB().getLevelTopic(course.id!, level!);
  }

  Future<List<TestNameAndCount>> getTopics(Course course) async {
    Map<int, String> topics = await QuestionDB().questionTopics(course.id!);

    List<TestNameAndCount> testNames = [];
    for (int i = 0; i < topics.length; i++) {
      int id = topics.keys.toList()[i];
      Topic? topic = await TopicDB().getTopicById(id);
      if (topic == null) continue;
      String? name = topic.name!;

      int count =
          await getTopicAnsweredCount(course.id!, id, onlyAttempted: true);
      int totalCount = await QuestionDB().getTopicCount(id);
      double average = await getTopicAnsweredAverageScore(course.id!, id);

      // print("$id $name c=$count average=$average");
      testNames.add(TestNameAndCount(
        name,
        count,
        totalCount,
        averageScore: average,
        id: id,
        category: TestCategory.TOPIC,
      ));
    }
    // print(testNames);
    return testNames;
  }

  getTopicsAndNotes(Course course) async {
    List<Topic> topics = await TopicDB().courseTopics(course);
    // print("topics and notes");
    // print(topics);
    return topics;
  }

  getEssays(Course course, int limit) async {
    List<Question> questions = await QuestionDB().getQuestionsByType(
      course.id!,
      "ESSAY",
      limit,
    );

    return questions;
  }

  getSavedTests(Course course, {limit = 10}) async {
    List<Question> questions = await QuestionDB()
        .getSavedTestQuestionsByType(course.id!, limit: limit);
    return questions;
  }

  getBankTest(Course course) async {
    List<Quiz> quizzes = await QuizDB().getQuizzesByName(course.id!, "BANK");

    List<TestNameAndCount> testNames = [];
    for (int i = 0; i < quizzes.length; i++) {
      Quiz quiz = quizzes[i];
      int totalCount = await QuizDB().getQuestionsCount(quiz.id!);
      testNames.add(TestNameAndCount(
        quiz.name!,
        0,
        totalCount,
        id: quiz.id,
        category: TestCategory.BANK,
      ));
    }

    return testNames;
  }

  Future<int> getTopicAnsweredCount(int courseId, int topicId,
      {bool onlyAttempted = false, bool onlyCorrect = false}) async {
    List<TestTaken> tests =
        await TestTakenDB().courseTestsTaken(courseId: courseId);
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

  Future<double> getTopicAnsweredAverageScore(
    int courseId,
    int topicId,
  ) async {
    List<TestTaken> tests =
        await TestTakenDB().courseTestsTaken(courseId: courseId);
    Map<String, dynamic> responses = Map();
    int index = 0;
    tests.forEach((test) {
      Map<String, dynamic> maps = jsonDecode(test.responses);
      maps.forEach((key, value) {
        if (responses.containsKey(key)) {
          key += "$index";
        }
        responses[key] = value;
      });
      index++;
    });

    List<Map<String, dynamic>> testAnswers = [];
    responses.forEach((key, value) {
      testAnswers.add(value);
    });

    List<int> topicIds = [];
    int noOfCorrect = 0;

    testAnswers.forEach((answer) {
      int tId = answer['topic_id'];
      if (tId == topicId) {
        if (answer['status'] == 'correct') noOfCorrect += 1;
        topicIds.add(tId);
      }
    });

    print("no of correct = $noOfCorrect, topicIds= ${topicIds.length}");

    if (topicIds.length == 0) return 0;
    return noOfCorrect / topicIds.length * 100;
  }

  Future<int> getQuestionsAnsweredCount(int courseId,
      {bool onlyAttempted = false, bool onlyCorrect = false}) async {
    List<TestTaken> tests =
        await TestTakenDB().courseTestsTaken(courseId: courseId);
    // print("number of test= ${tests.length}");
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
    if (totalQuestions == 0) return 0;
    return totalTaken / totalQuestions;
  }

  Future<List<TestTaken>> getTestTaken(String tag) {
    return TestTakenDB().courseTestsTaken(courseId: int.parse(tag));
  }

  Future<List<Question>> getCustomizedQuestions(
      Course course, int numberOfQuestions) async {
    List<Question> questions =
        await QuestionDB().getRandomQuestions(course.id!, numberOfQuestions);

    return questions;
  }

  Future<Marathon?> getCurrentMarathon(Course course) async {
    Marathon? marathon = await MarathonDB().getCurrentMarathon(course);
    return marathon;
  }

  Future<Treadmill?> getCurrentTreadmill(Course course) async {
    // print(topicId);
    Treadmill? treadmill = await TreadmillDB().getCurrentTreadmill(course);
    return treadmill;
  }
  Future<List<Treadmill>> getOngoingTreadmill() async {
    List<Treadmill> treadmills = await TreadmillDB().getOngoingTreadmill();
    return treadmills;
  }

  insertSaveTestQuestion(int qid) async {
    // Question? response = await  QuestionDB().getSavedTestQuestionById(qid);
    // print(savedQuestions);
    if (savedQuestions.contains(qid)) {
      await QuestionDB().deleteSavedTest(qid);
      savedQuestions.remove(qid);
      Question? response = await QuestionDB().getSavedTestQuestionById(qid);
      //  print("response::$response");
      toastMessage("Saved question removed successfully");
    } else {
      Question? questions = await QuestionDB().getQuestionById(qid);
      await QuestionDB().insertTestQuestion(questions!);
      Question? response =
          await QuestionDB().getSavedTestQuestionById(questions.id!);
      if (response != null) {
        //  print("response: ${response.id}");
        savedQuestions.add(qid);
        toastMessage("Question saved successfully");
      } else {
        //   print("response:$response");
      }
    }
  }

  getAllSaveTestQuestions() async {
    savedQuestions.clear();
    List<Question> questions = await QuestionDB().getSavedTestQuestion();
    for (int i = 0; i < questions.length; i++) {
      Question? response =
          await QuestionDB().getSavedTestQuestionById(questions[i].id!);
      // print("object:$response");
      if (response != null) {
        savedQuestions.add(response.id);
      }
    }
  }
}
