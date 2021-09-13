import 'package:ecoach/models/api_response.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/questions_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionsController {
  loadDiagnoticQuestion(Level level, Course course) async {
    User? user = await UserPreferences().getUser();
    print(user!.token!);
    Map<String, dynamic> queryParams = {
      'level_id': "${level.id}",
      'course_id': "${course.id}",
      'limit': jsonEncode(10)
    };
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

  saveTestLocally(List<Question> questions) {
    QuestionDB().insertAll(questions);
  }
}
