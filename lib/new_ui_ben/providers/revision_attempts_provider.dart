import 'package:flutter/cupertino.dart';

class RevisionAttemptProvider with ChangeNotifier {
  DateTime? startTime;
  int questionCount = 0;
  double avgScore = 0.0;
  Duration? timeTaken;

  setTime(DateTime dateTime) {
    startTime = dateTime;
  }

  setQuestionCount(int length) {
    questionCount = length;
    notifyListeners();
  }

  setAvgScore(double score) {
    avgScore = score;
    notifyListeners();
  }

  getTimeTaken() {
    timeTaken = DateTime.now().difference(startTime!);
    notifyListeners();
  }

  setQuestionCountAndAvgScore(
      {required int questionsLength, required double score}) {
    avgScore = score;
    questionCount = questionsLength;
    timeTaken = DateTime.now().difference(startTime!);
    notifyListeners();
  }
}
