import 'package:ecoach/models/test_taken.dart';

class TopicAnalysis {
  List<TestAnswer> answers;
  String name;

  TopicAnalysis(this.name, this.answers);

  int get time {
    int time = 0;
    answers.forEach((element) {
      if (element.isCorrect) {
        time++;
      }
    });
    return time;
  }

  int get correct {
    int score = 0;
    answers.forEach((question) {
      if (question.isCorrect) score++;
    });
    return score;
  }

  int get wrong {
    int wrong = 0;
    answers.forEach((question) {
      if (question.isWrong) wrong++;
    });
    return wrong;
  }

  int get unattempted {
    int unattempted = 0;
    answers.forEach((question) {
      if (question.unattempted) unattempted++;
    });
    return unattempted;
  }

  double get performace {
    return correct / answers.length;
  }
}
