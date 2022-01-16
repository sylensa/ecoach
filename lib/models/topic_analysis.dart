import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';

class TopicAnalysis {
  List<TestAnswer> answers;
  String name;
  Topic? topic;

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

  int get total {
    return answers.length;
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
    double performace = correct / answers.length;
    return double.parse(performace.toStringAsFixed(2));
  }

  String get performanceNote {
    if (performace == 95) {
      return "Excellent";
    } else if (performace >= 80) {
      return "Very Good";
    } else if (performace >= 60) {
      return "Good, more room for improvement";
    } else if (performace >= 40) {
      return "Average Performance, need improvement";
    } else {
      return "Poor Performance";
    }
  }
}
